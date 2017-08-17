------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    10:43 2016-08-04
-- Module Name:    OPTOHYBRID
-- Description:    This module handles all communications with the optohybrid and VFATs
------------------------------------------------------------------------------------------------------------------------------------------------------

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
        g_OH_IDX        : std_logic_vector(3 downto 0);
        g_DEBUG         : boolean := false -- if this is set to true, some chipscope cores will be inserted
    );
    port(
        -- reset
        reset_i                 : in  std_logic;

        -- TTC
        ttc_clk_i               : in  t_ttc_clks;
        ttc_cmds_i              : in  t_ttc_cmds;
        
        -- VFAT3 common TX data stream
        vfat3_tx_datastream_i   : in std_logic_vector(7 downto 0);
        vfat3_tx_idle_i         : in std_logic;
        vfat3_sync_i            : in std_logic;
        vfat3_sync_verify_i     : in std_logic;
        
        -- FPGA control link
        gbt_rx_ready_i          : in  std_logic_vector(2 downto 0);
        fpga_tx_data_o          : out std_logic_vector(9 downto 0);
        fpga_rx_data_i          : in  std_logic_vector(13 downto 0);

        -- VFAT3 links
        vfat3_tx_data_o         : out t_std8_array(23 downto 0);
        vfat3_rx_data_i         : in  t_std8_array(23 downto 0);
        
        -- VFAT3 slow control
        vfat3_sc_tx_data_i      : in std_logic;
        vfat3_sc_tx_empty_i     : in std_logic;
        vfat3_sc_tx_oh_idx_i    : in std_logic_vector(3 downto 0);
        vfat3_sc_tx_vfat_idx_i  : in std_logic_vector(4 downto 0);
        vfat3_sc_tx_rd_en_o     : out std_logic;
        
        vfat3_sc_rx_data_o      : out std_logic_vector(23 downto 0);
        vfat3_sc_rx_data_en_o   : out std_logic_vector(23 downto 0);
        
        -- Trigger links
        gth_rx_trig_data_i      : in t_gt_8b10b_rx_data_arr(1 downto 0);
        sbit_clusters_o         : out t_oh_sbits;
        sbit_links_status_o     : out t_oh_sbit_links;
        
        -- DAQ data
        tk_data_link_o          : out t_data_link;
        tk_error_o              : out std_logic;
        tk_evt_received_o       : out std_logic;
        
        -- OH reg forwarding IPbus
        oh_reg_ipb_reset_i      : in  std_logic;
        oh_reg_ipb_clk_i        : in  std_logic;
        oh_reg_ipb_reg_miso_o   : out ipb_rbus;
        oh_reg_ipb_reg_mosi_i   : in  ipb_wbus;

        -- debug
        debug_vfat_select_i     : in std_logic_vector(4 downto 0)
        
    );
end optohybrid;

architecture optohybrid_arch of optohybrid is
    
    component ila_vfat3
    port (
        clk    : in std_logic;
        probe0 : in std_logic_vector(7 DOWNTO 0); 
        probe1 : in std_logic; 
        probe2 : in std_logic; 
        probe3 : in std_logic; 
        probe4 : in std_logic; 
        probe5 : in std_logic_vector(7 DOWNTO 0); 
        probe6 : in std_logic_vector(7 DOWNTO 0); 
        probe7 : in std_logic;
        probe8 : in std_logic_vector(2 DOWNTO 0);
        probe9 : in std_logic_vector(7 DOWNTO 0)
    );
    end component;
    
    --== VFAT3 signals ==--
    signal vfat3_rx_ready           : std_logic_vector(23 downto 0);
    signal vfat3_sync_ok            : std_logic_vector(23 downto 0);
    signal vfat3_rx_num_bitslips    : t_std3_array(23 downto 0);
    signal vfat3_rx_sync_err_cnt    : t_std8_array(23 downto 0);
    
    signal vfat3_tx_data            : t_std8_array(23 downto 0);
    signal vfat3_rx_aligned_data    : t_std8_array(23 downto 0);
    
    signal vfat3_sc_tx_en           : std_logic_vector(23 downto 0);
    signal vfat3_sc_tx_rd_en        : std_logic_vector(23 downto 0);
    
    --== FPGA register access requests ==--
    
    signal g2o_req_en               : std_logic;
    signal g2o_req_valid            : std_logic;
    signal g2o_req_data             : std_logic_vector(64 downto 0);
    
    signal o2g_req_en               : std_logic;
    signal o2g_req_data             : std_logic_vector(31 downto 0);
    signal o2g_req_error            : std_logic;    
    
    --== DAQ data ==--
    
    signal evt_en                   : std_logic;
    signal evt_data                 : std_logic_vector(15 downto 0);

    --== Debug ==--

    signal dbg_vfat3_tx_data            : std_logic_vector(7 downto 0);
    signal dbg_vfat3_rx_data            : std_logic_vector(7 downto 0);
    signal dbg_vfat3_rx_aligned_data    : std_logic_vector(7 downto 0);
    signal dbg_vfat3_sync_ok            : std_logic;
    signal dbg_vfat3_rx_num_bitslips    : std_logic_vector(2 downto 0);
    signal dbg_vfat3_rx_sync_err_cnt    : std_logic_vector(7 downto 0);
    
begin

    --==========================--
    --==        Wiring        ==--
    --==========================--
    vfat3_tx_data_o <= vfat3_tx_data;

    --------------------------------------- old
    tk_data_link_o.clk <= ttc_clk_i.clk_80;
    
--    tk_data_link_o.data_en <= evt_en;
--    tk_data_link_o.data <= evt_data;

    ------------- zero wiring -------------
    fpga_tx_data_o <= (others => '0');
    sbit_clusters_o <= (others => (size => (others => '0'), address => (others => '0')));
    sbit_links_status_o <= (others => (valid => '0', sync_word => '0', missed_comma => '0', underflow => '0', overflow => '0'));
    tk_data_link_o.data <= (others => '0');
    tk_data_link_o.data_en <= '0';
    tk_error_o <= '0';
    tk_evt_received_o <= '0';
    
    oh_reg_ipb_reg_miso_o <= (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0');
    --------------------------------------- 

    --==========================--
    --==       VFAT3 TX       ==--
    --==========================--

    g_vfat3_tx_links : for i in 0 to 23 generate
    
        i_vfat3_tx_link : entity work.vfat3_tx_link
            port map(
                reset_i           => reset_i,
                ttc_clk_i         => ttc_clk_i,
                datastream_i      => vfat3_tx_datastream_i,
                datastream_idle_i => vfat3_tx_idle_i,
                num_bitslips_i    => "000",
                rx_ready_i        => vfat3_rx_ready(i),
                sc_data_i         => vfat3_sc_tx_data_i,
                sc_valid_i        => not vfat3_sc_tx_empty_i,
                sc_en_i           => vfat3_sc_tx_en(i),
                sc_rd_en_o        => vfat3_sc_tx_rd_en(i),
                elink_data_o      => vfat3_tx_data(i)
            );
            
            vfat3_sc_tx_en(i) <= '1' when vfat3_sc_tx_oh_idx_i = g_OH_IDX and vfat3_sc_tx_vfat_idx_i = std_logic_vector(to_unsigned(i, 5)) else '0';
            
    end generate;
    
    vfat3_sc_tx_rd_en_o <= or_reduce(vfat3_sc_tx_rd_en);
    
    --==========================--
    --==       VFAT3 RX       ==--
    --==========================--
    
    g_vfat3_rx_links : for i in 0 to 23 generate
    
        i_vfat3_rx_aligner : entity work.vfat3_rx_aligner
            port map(
                reset_i               => reset_i,
                ttc_clk_i             => ttc_clk_i,
                data_i                => vfat3_rx_data_i(i),
                sync_i                => vfat3_sync_i,
                sync_verify_i         => vfat3_sync_verify_i,
                sync_ok_o             => vfat3_sync_ok(i),
                num_bitslips_o        => vfat3_rx_num_bitslips(i),
                sync_verify_err_cnt_o => vfat3_rx_sync_err_cnt(i),
                data_o                => vfat3_rx_aligned_data(i)
            );
    
        i_vfat3_rx_link : entity work.vfat3_rx_link
            port map(
                reset_i             => reset_i,
                ttc_clk_i           => ttc_clk_i,
                data_i              => vfat3_rx_aligned_data(i),
                sync_ok_i           => vfat3_sync_ok(i),
                ready_o             => vfat3_rx_ready(i),
                daq_data_o          => open,
                daq_data_en_o       => open,
                daq_crc_error_o     => open,
                slow_ctrl_data_o    => vfat3_sc_rx_data_o(i),
                slow_ctrl_data_en_o => vfat3_sc_rx_data_en_o(i)
            );
    
    end generate;
    
    
    --==========================--
    --==   OH Control link   ==--
    --==========================--
    
--    i_gbt_tx_link : entity work.link_gbt_tx
--        port map(
--            ttc_clk_40_i          => ttc_clk_i.clk_40,
--            reset_i               => reset_i,
--            vfat2_t1_i            => vfat2_t1,
--            req_en_o              => g2o_req_en,
--            req_valid_i           => g2o_req_valid,
--            req_data_i            => g2o_req_data,
--            gbt_tx_data_o         => gbt_tx_data_o
--        );
    
    --==========================--
    --==   OH RX link   ==--
    --==========================--
    
--    i_gbt_rx_link : entity work.link_gbt_rx
--        port map(
--            ttc_clk_40_i            => ttc_clk_i.clk_40,
--            ttc_clk_80_i            => ttc_clk_i.clk_80,
--            reset_i                 => reset_i,
--            req_en_o                => o2g_req_en,
--            req_data_o              => o2g_req_data,
--            evt_en_o                => evt_en,
--            evt_data_o              => evt_data,
--            tk_error_o              => tk_error_o,
--            evt_rcvd_o              => tk_evt_received_o,
--            gbt_rx_data_i           => gbt_rx_data_i,
--            gbt_rx_ready_i          => gbt_rx_ready_i
--        );
        
    --=================================--
    --== Register request forwarding ==--
    --=================================--
    
--    i_reg_request : entity work.link_request
--        port map(
--            ipb_clk_i       => oh_reg_ipb_clk_i,
--            gtx_rx_clk_i    => ttc_clk_i.clk_40,
--            gtx_tx_clk_i    => ttc_clk_i.clk_40,
--            reset_i         => oh_reg_ipb_reset_i,        
--            ipb_mosi_i      => oh_reg_ipb_reg_mosi_i,
--            ipb_miso_o      => oh_reg_ipb_reg_miso_o,        
--            tx_en_i         => g2o_req_en,
--            tx_valid_o      => g2o_req_valid,
--            tx_data_o       => g2o_req_data,        
--            rx_en_i         => o2g_req_en,
--            rx_data_i       => o2g_req_data        
--        );
     
    --=========================--
    --==   RX Trigger Link   ==--
    --=========================--
    
--    -- TODO: need sync fifos for incoming trig data (take from link_hub.vhd)
--    
--    i_link_rx_trigger0 : entity work.link_rx_trigger
--        port map(
--            ttc_clk_i           => ttc_clk_i.clk_40,
--            reset_i             => reset_i,
--            gt_rx_trig_usrclk_i => ttc_clk_i.clk_160,
--            rx_kchar_i          => gth_rx_trig_data_i(0).rxcharisk(1 downto 0),
--            rx_data_i           => gth_rx_trig_data_i(0).rxdata(15 downto 0),
--            sbit_cluster0_o     => sbit_clusters_o(0),
--            sbit_cluster1_o     => sbit_clusters_o(1),
--            sbit_cluster2_o     => sbit_clusters_o(2),
--            sbit_cluster3_o     => sbit_clusters_o(3),
--            link_status_o       => sbit_links_status_o(0)
--        );
--     
--    i_link_rx_trigger1 : entity work.link_rx_trigger
--        port map(
--            ttc_clk_i           => ttc_clk_i.clk_40,
--            reset_i             => reset_i,
--            gt_rx_trig_usrclk_i => ttc_clk_i.clk_160,
--            rx_kchar_i          => gth_rx_trig_data_i(1).rxcharisk(1 downto 0),
--            rx_data_i           => gth_rx_trig_data_i(1).rxdata(15 downto 0),
--            sbit_cluster0_o     => sbit_clusters_o(4),
--            sbit_cluster1_o     => sbit_clusters_o(5),
--            sbit_cluster2_o     => sbit_clusters_o(6),
--            sbit_cluster3_o     => sbit_clusters_o(7),
--            link_status_o       => sbit_links_status_o(1)
--        );
        
    --============================--
    --==        Debug           ==--
    --============================--
    
    gen_debug:
    if g_DEBUG generate

        dbg_vfat3_tx_data           <= vfat3_tx_data(to_integer(unsigned(debug_vfat_select_i)));
        dbg_vfat3_rx_data           <= vfat3_rx_data_i(to_integer(unsigned(debug_vfat_select_i)));
        dbg_vfat3_rx_aligned_data   <= vfat3_rx_aligned_data(to_integer(unsigned(debug_vfat_select_i)));
        dbg_vfat3_sync_ok           <= vfat3_sync_ok(to_integer(unsigned(debug_vfat_select_i)));
        dbg_vfat3_rx_num_bitslips   <= vfat3_rx_num_bitslips(to_integer(unsigned(debug_vfat_select_i)));
        dbg_vfat3_rx_sync_err_cnt   <= vfat3_rx_sync_err_cnt(to_integer(unsigned(debug_vfat_select_i)));
        
        i_vfat_ila : ila_vfat3
            port map(
                clk    => ttc_clk_i.clk_40,
                probe0 => dbg_vfat3_tx_data,
                probe1 => vfat3_tx_idle_i,
                probe2 => reset_i,
                probe3 => vfat3_sync_i,
                probe4 => vfat3_sync_verify_i,
                probe5 => dbg_vfat3_rx_data,
                probe6 => dbg_vfat3_rx_aligned_data,
                probe7 => dbg_vfat3_sync_ok,
                probe8 => dbg_vfat3_rx_num_bitslips,
                probe9 => dbg_vfat3_rx_sync_err_cnt
            );

    end generate;     
     
end optohybrid_arch;
