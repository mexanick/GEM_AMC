------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    00:33 2017-08-14
-- Module Name:    VFAT3 SC RX
-- Description:    This module accepts VFAT3 slow control 1 bit serial stream and decodes incoming packets. It has to be reset before each packet and given the expected transaction ID. 
------------------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.gem_pkg.all;
use work.sca_pkg.all;

entity vfat3_sc_rx is
    port(
        -- reset
        reset_i                 : in  std_logic;

        -- clocks
        clk_40_i                : in  std_logic;
        
        -- serial input
        data_i                  : in  std_logic;
        data_en_i               : in  std_logic;

        -- control
        transaction_id_i        : in  std_logic_vector(7 downto 0);
        is_write_i              : in  std_logic;
        
        -- output
        error_o                 : out std_logic;
        packet_valid_o          : out std_logic;
        reg_value_o             : out std_logic_vector(31 downto 0);
        
        -- monitoring
        bitstuff_err_cnt_o      : out std_logic_vector(15 downto 0);
        crc_err_cnt_o           : out std_logic_vector(15 downto 0);
        packet_err_cnt_o        : out std_logic_vector(15 downto 0);
        
        -- debug
        calc_crc_o              : out std_logic_vector(15 downto 0);              
        raw_last_reply_o        : out std_logic_vector(95 downto 0)        
    );
end vfat3_sc_rx;

architecture vfat3_sc_rx_arch of vfat3_sc_rx is

    constant HDLC_ADDRESS   : std_logic_vector(7 downto 0) := x"00";
    constant HDLC_CONTROL   : std_logic_vector(7 downto 0) := x"03";
    constant IPBUS_VERSION  : std_logic_vector(3 downto 0) := x"2";
    
    type state_t is (IDLE, RECEIVING, DONE, ERROR);

    -- fsm signals
    signal state            : state_t;
    signal set_bit_cnt      : integer range 0 to 11;
    signal packet_pos       : integer range 0 to 104;
    signal min_length       : integer range 0 to 96; -- expected length of the packet

    -- errors
    signal crc_err          : std_logic; 
    signal bitstuff_err     : std_logic; 
    signal packet_err       : std_logic; 

    -- frame data
    signal packet           : std_logic_vector(103 downto 0);
    signal packet_length    : integer range 0 to 104;
    signal packet_crc       : std_logic_vector(15 downto 0);

    -- crc
    signal crc              : std_logic_vector(15 downto 0);
    signal crc_din          : std_logic;
    signal crc_en           : std_logic;
    signal crc_init         : std_logic;

    -- monitoring
    signal crc_err_cnt      : std_logic_vector(15 downto 0);
    signal bitstuff_err_cnt : std_logic_vector(15 downto 0);
    signal packet_err_cnt   : std_logic_vector(15 downto 0);

begin

    --========= Some wiring =========--
    
    crc_err_cnt_o <= crc_err_cnt;
    bitstuff_err_cnt_o <= bitstuff_err_cnt;
    packet_err_cnt_o <= packet_err_cnt;
    
    raw_last_reply_o <= packet(95 downto 0);
    calc_crc_o <= packet_crc;
    error_o <= '1' when state = ERROR else '0';

    min_length <= 64 when is_write_i = '1' else 96; -- for write transactions expecting 64bit packet, for read expecting 96bit packet (only 1 reg read is supported)

    --========= RX FSM =========--

    process(clk_40_i)
    begin
        if (rising_edge(clk_40_i)) then
            if (reset_i = '1') then
                state <= IDLE;
                packet_valid_o <= '0';
                packet_pos <= 0;
                packet_length <= 0;
                crc_init <= '1';
                crc_err <= '0';
                bitstuff_err <= '0';
                packet_err <= '0';
            else
                crc_err <= '0';
                bitstuff_err <= '0';
                packet_err <= '0';
                crc_en <= '0';
                crc_init <= '0';       
                crc_err <= '0';
                
                if (data_en_i = '1') then
                    
                    case state is
    
                        -- waiting for a start of frame
                        when IDLE =>
                            if ((set_bit_cnt = 6) and (data_i = '0')) then -- start of frame received (6 set bits followed by a 0)
                                state <= RECEIVING;
                            end if;
                            
                            packet_pos <= 0;
                            packet_length <= 0;
                            crc_init <= '1';
                            packet_valid_o <= '0';
                                                    
                        -- receiving an active frame
                        when RECEIVING =>
                            
                            -- if there are 5 set bits in a row, then next will be a stuffed zero which should be ignored
                            if (set_bit_cnt < 5) then
                                packet(packet_pos) <= data_i;
                                crc_din <= data_i;
                                crc_en <= '1';
    
                                packet_pos <= packet_pos + 1;
                                
                                -- byte boundary
                                if (packet_pos = packet_length + 8) then
                                    packet_length <= packet_pos;
                                    packet_crc <= crc;
                                end if;
                                
                                -- frame shouldn't be that long, go and wait for idle
                                if (packet_pos = 103) then
                                    state <= ERROR;
                                    packet_err <= '1';
                                end if;
                                
                            -- end of frame (EOF)
                            elsif ((set_bit_cnt = 6) and (data_i = '0')) then
                                state <= DONE;
                                
                                -- check the crc
                                if (packet_crc /= x"0000") then
                                    crc_err <= '1';
                                    --state <= ERROR;
                                    -- TODO: make this a hard error (go to error state, and replace the end if in the next line to else
                                end if;
                                    
                                -- if the packet is of expected length and various fields look as expected then great, otherwise shoot a packet error
                                if ((packet_length >= min_length) and
                                    (packet(7 downto 0) = HDLC_ADDRESS) and  -- HDLC address field check
                                    (packet(15 downto 8) = HDLC_CONTROL) and -- HDLC control field check
                                    (packet(47 downto 16) = IPBUS_VERSION & x"001" & transaction_id_i & "000" & is_write_i & x"0") -- IPbus header check
                                ) then
                                    packet_valid_o <= '1';
                                    reg_value_o <= packet(79 downto 48);                                    
                                else
                                    packet_err <= '1';
                                    state <= ERROR;
                                end if;
    
                            -- if it's not EOF and we have more than 5 set bits in a row, there's something wrong -- go and wait in the error state
                            elsif (set_bit_cnt > 5) then
                                state <= ERROR;
                                bitstuff_err <= '1';
                            end if;
                            
                        -- a place to stay after an error and wait for a reset
                        when ERROR =>
                            
                            packet_valid_o <= '0';
                            crc_err <= '0';
                            bitstuff_err <= '0';
                            packet_err <= '0';
                            state <= ERROR;

                        -- a place to stay after a successful packet reception and wait for a reset. Could just go to IDLE really, but this way it's a bit more controlled
                        when DONE =>
                            packet_valid_o <= '1';
                            state <= DONE;
                            
                        -- hmm    
                        when others =>
                            state <= ERROR;
                            
                    end case;
                    
                end if;
            end if;
        end if;
    end process;

    --========= Set bits counter =========--

    process(clk_40_i)
    begin
        if (rising_edge(clk_40_i)) then
            if (reset_i = '1') then
                set_bit_cnt <= 0;
            else
                if (data_en_i = '1') then
                    if (data_i = '0') then
                        set_bit_cnt <= 0;
                    elsif (set_bit_cnt < 10) then
                        set_bit_cnt <= set_bit_cnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    --========= CRC =========--

    i_crc : entity work.crc16_ccitt
        port map(
            clk_i        => clk_40_i,
            sync_reset_i => crc_init,
            data_i       => crc_din,
            data_en_i    => crc_en,
            crc_o        => crc
        );

    --========= Error counters =========--
    
    i_packet_err_cnt : entity work.counter
        generic map(
            g_COUNTER_WIDTH  => 16,
            g_ALLOW_ROLLOVER => false
        )
        port map(
            ref_clk_i => clk_40_i,
            reset_i   => reset_i,
            en_i      => packet_err,
            count_o   => packet_err_cnt
        );

    i_bitstuff_err_cnt : entity work.counter
        generic map(
            g_COUNTER_WIDTH  => 16,
            g_ALLOW_ROLLOVER => false
        )
        port map(
            ref_clk_i => clk_40_i,
            reset_i   => reset_i,
            en_i      => bitstuff_err,
            count_o   => bitstuff_err_cnt
        );

    i_crc_err_cnt : entity work.counter
        generic map(
            g_COUNTER_WIDTH  => 16,
            g_ALLOW_ROLLOVER => false
        )
        port map(
            ref_clk_i => clk_40_i,
            reset_i   => reset_i,
            en_i      => crc_err,
            count_o   => crc_err_cnt
        );

end vfat3_sc_rx_arch;