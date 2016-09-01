----------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evka85@gmail.com)
-- 
-- Create Date: 04/08/2016 10:43:39 AM
-- Design Name: 
-- Module Name: optohybrid_single - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

--use work.gth_pkg.all;
use work.ttc_pkg.all;
use work.gem_pkg.all;
use work.ipbus.all;

entity optohybrid is
    generic(
        g_USE_GBT       : boolean := true;  -- if this is true, GBT links will be used for communicationa with OH, if false 3.2Gbs 8b10b links will be used instead (remember to instanciate the correct links!)
        g_DEBUG         : boolean := false -- if this is set to true, some chipscope cores will be inserted
    );
    port(
        -- reset
        reset_i                 : in  std_logic;

        -- TTC
        ttc_clk_i               : in  t_ttc_clks;
        ttc_cmds_i              : in  t_ttc_cmds;
        
        -- Control and tracking data link 
        gth_rx_usrclk_i         : in  std_logic;
        gth_tx_usrclk_i         : in  std_logic;
        gth_rx_data_i           : in  t_gt_8b10b_rx_data;
        gth_tx_data_o           : out t_gt_8b10b_tx_data;

        -- GBT control/tracking link
        gbt_rx_ready_i          : in  std_logic; 
        gbt_rx_data_i           : in  std_logic_vector(83 downto 0);
        gbt_tx_data_o           : out std_logic_vector(83 downto 0);
        
        gbt_tx_sync_pattern_i   : in std_logic_vector(15 downto 0);
        gbt_rx_sync_pattern_i   : in std_logic_vector(31 downto 0);
        gbt_rx_sync_count_req_i : in std_logic_vector(7 downto 0);
        gbt_rx_sync_done_o      : out std_logic;            
        
        -- Trigger links
        gth_rx_trig_usrclk_i    : in  std_logic_vector(1 downto 0);
        gth_rx_trig_data_i      : in t_gt_8b10b_rx_data_arr(1 downto 0);
        sbit_clusters_o         : out t_oh_sbits;
        sbit_links_status_o     : out t_oh_sbit_links;
        
        -- Tracking data link
        tk_data_link_o          : out t_data_link;
        
        -- OH reg forwarding IPbus
        oh_reg_ipb_reset_i      : in  std_logic;
        oh_reg_ipb_clk_i        : in  std_logic;
        oh_reg_ipb_reg_miso_o   : out ipb_rbus;
        oh_reg_ipb_reg_mosi_i   : in  ipb_wbus;

        -- Link status and control
        link_status_o           : out t_oh_link_status;
        link_control_i          : t_oh_link_control;
        
        -- temporary for debugging the clocks
        debug_reset_cnt_i       : in std_logic;
        debug_clk_cnt_o         : out std_logic_vector(31 downto 0)
        
    );
end optohybrid;

architecture optohybrid_arch of optohybrid is
    
    COMPONENT sync_fifo_8b10b_16
        PORT(
            rst       : IN  STD_LOGIC;
            wr_clk    : IN  STD_LOGIC;
            rd_clk    : IN  STD_LOGIC;
            din       : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
            wr_en     : IN  STD_LOGIC;
            rd_en     : IN  STD_LOGIC;
            dout      : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
            full      : OUT STD_LOGIC;
            overflow  : OUT STD_LOGIC;
            empty     : OUT STD_LOGIC;
            valid     : OUT STD_LOGIC;
            underflow : OUT STD_LOGIC
        );
    END COMPONENT;
    
    signal vfat2_t1         : t_t1;
    
    signal gth_tx_data      : t_gt_8b10b_tx_data;
    
    --== Register requests ==--
    
    signal gbt_tx_req_en        : std_logic;
    signal gbt_tx_req_valid     : std_logic;
    signal gbt_tx_req_data      : std_logic_vector(64 downto 0);

    signal legacy_tx_req_en     : std_logic;
    signal legacy_tx_req_valid  : std_logic;
    signal legacy_tx_req_data   : std_logic_vector(64 downto 0);

    signal tx_req_en            : std_logic;
    signal tx_req_valid         : std_logic;
    signal tx_req_data          : std_logic_vector(64 downto 0);
        
    signal gbt_rx_req_en        : std_logic;
    signal gbt_rx_req_data      : std_logic_vector(31 downto 0);
    
    signal legacy_rx_req_en     : std_logic;
    signal legacy_rx_req_data   : std_logic_vector(31 downto 0);

    signal rx_req_en            : std_logic;
    signal rx_req_data          : std_logic_vector(31 downto 0);

    signal req_clk              : std_logic;
    
    --== Tracking data ==--
    
    signal gbt_evt_en           : std_logic;
    signal gbt_evt_data         : std_logic_vector(15 downto 0);

    signal legacy_evt_en        : std_logic;
    signal legacy_evt_data      : std_logic_vector(15 downto 0);

    signal gbt_tk_evt_rcvd      : std_logic;
    signal gbt_tk_error         : std_logic;
    
    signal legacy_tk_evt_rcvd   : std_logic;
    signal legacy_tk_error      : std_logic;

    --== Tracking sync FIFOs ==--

    signal sync_tk_rx_din       : std_logic_vector(23 downto 0);
    signal sync_tk_rx_dout      : std_logic_vector(23 downto 0);
    signal sync_tk_rx_ovf       : std_logic;
    signal sync_tk_rx_unf       : std_logic;

    signal sync_tk_tx_din       : std_logic_vector(23 downto 0);
    signal sync_tk_tx_dout      : std_logic_vector(23 downto 0);
    signal sync_tk_tx_ovf       : std_logic;
    signal sync_tk_tx_unf       : std_logic;

    --== Trigger RX sync FIFOs ==--

    signal sync_tr0_rx_din      : std_logic_vector(23 downto 0);
    signal sync_tr0_rx_dout     : std_logic_vector(23 downto 0);
    signal sync_tr0_rx_ovf      : std_logic;
    signal sync_tr0_rx_unf      : std_logic;

    signal sync_tr1_rx_din      : std_logic_vector(23 downto 0);
    signal sync_tr1_rx_dout     : std_logic_vector(23 downto 0);
    signal sync_tr1_rx_ovf      : std_logic;
    signal sync_tr1_rx_unf      : std_logic;
    
    --== GBT ==--
    signal gbt_rx_sync_done     : std_logic := '0';

    --== constant signals ==--
    
    signal tied_to_ground       : std_logic;
    signal tied_to_vcc          : std_logic;    

    --== debug signals ==--
    
    signal debug_tr_tx_link     : t_gt_8b10b_tx_data;
    signal debug_tr_rx_link     : t_gt_8b10b_rx_data;

    signal debug_tk_rx_clk_cnt  : std_logic_vector(15 downto 0);
    signal debug_ttc_clk_cnt    : std_logic_vector(15 downto 0);
    
begin

    gth_tx_data_o <= gth_tx_data;
   
    tk_data_link_o.data_en <= gbt_evt_en when link_control_i.daq_use_gbt = '1' else legacy_evt_en;
    tk_data_link_o.data <= gbt_evt_data when link_control_i.daq_use_gbt = '1' else legacy_evt_data;
    tk_data_link_o.clk <= ttc_clk_i.clk_80 when link_control_i.daq_use_gbt = '1' else ttc_clk_i.clk_160;

    vfat2_t1.lv1a       <= ttc_cmds_i.l1a;
    vfat2_t1.bc0        <= ttc_cmds_i.bc0;
    vfat2_t1.resync     <= '0';
    vfat2_t1.calpulse   <= '0';
    
    req_clk <= ttc_clk_i.clk_40 when link_control_i.reg_use_gbt = '1' else ttc_clk_i.clk_160;
    
    tx_req_en <= gbt_tx_req_en when link_control_i.reg_use_gbt = '1' else legacy_tx_req_en;
    gbt_tx_req_valid <= tx_req_valid when link_control_i.reg_use_gbt = '1' else '0';
    gbt_tx_req_data <= tx_req_data when link_control_i.reg_use_gbt = '1' else (others => '0');
    legacy_tx_req_valid <= tx_req_valid when link_control_i.reg_use_gbt = '1' else '0';
    legacy_tx_req_data <= tx_req_data when link_control_i.reg_use_gbt = '1' else (others => '0');
    
    rx_req_en <= gbt_rx_req_en when link_control_i.reg_use_gbt = '1' else legacy_rx_req_en;
    rx_req_data <= gbt_rx_req_data when link_control_i.reg_use_gbt = '1' else legacy_rx_req_data;
    
    -- constant signals
    tied_to_ground <= '0';
    tied_to_vcc <= '1';

    --==========================--
    --==      Sync FIFOs      ==--
    --==========================--

    ---==== Tracking / Control RX link ====---
    
    i_sync_rx_tracking : component sync_fifo_8b10b_16
        port map(
            rst       => reset_i,
            wr_clk    => gth_rx_usrclk_i,
            rd_clk    => ttc_clk_i.clk_160,
            din       => sync_tk_rx_din,
            wr_en     => tied_to_vcc,
            rd_en     => tied_to_vcc,
            dout      => sync_tk_rx_dout,
            full      => open,
            overflow  => sync_tk_rx_ovf,
            empty     => open,
            valid     => open,
            underflow => sync_tk_rx_unf
        );
        
    sync_tk_rx_din <= gth_rx_data_i.rxdisperr(1 downto 0) & gth_rx_data_i.rxnotintable(1 downto 0) & gth_rx_data_i.rxchariscomma(1 downto 0) & gth_rx_data_i.rxcharisk(1 downto 0) & gth_rx_data_i.rxdata(15 downto 0);

    ---==== Tracking / Control TX link ====---
    
    i_sync_tx_tracking : component sync_fifo_8b10b_16
        port map(
            rst       => reset_i,
            wr_clk    => ttc_clk_i.clk_160,
            rd_clk    => gth_tx_usrclk_i,
            din       => sync_tk_tx_din,
            wr_en     => tied_to_vcc,
            rd_en     => tied_to_vcc,
            dout      => sync_tk_tx_dout,
            full      => open,
            overflow  => sync_tk_tx_ovf,
            empty     => open,
            valid     => open,
            underflow => sync_tk_tx_unf
        );
            
    gth_tx_data.txdata(15 downto 0) <= sync_tk_tx_dout(15 downto 0);
    gth_tx_data.txcharisk(1 downto 0) <= sync_tk_tx_dout(17 downto 16);
    
    ---==== Trigger link 0 ====---

    i_sync_rx_trig0 : component sync_fifo_8b10b_16
        port map(
            rst       => reset_i,
            wr_clk    => gth_rx_trig_usrclk_i(0),
            rd_clk    => ttc_clk_i.clk_160,
            din       => sync_tr0_rx_din,
            wr_en     => tied_to_vcc,
            rd_en     => tied_to_vcc,
            dout      => sync_tr0_rx_dout,
            full      => open,
            overflow  => sync_tr0_rx_ovf,
            empty     => open,
            valid     => open,
            underflow => sync_tr0_rx_unf
        );

    sync_tr0_rx_din <= gth_rx_trig_data_i(0).rxdisperr(1 downto 0) & gth_rx_trig_data_i(0).rxnotintable(1 downto 0) & gth_rx_trig_data_i(0).rxchariscomma(1 downto 0) & gth_rx_trig_data_i(0).rxcharisk(1 downto 0) & gth_rx_trig_data_i(0).rxdata(15 downto 0);

    ---==== Trigger link 1 ====---

    i_sync_rx_trig1 : component sync_fifo_8b10b_16
        port map(
            rst       => reset_i,
            wr_clk    => gth_rx_trig_usrclk_i(1),
            rd_clk    => ttc_clk_i.clk_160,
            din       => sync_tr1_rx_din,
            wr_en     => tied_to_vcc,
            rd_en     => tied_to_vcc,
            dout      => sync_tr1_rx_dout,
            full      => open,
            overflow  => sync_tr1_rx_ovf,
            empty     => open,
            valid     => open,
            underflow => sync_tr1_rx_unf
        );
    
    sync_tr1_rx_din <= gth_rx_trig_data_i(1).rxdisperr(1 downto 0) & gth_rx_trig_data_i(1).rxnotintable(1 downto 0) & gth_rx_trig_data_i(1).rxchariscomma(1 downto 0) & gth_rx_trig_data_i(1).rxcharisk(1 downto 0) & gth_rx_trig_data_i(1).rxdata(15 downto 0);

    --==========================--
    --==      Link status     ==--
    --==========================--

    link_status_o.tk_tx_sync_status.ovf <= sync_tk_tx_ovf;
    link_status_o.tk_tx_sync_status.unf <= sync_tk_tx_unf;
    link_status_o.tk_rx_sync_status.ovf <= sync_tk_rx_ovf;
    link_status_o.tk_rx_sync_status.unf <= sync_tk_rx_unf;
    link_status_o.tr0_rx_sync_status.ovf <= sync_tr0_rx_ovf;
    link_status_o.tr0_rx_sync_status.unf <= sync_tr0_rx_unf;
    link_status_o.tr1_rx_sync_status.ovf <= sync_tr1_rx_ovf;
    link_status_o.tr1_rx_sync_status.unf <= sync_tr1_rx_unf;

    link_status_o.tk_rx_gt_status.not_in_table  <= sync_tk_rx_dout(21)  or sync_tk_rx_dout(20);
    link_status_o.tk_rx_gt_status.disperr       <= sync_tk_rx_dout(23)  or sync_tk_rx_dout(22);
    link_status_o.tr0_rx_gt_status.not_in_table <= sync_tr0_rx_dout(21) or sync_tr0_rx_dout(20);
    link_status_o.tr0_rx_gt_status.disperr      <= sync_tr0_rx_dout(23) or sync_tr0_rx_dout(22);
    link_status_o.tr1_rx_gt_status.not_in_table <= sync_tr1_rx_dout(21) or sync_tr1_rx_dout(20);
    link_status_o.tr1_rx_gt_status.disperr      <= sync_tr1_rx_dout(23) or sync_tr1_rx_dout(22);
            
    link_status_o.evt_rcvd <= gbt_tk_evt_rcvd when link_control_i.daq_use_gbt = '1' else legacy_tk_evt_rcvd;
    link_status_o.tk_error <= gbt_tk_error when link_control_i.daq_use_gbt = '1' else legacy_tk_error;
            
    gbt_rx_sync_done_o <= gbt_rx_sync_done;
        
    --==========================--
    --==   TX Tracking link   ==--
    --==========================--
    
    i_link_tx_tracking : entity work.link_tx_tracking
        port map(
            gtx_clk_i   => ttc_clk_i.clk_160,   
            reset_i     => reset_i,           
            use_t1      => not link_control_i.ttc_use_gbt,
            use_req     => not link_control_i.reg_use_gbt,
            vfat2_t1_i  => vfat2_t1,        
            req_en_o    => legacy_tx_req_en,   
            req_valid_i => legacy_tx_req_valid,   
            req_data_i  => legacy_tx_req_data,           
            tx_kchar_o  => sync_tk_tx_din(17 downto 16),   
            tx_data_o   => sync_tk_tx_din(15 downto 0)
        );  

    i_gbt_tx_link : entity work.link_gbt_tx
        port map(
            ttc_clk_40_i          => ttc_clk_i.clk_40,
            reset_i               => reset_i,
            use_t1                => link_control_i.ttc_use_gbt,
            use_req               => link_control_i.reg_use_gbt,
            vfat2_t1_i            => vfat2_t1,
            req_en_o              => gbt_tx_req_en,
            req_valid_i           => gbt_tx_req_valid,
            req_data_i            => gbt_tx_req_data,
            gbt_tx_data_o         => gbt_tx_data_o,
            gbt_tx_sync_pattern_i => gbt_tx_sync_pattern_i,
            gbt_rx_sync_done_i    => gbt_rx_sync_done
        );
    
    --==========================--
    --==   RX Tracking link   ==--
    --==========================--
    
    i_link_rx_tracking : entity work.link_rx_tracking
        port map(
            gtx_clk_i   => ttc_clk_i.clk_160,   
            reset_i     => reset_i,           
            req_en_o    => legacy_rx_req_en,   
            req_data_o  => legacy_rx_req_data,   
            evt_en_o    => legacy_evt_en,
            evt_data_o  => legacy_evt_data,
            tk_error_o  => legacy_tk_error,
            evt_rcvd_o  => legacy_tk_evt_rcvd,
            rx_kchar_i  => sync_tk_rx_dout(17 downto 16),   
            rx_data_i   => sync_tk_rx_dout(15 downto 0)        
        );

    i_gbt_rx_link : entity work.link_gbt_rx
        port map(
            ttc_clk_40_i            => ttc_clk_i.clk_40,
            ttc_clk_80_i            => ttc_clk_i.clk_80,
            reset_i                 => reset_i,
            req_en_o                => gbt_rx_req_en,
            req_data_o              => gbt_rx_req_data,
            evt_en_o                => gbt_evt_en,
            evt_data_o              => gbt_evt_data,
            tk_error_o              => gbt_tk_error,
            evt_rcvd_o              => gbt_tk_evt_rcvd,
            gbt_rx_data_i           => gbt_rx_data_i,
            gbt_rx_ready_i          => gbt_rx_ready_i,
            gbt_rx_sync_pattern_i   => gbt_rx_sync_pattern_i,
            gbt_rx_sync_count_req_i => gbt_rx_sync_count_req_i,
            gbt_rx_sync_done_o      => gbt_rx_sync_done
        );

    --=================================--
    --== Register request forwarding ==--
    --=================================--
    
    i_link_request : entity work.link_request
        port map(
            ipb_clk_i       => oh_reg_ipb_clk_i,
            gtx_rx_clk_i    => req_clk,
            gtx_tx_clk_i    => req_clk,
            reset_i         => oh_reg_ipb_reset_i,        
            ipb_mosi_i      => oh_reg_ipb_reg_mosi_i,
            ipb_miso_o      => oh_reg_ipb_reg_miso_o,        
            tx_en_i         => tx_req_en,
            tx_valid_o      => tx_req_valid,
            tx_data_o       => tx_req_data,        
            rx_en_i         => rx_req_en,
            rx_data_i       => rx_req_data        
            );
     
    --=========================--
    --==   RX Trigger Link   ==--
    --=========================--
    
    i_link_rx_trigger0 : entity work.link_rx_trigger
        port map(
            ttc_clk_i           => ttc_clk_i.clk_40,
            reset_i             => reset_i,
            gt_rx_trig_usrclk_i => ttc_clk_i.clk_160,
            rx_kchar_i          => sync_tr0_rx_dout(17 downto 16),
            rx_data_i           => sync_tr0_rx_dout(15 downto 0),
            sbit_cluster0_o     => sbit_clusters_o(0),
            sbit_cluster1_o     => sbit_clusters_o(1),
            sbit_cluster2_o     => sbit_clusters_o(2),
            sbit_cluster3_o     => sbit_clusters_o(3),
            link_status_o       => sbit_links_status_o(0)
        );
     
    i_link_rx_trigger1 : entity work.link_rx_trigger
        port map(
            ttc_clk_i           => ttc_clk_i.clk_40,
            reset_i             => reset_i,
            gt_rx_trig_usrclk_i => ttc_clk_i.clk_160,
            rx_kchar_i          => sync_tr1_rx_dout(17 downto 16),
            rx_data_i           => sync_tr1_rx_dout(15 downto 0),
            sbit_cluster0_o     => sbit_clusters_o(4),
            sbit_cluster1_o     => sbit_clusters_o(5),
            sbit_cluster2_o     => sbit_clusters_o(6),
            sbit_cluster3_o     => sbit_clusters_o(7),
            link_status_o       => sbit_links_status_o(1)
        );


    --============================--
    --==        Debug clocks    ==--
    --============================--

    i_tk_rx_clk_counter : entity work.counter
        generic map(
            g_COUNTER_WIDTH => 16,
            g_ALLOW_ROLLOVER => TRUE
        )
        port map(
            ref_clk_i => gth_rx_usrclk_i,
            reset_i   => debug_reset_cnt_i,
            en_i      => '1',
            count_o   => debug_tk_rx_clk_cnt
        );
        
    i_ttc_clk_counter : entity work.counter
        generic map(
            g_COUNTER_WIDTH  => 16,
            g_ALLOW_ROLLOVER => TRUE
        )
        port map(
            ref_clk_i => ttc_clk_i.clk_160,
            reset_i   => debug_reset_cnt_i,
            en_i      => '1',
            count_o   => debug_ttc_clk_cnt
        );
        
    debug_clk_cnt_o(15 downto 0) <= debug_tk_rx_clk_cnt;
    debug_clk_cnt_o(31 downto 16) <= debug_ttc_clk_cnt;
        
    --============================--
    --==        Debug           ==--
    --============================--
    
--    gen_debug:
--    if g_DEBUG and not g_USE_GBT generate
--        
--        --debug_tr_tx_link.txcharisk(1 downto 0) <= sync_tk_tx_din(17 downto 16); 
--
--        gt_tx_link_ila_inst : entity work.gt_tx_link_ila_wrapper
--            port map(
--                clk_i => ttc_clk_i.clk_160,
--                kchar_i => sync_tk_tx_din(17 downto 16),
--                data_i => sync_tk_tx_din(15 downto 0)
--            );
--        
--        sync_tk_rx_din <= gth_rx_data_i.rxdisperr(1 downto 0) & gth_rx_data_i.rxnotintable(1 downto 0) & gth_rx_data_i.rxchariscomma(1 downto 0) & gth_rx_data_i.rxcharisk(1 downto 0) & gth_rx_data_i.rxdata(15 downto 0);
--        gt_rx_link_ila_inst : entity work.gt_rx_link_ila_wrapper
--            port map(
--                clk_i => ttc_clk_i.clk_160,
--                kchar_i => sync_tk_rx_dout(17 downto 16),
--                comma_i => sync_tk_rx_dout(19 downto 18),
--                not_in_table_i => sync_tk_rx_dout(21 downto 20),
--                disperr_i => sync_tk_rx_dout(23 downto 22),
--                data_i => sync_tk_rx_dout(15 downto 0)
--            );
--    end generate;     
     
end optohybrid_arch;
