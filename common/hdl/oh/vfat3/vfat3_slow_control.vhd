------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    12:00 2017-08-09
-- Module Name:    VFAT3_SLOW_CONTROL
-- Description:    This module manages the VFAT3 slow control requests and responses for all VFATs within an optohybrid 
------------------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.ttc_pkg.all;
use work.gem_pkg.all;
use work.ipbus.all;

entity vfat3_slow_control is
    generic(
        g_NUM_OF_OHs         : integer
    );
    port(
        -- reset
        reset_i         : in  std_logic;
        
        -- clocks
        ttc_clk_i       : in  t_ttc_clks;
        ipb_clk_i       : in  std_logic;
        
        -- ipbus
        ipb_mosi_i      : in  ipb_wbus;
        ipb_miso_o      : out ipb_rbus;
        
        -- fifo I/O
        tx_data_o       : out std_logic;
        tx_rd_en_i      : in  std_logic;
        tx_empty_o      : out std_logic;
        tx_oh_idx_o     : out std_logic_vector(3 downto 0);
        tx_vfat_idx_o   : out std_logic_vector(4 downto 0);
        
        rx_data_en_i    : in t_std24_array(g_NUM_OF_OHs - 1 downto 0);
        rx_data_i       : in t_std24_array(g_NUM_OF_OHs - 1 downto 0)
    );
end vfat3_slow_control;

architecture vfat3_slow_control_arch of vfat3_slow_control is

    component vfat3_sc_tx_fifo
        port(
            clk   : in  std_logic;
            srst  : in  std_logic;
            din   : in  std_logic;
            wr_en : in  std_logic;
            rd_en : in  std_logic;
            dout  : out std_logic;
            full  : out std_logic;
            empty : out std_logic
        );
    end component;

    component vio_vfat3_sc
        port(
            clk       : IN STD_LOGIC;
            probe_in0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            probe_in1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            probe_in2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            probe_in3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            probe_in4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            probe_in5 : IN STD_LOGIC_VECTOR(111 DOWNTO 0);
            probe_in6 : IN STD_LOGIC_VECTOR(95 DOWNTO 0)
        );
    end component;

    type state_t is (IDLE, RSPD, RST);
        
    signal state                : state_t;

    signal tx_reset             : std_logic;
    signal rx_reset             : std_logic;

    signal transaction_id       : unsigned(7 downto 0) := (others => '0');

    signal tx_din               : std_logic := '0';
    signal tx_en                : std_logic := '0';
    signal tx_is_write          : std_logic := '0';
    signal tx_reg_addr          : std_logic_vector(31 downto 0) := (others => '0');
    signal tx_reg_value         : std_logic_vector(31 downto 0) := (others => '0');
    signal tx_command_en        : std_logic := '0';
    signal tx_oh_idx            : std_logic_vector(3 downto 0);
    signal tx_vfat_idx          : std_logic_vector(4 downto 0);

    signal rx_valid             : std_logic;
    signal rx_error             : std_logic;
    signal rx_reg_value         : std_logic_vector(31 downto 0) := (others => '0');
    signal rx_data              : std_logic;
    signal rx_data_en           : std_logic;
    
    signal rx_packet_err_cnt    : std_logic_vector(15 downto 0) := (others => '0');
    signal rx_bitstuff_err_cnt  : std_logic_vector(15 downto 0) := (others => '0');
    signal rx_crc_err_cnt       : std_logic_vector(15 downto 0) := (others => '0');
    
    -- DEBUG
    signal tx_calc_crc          : std_logic_vector(15 downto 0);
    signal rx_calc_crc          : std_logic_vector(15 downto 0);
    signal tx_raw_last_packet   : std_logic_vector(111 downto 0);
    signal rx_raw_last_reply    : std_logic_vector(95 downto 0);

    signal tx_calc_crc_last         : std_logic_vector(15 downto 0);
    signal rx_calc_crc_last         : std_logic_vector(15 downto 0);
    signal tx_raw_last_packet_last  : std_logic_vector(111 downto 0);
    signal rx_raw_last_reply_last   : std_logic_vector(95 downto 0);

begin

    tx_oh_idx_o <= tx_oh_idx;
    tx_vfat_idx_o <= tx_vfat_idx;

    --== IPbus process ==--

    process(ipb_clk_i)       
    begin    
        if (rising_edge(ipb_clk_i)) then      
            if (reset_i = '1') then    
                ipb_miso_o <= (ipb_err => '0', ipb_ack => '0', ipb_rdata => (others => '0'));
                tx_is_write <= '0';
                tx_reg_addr <= (others => '0');
                tx_reg_value <= (others => '0');
                tx_command_en <= '0';
                transaction_id <= (others => '0');
                state <= IDLE;
                tx_reset <= '1';
                rx_reset <= '1';
            else         
                case state is
                    when IDLE =>    
                    
                        -- waiting for a request from IPbus
                        if (ipb_mosi_i.ipb_strobe = '1') then
                            tx_command_en <= '1';
                            -- since VFAT3 is using 16 bits for register addressing, but only a few registers need more than 8 bits, we are using this remapping:
                            -- ipbus addr = 0x0xx is translated to VFAT3 addresses 0x00xx  
                            -- ipbus addr = 0x1xx is translated to VFAT3 addresses 0x10xx  
                            -- ipbus addr = 0x2xx is translated to VFAT3 addresses 0x20xx  
                            -- ipbus addr = 0x300 is translated to VFAT3 address   0xffff
                            tx_reg_addr(31 downto 16) <= (others => '0');
                            if (ipb_mosi_i.ipb_addr(9 downto 8) = "01") then
                                tx_reg_addr(15 downto 8) <= x"10";
                                tx_reg_addr(7 downto 0) <= ipb_mosi_i.ipb_addr(7 downto 0);
                            elsif (ipb_mosi_i.ipb_addr(9 downto 8) = "10") then
                                tx_reg_addr(15 downto 8) <= x"20";
                                tx_reg_addr(7 downto 0) <= ipb_mosi_i.ipb_addr(7 downto 0);
                            elsif (ipb_mosi_i.ipb_addr(9 downto 8) = "10") then
                                tx_reg_addr(15 downto 0) <= x"ffff";
                            end if;
                            
                            tx_is_write  <= ipb_mosi_i.ipb_write;
                            tx_reg_value <= ipb_mosi_i.ipb_wdata;
                            transaction_id <= transaction_id + 1;
                            
                            tx_oh_idx   <= ipb_mosi_i.ipb_addr(19 downto 16);
                            tx_vfat_idx <= ipb_mosi_i.ipb_addr(15 downto 11);
                            
                            tx_reset <= '0';
                            rx_reset <= '1';
                            
                            state <= RSPD;
                        end if;
                        
                    -- waiting for a VFAT3 response and replying to IPbus
                    when RSPD =>
                        
                        tx_command_en <= '0';
                        if (ipb_mosi_i.ipb_strobe = '0') then
                            state <= IDLE;     
                            tx_reset <= '1';
                            rx_reset <= '1';
                        elsif (rx_valid = '1') then
                            ipb_miso_o <= (ipb_ack => '1', ipb_err => '0', ipb_rdata => rx_reg_value);
                            state <= RST;
                        elsif (rx_error = '1') then
                            ipb_miso_o <= (ipb_ack => '1', ipb_err => '1', ipb_rdata => rx_reg_value);
                            state <= RST;
                        end if;

                        tx_reset <= '0';
                        rx_reset <= '0';
                        
                    -- closing the transaction and returning to idle
                    when RST =>
                        
                        ipb_miso_o.ipb_ack <= '0';
                        state <= IDLE;
                        tx_reset <= '1';
                        rx_reset <= '1';
                        
                        -- debug: grab the last crc and packet data before reset
                        tx_calc_crc_last <= tx_calc_crc;
                        rx_calc_crc_last <= rx_calc_crc;
                        tx_raw_last_packet_last <= tx_raw_last_packet;
                        rx_raw_last_reply_last <= rx_raw_last_reply;
                        
                    -- who knows what might happen :)
                    when others =>
                        
                        ipb_miso_o <= (ipb_err => '0', ipb_ack => '0', ipb_rdata => (others => '0')); 
                        state <= IDLE;
                        tx_is_write <= '0';
                        tx_reg_addr <= (others => '0');
                        tx_reg_value <= (others => '0');
                        tx_command_en <= '0';
                        tx_reset <= '1';
                        rx_reset <= '1';
                        
                end case;                      
            end if;        
        end if;        
    end process;

    i_vfat3_sc_tx : entity work.vfat3_sc_tx
        port map(
            reset_i           => reset_i or tx_reset,
            clk_40_i          => ttc_clk_i.clk_40,
            data_o            => tx_din,
            data_en_o         => tx_en,
            transaction_id_i  => std_logic_vector(transaction_id),
            is_write_i        => tx_is_write,
            reg_addr_i        => tx_reg_addr,
            reg_value_i       => tx_reg_value,
            command_en_i      => tx_command_en,
            busy_o            => open,
            calc_crc_o        => tx_calc_crc,
            raw_last_packet_o => tx_raw_last_packet
        );

    i_vfat3_sc_tx_fifo : vfat3_sc_tx_fifo
        port map(
            clk   => ttc_clk_i.clk_40,
            srst  => reset_i or tx_reset,
            din   => tx_din,
            wr_en => tx_en,
            rd_en => tx_rd_en_i,
            dout  => tx_data_o,
            full  => open,
            empty => tx_empty_o
        );

    i_vfat3_sc_rx : entity work.vfat3_sc_rx
        port map(
            reset_i            => reset_i or rx_reset,
            clk_40_i           => ttc_clk_i.clk_40,
            data_i             => rx_data,
            data_en_i          => rx_data_en,
            transaction_id_i   => std_logic_vector(transaction_id),
            is_write_i         => tx_is_write,
            error_o            => rx_error,
            packet_valid_o     => rx_valid,
            reg_value_o        => rx_reg_value,
            bitstuff_err_cnt_o => rx_bitstuff_err_cnt,
            crc_err_cnt_o      => rx_crc_err_cnt,
            packet_err_cnt_o   => rx_packet_err_cnt,
            calc_crc_o         => rx_calc_crc,
            raw_last_reply_o   => rx_raw_last_reply
        );

    rx_data_en <= rx_data_en_i(to_integer(unsigned(tx_oh_idx)))(to_integer(unsigned(tx_vfat_idx)));
    rx_data <= rx_data_i(to_integer(unsigned(tx_oh_idx)))(to_integer(unsigned(tx_vfat_idx)));

    -- DEBUG
    i_vfat3_sc_vio : vio_vfat3_sc
        port map(
            clk       => ttc_clk_i.clk_40,
            probe_in0 => rx_packet_err_cnt,
            probe_in1 => rx_bitstuff_err_cnt,
            probe_in2 => rx_crc_err_cnt,
            probe_in3 => tx_calc_crc_last,
            probe_in4 => rx_calc_crc_last,
            probe_in5 => tx_raw_last_packet_last,
            probe_in6 => rx_raw_last_reply_last
        );
    
end vfat3_slow_control_arch;