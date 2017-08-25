library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gem_board_config_package.CFG_NUM_OF_OHs;

package gem_pkg is

    --========================--
    --==  Firmware version  ==--
    --========================-- 

    constant C_FIRMWARE_DATE    : std_logic_vector(31 downto 0) := x"20170825";
    constant C_FIRMWARE_MAJOR   : integer range 0 to 255        := 3;
    constant C_FIRMWARE_MINOR   : integer range 0 to 255        := 0;
    constant C_FIRMWARE_BUILD   : integer range 0 to 255        := 13;
    
    ------ Change log ------
    -- 1.8.6 no gbt sync procedure with oh
    -- 1.8.7 advanced ILA trigger for gbt link
    -- 1.8.8 tied unused 8b10b or gbt links to 0
    -- 1.8.9 disable automatic phase shifting, just use unknown phase from 160MHz ref clock, also use bufg for the MMCM feedback clock
    -- 1.8.9 special version with 8b10b main link moved to OH2 and longer IPBusBridge timeout (comms with OH are perfect, but can't read VFATs at all)
    -- 1.9.0 fixed TX phase alignment, removed MMCM reset (was driven by the GTH startup FSM and messing things up).
    --       if 0 shifts are applied it's known to result in bad phase, so for now just made that if this happens, 
    --       then lock is never asserted, which will prevent GTH startup from completing and will be clearly visible during FPGA programming.
    -- 1.9.1 using TTC 120MHz as the GBT common RX clock instead of recovered clock from the main link (so all links should work even if link 1 is not connected)
    -- 1.9.2 separate SCA controlers for each channel implemented. There's also inbuilt ability to broadcast JTAG and custom SCA commands to any set of selected channels
    -- 1.9.3 Added SCA not ready counters (since last SCA reset). This will show if the SCA communication is stable (once established). 
    --       If yes, we could add an automatic SCA reset + configure after each time the SCA ready goes high after being low.
    -- 1.9.4 Swapped calpulse and bc0 bits in the GBT link because the OH was reading them backwards. Also re-enabled forwarding of resync and calpulse to OH.
    
    --=== v3 branch ===--
    -- 3.0.0  First version for v3 electronics  
    -- 3.0.1  Sketched all main VFAT3 TX and RX blocks, but no slow control yet. Implemented TX and RX SYNC and SYNC verify procedures, sync error counts and RX bitslipping
    -- 3.0.2  First implementation of VFAT3 slow control 
    -- 3.0.3  Added a selector (controled through VIO) for debug GBT link and debug VFAT link (on OH #0 only)
    -- 3.0.4  Changed RX bitslipping proceduce -- now looking for low bits (instead of high bits) in the top (instead of bottom) of the previous word
    -- 3.0.5  Revert back to the original bitshifting procedure.. duh.. but update the rx VFAT3 words to the correct ones, not the ones listed in the JINST paper...
    -- 3.0.6  Added missing assignment to prev_word in vfat3_rx_aligner... :)
    -- 3.0.7  Removed double assignment to sync_ok signal, plus added some extra probes to debug the rx_aligner
    -- 3.0.8  Fixed a mistake in VFAT register addressing
    -- 3.0.9  Fixed read and write frame lengths in the slow control TX FSM
    -- 3.0.10 Fix CRC word count issue in vfat3_sc_tx 
    -- 3.0.11 Fixed tx CRC - it has to be sent MSB and INVERTED!!
    -- 3.0.12 Added more debugging in VFAT3 slow control, and updated VFAT3 SC RX with a more robust start-of-frame detection
    -- 3.0.13 Fixed slow_ctrl_data_en_o flag bug in vfat3_rx_link.vhd - this was getting stuck high after the first SC character.. duh..
    -- 3.0.14 Delay tx_command_en and transfer from ipb_clk to ttc40 domain

    --======================--
    --==      General     ==--
    --======================-- 
        
    constant C_LED_PULSE_LENGTH_TTC_CLK : std_logic_vector(20 downto 0) := std_logic_vector(to_unsigned(1_600_000, 21));

    function count_ones(s : std_logic_vector) return integer;
    function bool_to_std_logic(L : BOOLEAN) return std_logic;

    --======================--
    --== Config Constants ==--
    --======================-- 
    
    -- DAQ
    constant C_DAQ_FORMAT_VERSION     : std_logic_vector(3 downto 0)  := x"0";

    --============--
    --== Common ==--
    --============--   
    
    type t_std_array is array(integer range <>) of std_logic;
  
    type t_std32_array is array(integer range <>) of std_logic_vector(31 downto 0);
        
    type t_std24_array is array(integer range <>) of std_logic_vector(23 downto 0);

    type t_std16_array is array(integer range <>) of std_logic_vector(15 downto 0);

    type t_std14_array is array(integer range <>) of std_logic_vector(13 downto 0);

    type t_std10_array is array(integer range <>) of std_logic_vector(9 downto 0);

    type t_std8_array is array(integer range <>) of std_logic_vector(7 downto 0);

    type t_std4_array is array(integer range <>) of std_logic_vector(3 downto 0);

    type t_std3_array is array(integer range <>) of std_logic_vector(2 downto 0);

    type t_std2_array is array(integer range <>) of std_logic_vector(1 downto 0);

    --============--
    --==   GBT  ==--
    --============--   

    type t_gbt_frame_array is array(integer range <>) of std_logic_vector(83 downto 0);

    --=============--
    --==  VFAT3  ==--
    --=============--
    
    type t_vfat3_elinks_arr is array(integer range<>) of t_std8_array(23 downto 0);   

    --========================--
    --== GTH/GTX link types ==--
    --========================--

    type t_gt_8b10b_tx_data is record
        txdata         : std_logic_vector(31 downto 0);
        txcharisk      : std_logic_vector(3 downto 0);
        txchardispmode : std_logic_vector(3 downto 0);
        txchardispval  : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_rx_data is record
        rxdata          : std_logic_vector(31 downto 0);
        rxbyteisaligned : std_logic;
        rxbyterealign   : std_logic;
        rxcommadet      : std_logic;
        rxdisperr       : std_logic_vector(3 downto 0);
        rxnotintable    : std_logic_vector(3 downto 0);
        rxchariscomma   : std_logic_vector(3 downto 0);
        rxcharisk       : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_tx_data_arr is array(integer range <>) of t_gt_8b10b_tx_data;
    type t_gt_8b10b_rx_data_arr is array(integer range <>) of t_gt_8b10b_rx_data;

    type t_gt_gbt_data_arr is array(integer range <>) of std_logic_vector(39 downto 0);

    --========================--
    --== SBit cluster data  ==--
    --========================--

    type t_sbit_cluster is record
        size        : std_logic_vector(2 downto 0);
        address     : std_logic_vector(10 downto 0);
    end record;

    type t_oh_sbits is array(7 downto 0) of t_sbit_cluster;
    type t_oh_sbits_arr is array(integer range <>) of t_oh_sbits;

    type t_sbit_link_status is record
        valid           : std_logic;
        sync_word       : std_logic;
        missed_comma    : std_logic;
        underflow       : std_logic;
        overflow        : std_logic;
    end record;

    type t_oh_sbit_links is array(1 downto 0) of t_sbit_link_status;    
    type t_oh_sbit_links_arr is array(integer range <>) of t_oh_sbit_links;

    --====================--
    --==     DAQLink    ==--
    --====================--

    type t_daq_to_daqlink is record
        reset           : std_logic;
        ttc_clk         : std_logic;
        ttc_bc0         : std_logic;
        trig            : std_logic_vector(7 downto 0);
        tts_clk         : std_logic;
        tts_state       : std_logic_vector(3 downto 0);
        resync          : std_logic;
        event_clk       : std_logic;
        event_valid     : std_logic;
        event_header    : std_logic;
        event_trailer   : std_logic;
        event_data      : std_logic_vector(63 downto 0);
    end record;

    type t_daqlink_to_daq is record
        ready           : std_logic;
        almost_full     : std_logic;
        disperr_cnt     : std_logic_vector(15 downto 0);
        notintable_cnt  : std_logic_vector(15 downto 0);
    end record;

    --====================--
    --== DAQ data input ==--
    --====================--
    
    type t_data_link is record
        clk        : std_logic;
        data_en    : std_logic;
        data       : std_logic_vector(15 downto 0);
    end record;
    
    type t_data_link_array is array(integer range <>) of t_data_link;    

    --=====================================--
    --==   DAQ input status and control  ==--
    --=====================================--
    
    type t_daq_input_status is record
        evtfifo_empty           : std_logic;
        evtfifo_near_full       : std_logic;
        evtfifo_full            : std_logic;
        evtfifo_underflow       : std_logic;
        evtfifo_near_full_cnt   : std_logic_vector(15 downto 0);
        evtfifo_wr_rate         : std_logic_vector(16 downto 0);
        infifo_empty            : std_logic;
        infifo_near_full        : std_logic;
        infifo_full             : std_logic;
        infifo_underflow        : std_logic;
        infifo_near_full_cnt    : std_logic_vector(15 downto 0);
        infifo_wr_rate          : std_logic_vector(14 downto 0);
        tts_state               : std_logic_vector(3 downto 0);
        err_event_too_big       : std_logic;
        err_evtfifo_full        : std_logic;
        err_infifo_underflow    : std_logic;
        err_infifo_full         : std_logic;
        err_corrupted_vfat_data : std_logic;
        err_vfat_block_too_big  : std_logic;
        err_vfat_block_too_small: std_logic;
        err_event_bigger_than_24: std_logic;
        err_mixed_oh_bc         : std_logic;
        err_mixed_vfat_bc       : std_logic;
        err_mixed_vfat_ec       : std_logic;
        cnt_corrupted_vfat      : std_logic_vector(31 downto 0);
        eb_event_num            : std_logic_vector(23 downto 0);
        eb_max_timer            : std_logic_vector(23 downto 0);
        eb_last_timer           : std_logic_vector(23 downto 0);
        ep_vfat_block_data      : t_std32_array(6 downto 0);
    end record;

    type t_daq_input_status_arr is array(integer range <>) of t_daq_input_status;

    type t_daq_input_control is record
        eb_timeout_delay        : std_logic_vector(23 downto 0);
    end record;
    
    type t_daq_input_control_arr is array(integer range <>) of t_daq_input_control;

    --====================--
    --==   DAQ other    ==--
    --====================--

    type t_chamber_infifo_rd is record
        dout          : std_logic_vector(191 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
        data_cnt      : std_logic_vector(11 downto 0);
    end record;

    type t_chamber_infifo_rd_array is array(integer range <>) of t_chamber_infifo_rd;

    type t_chamber_evtfifo_rd is record
        dout          : std_logic_vector(59 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
        data_cnt      : std_logic_vector(11 downto 0);
    end record;

    type t_chamber_evtfifo_rd_array is array(integer range <>) of t_chamber_evtfifo_rd;

    --====================--
    --==     OH Link    ==--
    --====================--

    type t_sync_fifo_status is record
        ovf         : std_logic;
        unf         : std_logic;
    end record;
    
    type t_gt_status is record
        not_in_table    : std_logic;
        disperr         : std_logic;
    end record;

    type t_oh_link_status is record
        tk_error            : std_logic;
        evt_rcvd            : std_logic;
        tk_tx_sync_status   : t_sync_fifo_status;      
        tk_rx_sync_status   : t_sync_fifo_status;      
        tr0_rx_sync_status  : t_sync_fifo_status;      
        tr1_rx_sync_status  : t_sync_fifo_status;
        tk_rx_gt_status     : t_gt_status;     
        tr0_rx_gt_status    : t_gt_status;     
        tr1_rx_gt_status    : t_gt_status;     
    end record;
    
    type t_oh_link_status_arr is array(integer range <>) of t_oh_link_status;    
        
    --================--
    --== T1 command ==--
    --================--
    
    type t_t1 is record
        lv1a        : std_logic;
        calpulse    : std_logic;
        resync      : std_logic;
        bc0         : std_logic;
    end record;
    
    type t_t1_array is array(integer range <>) of t_t1;
	
end gem_pkg;
   
package body gem_pkg is

    function count_ones(s : std_logic_vector) return integer is
        variable temp : natural := 0;
    begin
        for i in s'range loop
            if s(i) = '1' then
                temp := temp + 1;
            end if;
        end loop;

        return temp;
    end function count_ones;

    function bool_to_std_logic(L : BOOLEAN) return std_logic is
    begin
        if L then
            return ('1');
        else
            return ('0');
        end if;
    end function bool_to_std_logic;
    
end gem_pkg;
