library IEEE;
use IEEE.STD_LOGIC_1164.all;

-----> !! This package is auto-generated from an address table file using <repo_root>/scripts/generate_registers.py !! <-----
package registers is

    --============================================================================
    --       >>> TTC Module <<<    base address: 0x00300000
    --
    -- TTC control and monitoring. It takes care of locking to the TTC clock
    -- coming from the backplane as well as decoding TTC commands and forwarding
    -- that to all other modules in the design. It also provides several control
    -- and monitoring registers (resets, command decoding configuration, clock and
    -- data status, bc0 status, command counters and a small spy buffer)
    --============================================================================

    constant REG_TTC_NUM_REGS : integer := 22;
    constant REG_TTC_ADDRESS_MSB : integer := 5;
    constant REG_TTC_ADDRESS_LSB : integer := 0;
    constant REG_TTC_CTRL_L1A_ENABLE_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_L1A_ENABLE_BIT    : integer := 0;
    constant REG_TTC_CTRL_L1A_ENABLE_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_MMCM_PHASE_SHIFT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_MMCM_PHASE_SHIFT_BIT    : integer := 28;

    constant REG_TTC_CTRL_CNT_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_CNT_RESET_BIT    : integer := 29;

    constant REG_TTC_CTRL_MMCM_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_MMCM_RESET_BIT    : integer := 30;

    constant REG_TTC_CTRL_MODULE_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_MODULE_RESET_BIT    : integer := 31;

    constant REG_TTC_CONFIG_CMD_BC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_BC0_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_BC0_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_BC0_DEFAULT : std_logic_vector(7 downto 0) := x"01";

    constant REG_TTC_CONFIG_CMD_EC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_EC0_MSB    : integer := 15;
    constant REG_TTC_CONFIG_CMD_EC0_LSB     : integer := 8;
    constant REG_TTC_CONFIG_CMD_EC0_DEFAULT : std_logic_vector(15 downto 8) := x"02";

    constant REG_TTC_CONFIG_CMD_RESYNC_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_RESYNC_MSB    : integer := 23;
    constant REG_TTC_CONFIG_CMD_RESYNC_LSB     : integer := 16;
    constant REG_TTC_CONFIG_CMD_RESYNC_DEFAULT : std_logic_vector(23 downto 16) := x"04";

    constant REG_TTC_CONFIG_CMD_OC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_OC0_MSB    : integer := 31;
    constant REG_TTC_CONFIG_CMD_OC0_LSB     : integer := 24;
    constant REG_TTC_CONFIG_CMD_OC0_DEFAULT : std_logic_vector(31 downto 24) := x"08";

    constant REG_TTC_CONFIG_CMD_HARD_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_HARD_RESET_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_DEFAULT : std_logic_vector(7 downto 0) := x"10";

    constant REG_TTC_CONFIG_CMD_CALPULSE_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_CALPULSE_MSB    : integer := 15;
    constant REG_TTC_CONFIG_CMD_CALPULSE_LSB     : integer := 8;
    constant REG_TTC_CONFIG_CMD_CALPULSE_DEFAULT : std_logic_vector(15 downto 8) := x"14";

    constant REG_TTC_CONFIG_CMD_START_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_START_MSB    : integer := 23;
    constant REG_TTC_CONFIG_CMD_START_LSB     : integer := 16;
    constant REG_TTC_CONFIG_CMD_START_DEFAULT : std_logic_vector(23 downto 16) := x"18";

    constant REG_TTC_CONFIG_CMD_STOP_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_STOP_MSB    : integer := 31;
    constant REG_TTC_CONFIG_CMD_STOP_LSB     : integer := 24;
    constant REG_TTC_CONFIG_CMD_STOP_DEFAULT : std_logic_vector(31 downto 24) := x"1c";

    constant REG_TTC_CONFIG_CMD_TEST_SYNC_ADDR    : std_logic_vector(5 downto 0) := "00" & x"3";
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_DEFAULT : std_logic_vector(7 downto 0) := x"20";

    constant REG_TTC_STATUS_MMCM_LOCKED_ADDR    : std_logic_vector(5 downto 0) := "00" & x"4";
    constant REG_TTC_STATUS_MMCM_LOCKED_BIT    : integer := 0;

    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"5";
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"5";
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_BC0_LOCKED_ADDR    : std_logic_vector(5 downto 0) := "00" & x"6";
    constant REG_TTC_STATUS_BC0_LOCKED_BIT    : integer := 0;

    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"7";
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"8";
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"8";
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TTC_CMD_COUNTERS_L1A_ADDR    : std_logic_vector(5 downto 0) := "00" & x"9";
    constant REG_TTC_CMD_COUNTERS_L1A_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_L1A_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_BC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"a";
    constant REG_TTC_CMD_COUNTERS_BC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_BC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_EC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"b";
    constant REG_TTC_CMD_COUNTERS_EC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_EC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_RESYNC_ADDR    : std_logic_vector(5 downto 0) := "00" & x"c";
    constant REG_TTC_CMD_COUNTERS_RESYNC_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_RESYNC_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_OC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"d";
    constant REG_TTC_CMD_COUNTERS_OC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_OC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_HARD_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"e";
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_CALPULSE_ADDR    : std_logic_vector(5 downto 0) := "00" & x"f";
    constant REG_TTC_CMD_COUNTERS_CALPULSE_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_CALPULSE_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_START_ADDR    : std_logic_vector(5 downto 0) := "01" & x"0";
    constant REG_TTC_CMD_COUNTERS_START_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_START_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_STOP_ADDR    : std_logic_vector(5 downto 0) := "01" & x"1";
    constant REG_TTC_CMD_COUNTERS_STOP_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_STOP_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_ADDR    : std_logic_vector(5 downto 0) := "01" & x"2";
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_LSB     : integer := 0;

    constant REG_TTC_L1A_ID_ADDR    : std_logic_vector(5 downto 0) := "01" & x"3";
    constant REG_TTC_L1A_ID_MSB    : integer := 23;
    constant REG_TTC_L1A_ID_LSB     : integer := 0;

    constant REG_TTC_L1A_RATE_ADDR    : std_logic_vector(5 downto 0) := "01" & x"4";
    constant REG_TTC_L1A_RATE_MSB    : integer := 31;
    constant REG_TTC_L1A_RATE_LSB     : integer := 0;

    constant REG_TTC_TTC_SPY_BUFFER_ADDR    : std_logic_vector(5 downto 0) := "01" & x"5";
    constant REG_TTC_TTC_SPY_BUFFER_MSB    : integer := 31;
    constant REG_TTC_TTC_SPY_BUFFER_LSB     : integer := 0;


    --============================================================================
    --       >>> TRIGGER Module <<<    base address: 0x00800000
    --
    -- Trigger module handles everything related to sbit cluster data (link
    -- synchronization, monitoring, local triggering, matching to L1A and
    -- reporting data to DAQ)
    --============================================================================

    constant REG_TRIGGER_NUM_REGS : integer := 400;
    constant REG_TRIGGER_ADDRESS_MSB : integer := 12;
    constant REG_TRIGGER_ADDRESS_LSB : integer := 0;
    constant REG_TRIGGER_CTRL_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_TRIGGER_CTRL_CNT_RESET_BIT    : integer := 30;

    constant REG_TRIGGER_CTRL_MODULE_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_TRIGGER_CTRL_MODULE_RESET_BIT    : integer := 31;

    constant REG_TRIGGER_CTRL_OH_KILL_MASK_ADDR    : std_logic_vector(12 downto 0) := '0' & x"001";
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_MSB    : integer := 23;
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_LSB     : integer := 0;
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"010";
    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"011";
    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"100";
    constant REG_TRIGGER_OH0_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"101";
    constant REG_TRIGGER_OH0_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"110";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"111";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"112";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"113";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"114";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"115";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"116";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"117";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"118";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"120";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"121";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"122";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"123";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"124";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"125";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"126";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"127";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"128";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a0";
    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a0";
    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a1";
    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a1";
    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a2";
    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a2";
    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a3";
    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a3";
    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a4";
    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a4";
    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f0";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f1";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f2";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f3";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f4";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f5";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f6";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f7";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"200";
    constant REG_TRIGGER_OH1_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"201";
    constant REG_TRIGGER_OH1_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"210";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"211";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"212";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"213";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"214";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"215";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"216";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"217";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"218";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"220";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"221";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"222";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"223";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"224";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"225";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"226";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"227";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"228";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a0";
    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a0";
    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a1";
    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a1";
    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a2";
    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a2";
    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a3";
    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a3";
    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a4";
    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a4";
    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f0";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f1";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f2";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f3";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f4";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f5";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f6";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f7";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"300";
    constant REG_TRIGGER_OH2_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"301";
    constant REG_TRIGGER_OH2_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"310";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"311";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"312";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"313";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"314";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"315";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"316";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"317";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"318";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"320";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"321";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"322";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"323";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"324";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"325";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"326";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"327";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"328";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a0";
    constant REG_TRIGGER_OH2_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a0";
    constant REG_TRIGGER_OH2_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a1";
    constant REG_TRIGGER_OH2_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a1";
    constant REG_TRIGGER_OH2_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a2";
    constant REG_TRIGGER_OH2_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a2";
    constant REG_TRIGGER_OH2_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a3";
    constant REG_TRIGGER_OH2_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a3";
    constant REG_TRIGGER_OH2_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a4";
    constant REG_TRIGGER_OH2_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a4";
    constant REG_TRIGGER_OH2_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f0";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f1";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f2";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f3";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f4";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f5";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f6";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f7";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"400";
    constant REG_TRIGGER_OH3_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"401";
    constant REG_TRIGGER_OH3_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"410";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"411";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"412";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"413";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"414";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"415";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"416";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"417";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"418";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"420";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"421";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"422";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"423";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"424";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"425";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"426";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"427";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"428";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a0";
    constant REG_TRIGGER_OH3_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a0";
    constant REG_TRIGGER_OH3_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a1";
    constant REG_TRIGGER_OH3_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a1";
    constant REG_TRIGGER_OH3_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a2";
    constant REG_TRIGGER_OH3_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a2";
    constant REG_TRIGGER_OH3_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a3";
    constant REG_TRIGGER_OH3_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a3";
    constant REG_TRIGGER_OH3_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a4";
    constant REG_TRIGGER_OH3_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a4";
    constant REG_TRIGGER_OH3_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f0";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f1";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f2";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f3";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f4";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f5";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f6";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f7";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"500";
    constant REG_TRIGGER_OH4_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"501";
    constant REG_TRIGGER_OH4_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"510";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"511";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"512";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"513";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"514";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"515";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"516";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"517";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"518";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"520";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"521";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"522";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"523";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"524";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"525";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"526";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"527";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"528";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a0";
    constant REG_TRIGGER_OH4_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a0";
    constant REG_TRIGGER_OH4_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a1";
    constant REG_TRIGGER_OH4_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a1";
    constant REG_TRIGGER_OH4_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a2";
    constant REG_TRIGGER_OH4_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a2";
    constant REG_TRIGGER_OH4_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a3";
    constant REG_TRIGGER_OH4_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a3";
    constant REG_TRIGGER_OH4_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a4";
    constant REG_TRIGGER_OH4_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a4";
    constant REG_TRIGGER_OH4_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f0";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f1";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f2";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f3";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f4";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f5";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f6";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f7";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"600";
    constant REG_TRIGGER_OH5_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"601";
    constant REG_TRIGGER_OH5_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"610";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"611";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"612";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"613";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"614";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"615";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"616";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"617";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"618";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"620";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"621";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"622";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"623";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"624";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"625";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"626";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"627";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"628";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a0";
    constant REG_TRIGGER_OH5_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a0";
    constant REG_TRIGGER_OH5_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a1";
    constant REG_TRIGGER_OH5_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a1";
    constant REG_TRIGGER_OH5_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a2";
    constant REG_TRIGGER_OH5_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a2";
    constant REG_TRIGGER_OH5_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a3";
    constant REG_TRIGGER_OH5_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a3";
    constant REG_TRIGGER_OH5_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a4";
    constant REG_TRIGGER_OH5_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a4";
    constant REG_TRIGGER_OH5_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f0";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f1";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f2";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f3";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f4";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f5";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f6";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f7";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"700";
    constant REG_TRIGGER_OH6_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"701";
    constant REG_TRIGGER_OH6_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"710";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"711";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"712";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"713";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"714";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"715";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"716";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"717";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"718";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"720";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"721";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"722";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"723";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"724";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"725";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"726";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"727";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"728";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a0";
    constant REG_TRIGGER_OH6_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a0";
    constant REG_TRIGGER_OH6_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a1";
    constant REG_TRIGGER_OH6_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a1";
    constant REG_TRIGGER_OH6_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a2";
    constant REG_TRIGGER_OH6_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a2";
    constant REG_TRIGGER_OH6_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a3";
    constant REG_TRIGGER_OH6_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a3";
    constant REG_TRIGGER_OH6_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a4";
    constant REG_TRIGGER_OH6_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a4";
    constant REG_TRIGGER_OH6_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f0";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f1";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f2";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f3";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f4";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f5";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f6";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f7";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"800";
    constant REG_TRIGGER_OH7_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"801";
    constant REG_TRIGGER_OH7_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"810";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"811";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"812";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"813";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"814";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"815";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"816";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"817";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"818";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"820";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"821";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"822";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"823";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"824";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"825";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"826";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"827";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"828";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a0";
    constant REG_TRIGGER_OH7_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a0";
    constant REG_TRIGGER_OH7_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a1";
    constant REG_TRIGGER_OH7_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a1";
    constant REG_TRIGGER_OH7_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a2";
    constant REG_TRIGGER_OH7_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a2";
    constant REG_TRIGGER_OH7_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a3";
    constant REG_TRIGGER_OH7_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a3";
    constant REG_TRIGGER_OH7_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a4";
    constant REG_TRIGGER_OH7_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a4";
    constant REG_TRIGGER_OH7_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f0";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f1";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f2";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f3";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f4";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f5";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f6";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f7";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"900";
    constant REG_TRIGGER_OH8_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"901";
    constant REG_TRIGGER_OH8_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"910";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"911";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"912";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"913";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"914";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"915";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"916";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"917";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"918";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"920";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"921";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"922";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"923";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"924";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"925";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"926";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"927";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"928";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a0";
    constant REG_TRIGGER_OH8_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a0";
    constant REG_TRIGGER_OH8_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a1";
    constant REG_TRIGGER_OH8_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a1";
    constant REG_TRIGGER_OH8_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a2";
    constant REG_TRIGGER_OH8_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a2";
    constant REG_TRIGGER_OH8_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a3";
    constant REG_TRIGGER_OH8_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a3";
    constant REG_TRIGGER_OH8_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a4";
    constant REG_TRIGGER_OH8_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a4";
    constant REG_TRIGGER_OH8_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f0";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f1";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f2";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f3";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f4";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f5";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f6";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f7";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a00";
    constant REG_TRIGGER_OH9_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a01";
    constant REG_TRIGGER_OH9_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a10";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a11";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a12";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a13";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a14";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a15";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a16";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a17";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a18";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a20";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a21";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a22";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a23";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a24";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a25";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a26";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a27";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a28";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa0";
    constant REG_TRIGGER_OH9_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa0";
    constant REG_TRIGGER_OH9_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa1";
    constant REG_TRIGGER_OH9_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa1";
    constant REG_TRIGGER_OH9_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa2";
    constant REG_TRIGGER_OH9_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa2";
    constant REG_TRIGGER_OH9_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa3";
    constant REG_TRIGGER_OH9_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa3";
    constant REG_TRIGGER_OH9_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa4";
    constant REG_TRIGGER_OH9_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa4";
    constant REG_TRIGGER_OH9_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af0";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af1";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af2";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af3";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af4";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af5";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af6";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af7";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b00";
    constant REG_TRIGGER_OH10_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b01";
    constant REG_TRIGGER_OH10_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b10";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b11";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b12";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b13";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b14";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b15";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b16";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b17";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b18";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b20";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b21";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b22";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b23";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b24";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b25";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b26";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b27";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b28";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba0";
    constant REG_TRIGGER_OH10_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba0";
    constant REG_TRIGGER_OH10_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba1";
    constant REG_TRIGGER_OH10_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba1";
    constant REG_TRIGGER_OH10_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba2";
    constant REG_TRIGGER_OH10_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba2";
    constant REG_TRIGGER_OH10_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba3";
    constant REG_TRIGGER_OH10_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba3";
    constant REG_TRIGGER_OH10_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba4";
    constant REG_TRIGGER_OH10_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba4";
    constant REG_TRIGGER_OH10_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf0";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf1";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf2";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf3";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf4";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf5";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf6";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf7";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c00";
    constant REG_TRIGGER_OH11_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c01";
    constant REG_TRIGGER_OH11_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c10";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c11";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c12";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c13";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c14";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c15";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c16";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c17";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c18";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c20";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c21";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c22";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c23";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c24";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c25";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c26";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c27";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c28";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca0";
    constant REG_TRIGGER_OH11_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca0";
    constant REG_TRIGGER_OH11_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca1";
    constant REG_TRIGGER_OH11_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca1";
    constant REG_TRIGGER_OH11_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca2";
    constant REG_TRIGGER_OH11_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca2";
    constant REG_TRIGGER_OH11_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca3";
    constant REG_TRIGGER_OH11_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca3";
    constant REG_TRIGGER_OH11_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca4";
    constant REG_TRIGGER_OH11_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca4";
    constant REG_TRIGGER_OH11_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf0";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf1";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf2";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf3";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf4";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf5";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf6";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf7";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;


    --============================================================================
    --       >>> GEM_SYSTEM Module <<<    base address: 0x00900000
    --
    -- This module is controlling GEM AMC System wide settings
    --============================================================================

    constant REG_GEM_SYSTEM_NUM_REGS : integer := 13;
    constant REG_GEM_SYSTEM_ADDRESS_MSB : integer := 16;
    constant REG_GEM_SYSTEM_ADDRESS_LSB : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0000";
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0001";
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_BOARD_ID_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0002";
    constant REG_GEM_SYSTEM_BOARD_ID_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_BOARD_ID_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_BOARD_ID_DEFAULT : std_logic_vector(15 downto 0) := x"beef";

    constant REG_GEM_SYSTEM_BOARD_TYPE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0002";
    constant REG_GEM_SYSTEM_BOARD_TYPE_MSB    : integer := 19;
    constant REG_GEM_SYSTEM_BOARD_TYPE_LSB     : integer := 16;

    constant REG_GEM_SYSTEM_RELEASE_BUILD_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_BUILD_MSB    : integer := 7;
    constant REG_GEM_SYSTEM_RELEASE_BUILD_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_RELEASE_MINOR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_MINOR_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_RELEASE_MINOR_LSB     : integer := 8;

    constant REG_GEM_SYSTEM_RELEASE_MAJOR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_MAJOR_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_RELEASE_MAJOR_LSB     : integer := 16;

    constant REG_GEM_SYSTEM_RELEASE_DATE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0004";
    constant REG_GEM_SYSTEM_RELEASE_DATE_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_RELEASE_DATE_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_MSB    : integer := 4;
    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_CONFIG_USE_GBT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_USE_GBT_BIT    : integer := 8;

    constant REG_GEM_SYSTEM_CONFIG_USE_TRIG_LINKS_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_USE_TRIG_LINKS_BIT    : integer := 9;

    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0100";
    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_DEFAULT : std_logic_vector(15 downto 0) := x"76bc";

    constant REG_GEM_SYSTEM_CTRL_CNT_RESET_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0100";
    constant REG_GEM_SYSTEM_CTRL_CNT_RESET_BIT    : integer := 30;

    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0101";
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_DEFAULT : std_logic_vector(31 downto 0) := x"76bc76bc";

    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0102";
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_MSB    : integer := 7;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_DEFAULT : std_logic_vector(7 downto 0) := x"03";

    constant REG_GEM_SYSTEM_TESTS_GBT_LOOPBACK_EN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0200";
    constant REG_GEM_SYSTEM_TESTS_GBT_LOOPBACK_EN_BIT    : integer := 0;
    constant REG_GEM_SYSTEM_TESTS_GBT_LOOPBACK_EN_DEFAULT : std_logic := '0';

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0000";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0001";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0002";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_LSB     : integer := 0;


    --============================================================================
    --       >>> GEM_TESTS Module <<<    base address: 0x00a00000
    --
    -- This module is controlling various hardware tests e.g. fiber loopback
    --============================================================================

    constant REG_GEM_TESTS_NUM_REGS : integer := 109;
    constant REG_GEM_TESTS_ADDRESS_MSB : integer := 16;
    constant REG_GEM_TESTS_ADDRESS_LSB : integer := 0;
    constant REG_GEM_TESTS_CTRL_RESET_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0000";
    constant REG_GEM_TESTS_CTRL_RESET_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0100";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0101";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0102";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0110";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0111";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0112";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0120";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0121";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0122";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0130";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0131";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0132";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0140";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0141";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0142";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0150";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0151";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0152";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0160";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0161";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0162";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0170";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0171";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0172";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0180";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0181";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0182";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0190";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0191";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0192";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01a0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01a1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01a2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01b0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01b1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01b2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01c0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01c1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01c2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01d0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01d1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01d2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01e0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01e1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01e2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01f0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01f1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"01f2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0200";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0201";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0202";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0210";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0211";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0212";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0220";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0221";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0222";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0230";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0231";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0232";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0240";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0241";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0242";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0250";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0251";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0252";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0260";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0261";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0262";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0270";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0271";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0272";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0280";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0281";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0282";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0290";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0291";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0292";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02a0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02a1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02a2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02b0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02b1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02b2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02c0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02c1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02c2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02d0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02d1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02d2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02e0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02e1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02e2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02f0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02f1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"02f2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0300";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0301";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0302";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0310";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0311";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0312";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0320";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0321";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0322";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0330";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0331";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0332";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_ERROR_CNT_LSB     : integer := 0;


    --============================================================================
    --       >>> DAQ Module <<<    base address: 0x00700000
    --
    -- DAQ module buffers track data, builds events, analyses the data for
    -- consistency and ships off the events with all the needed headers and
    -- trailers to AMC13 over DAQLink
    --============================================================================

    constant REG_DAQ_NUM_REGS : integer := 206;
    constant REG_DAQ_ADDRESS_MSB : integer := 8;
    constant REG_DAQ_ADDRESS_LSB : integer := 0;
    constant REG_DAQ_CONTROL_DAQ_ENABLE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_DAQ_ENABLE_BIT    : integer := 0;
    constant REG_DAQ_CONTROL_DAQ_ENABLE_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT    : integer := 2;
    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_RESET_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_RESET_BIT    : integer := 3;
    constant REG_DAQ_CONTROL_RESET_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_TTS_OVERRIDE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_MSB    : integer := 7;
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_LSB     : integer := 4;
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_DEFAULT : std_logic_vector(7 downto 4) := x"0";

    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB    : integer := 31;
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB     : integer := 8;
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_DEFAULT : std_logic_vector(31 downto 8) := x"000001";

    constant REG_DAQ_STATUS_DAQ_LINK_RDY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_LINK_RDY_BIT    : integer := 0;

    constant REG_DAQ_STATUS_DAQ_CLK_LOCKED_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_CLK_LOCKED_BIT    : integer := 1;

    constant REG_DAQ_STATUS_TTC_RDY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_TTC_RDY_BIT    : integer := 2;

    constant REG_DAQ_STATUS_DAQ_LINK_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_LINK_AFULL_BIT    : integer := 3;

    constant REG_DAQ_STATUS_DAQ_OUTPUT_FIFO_HAD_OVERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_OUTPUT_FIFO_HAD_OVERFLOW_BIT    : integer := 4;

    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_BIT    : integer := 5;

    constant REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_BIT    : integer := 23;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_BIT    : integer := 24;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_BIT    : integer := 26;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_TTS_STATE_MSB    : integer := 31;
    constant REG_DAQ_STATUS_TTS_STATE_LSB     : integer := 28;

    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"02";
    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DISPER_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"03";
    constant REG_DAQ_EXT_STATUS_DISPER_ERR_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_DISPER_ERR_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_L1AID_ADDR    : std_logic_vector(8 downto 0) := '0' & x"04";
    constant REG_DAQ_EXT_STATUS_L1AID_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_L1AID_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_EVT_SENT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"05";
    constant REG_DAQ_EXT_STATUS_EVT_SENT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_EVT_SENT_LSB     : integer := 0;

    constant REG_DAQ_CONTROL_DAV_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"06";
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"03d090";

    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"07";
    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"08";
    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"09";
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_MSB    : integer := 12;
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"09";
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_MSB    : integer := 28;
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0a";
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0a";
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0b";
    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0b";
    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0c";
    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_LSB     : integer := 0;

    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0f";
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB    : integer := 23;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB     : integer := 0;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0f";
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB    : integer := 27;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB     : integer := 24;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_DEFAULT : std_logic_vector(27 downto 24) := x"0";

    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH0_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH0_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH0_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH0_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH0_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH0_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH0_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH0_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"11";
    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"12";
    constant REG_DAQ_OH0_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"13";
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"14";
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"14";
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"15";
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"15";
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"16";
    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"16";
    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"17";
    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"18";
    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"19";
    constant REG_DAQ_OH0_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1a";
    constant REG_DAQ_OH0_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1b";
    constant REG_DAQ_OH0_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1c";
    constant REG_DAQ_OH0_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1d";
    constant REG_DAQ_OH0_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1e";
    constant REG_DAQ_OH0_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1f";
    constant REG_DAQ_OH0_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH1_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH1_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH1_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH1_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH1_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH1_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH1_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH1_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"21";
    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"22";
    constant REG_DAQ_OH1_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"23";
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"24";
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"24";
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"25";
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"25";
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"26";
    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"26";
    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"27";
    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"28";
    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"29";
    constant REG_DAQ_OH1_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2a";
    constant REG_DAQ_OH1_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2b";
    constant REG_DAQ_OH1_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2c";
    constant REG_DAQ_OH1_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2d";
    constant REG_DAQ_OH1_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2e";
    constant REG_DAQ_OH1_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2f";
    constant REG_DAQ_OH1_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH2_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH2_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH2_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH2_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH2_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH2_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH2_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH2_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"31";
    constant REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"32";
    constant REG_DAQ_OH2_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH2_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"33";
    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"34";
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"34";
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"35";
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"35";
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"36";
    constant REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"36";
    constant REG_DAQ_OH2_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH2_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"37";
    constant REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"38";
    constant REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"39";
    constant REG_DAQ_OH2_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"3a";
    constant REG_DAQ_OH2_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"3b";
    constant REG_DAQ_OH2_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"3c";
    constant REG_DAQ_OH2_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"3d";
    constant REG_DAQ_OH2_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"3e";
    constant REG_DAQ_OH2_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"3f";
    constant REG_DAQ_OH2_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH3_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH3_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH3_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH3_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH3_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH3_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH3_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH3_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"40";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"41";
    constant REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"42";
    constant REG_DAQ_OH3_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH3_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"43";
    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"44";
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"44";
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"45";
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"45";
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"46";
    constant REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"46";
    constant REG_DAQ_OH3_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH3_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"47";
    constant REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"48";
    constant REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"49";
    constant REG_DAQ_OH3_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"4a";
    constant REG_DAQ_OH3_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"4b";
    constant REG_DAQ_OH3_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"4c";
    constant REG_DAQ_OH3_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"4d";
    constant REG_DAQ_OH3_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"4e";
    constant REG_DAQ_OH3_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"4f";
    constant REG_DAQ_OH3_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH4_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH4_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH4_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH4_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH4_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH4_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH4_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH4_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"51";
    constant REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"52";
    constant REG_DAQ_OH4_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH4_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"53";
    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"54";
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"54";
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"55";
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"55";
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"56";
    constant REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"56";
    constant REG_DAQ_OH4_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH4_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"57";
    constant REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"58";
    constant REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"59";
    constant REG_DAQ_OH4_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5a";
    constant REG_DAQ_OH4_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5b";
    constant REG_DAQ_OH4_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5c";
    constant REG_DAQ_OH4_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5d";
    constant REG_DAQ_OH4_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5e";
    constant REG_DAQ_OH4_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5f";
    constant REG_DAQ_OH4_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH5_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH5_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH5_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH5_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH5_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH5_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH5_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH5_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"61";
    constant REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"62";
    constant REG_DAQ_OH5_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH5_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"63";
    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"64";
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"64";
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"65";
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"65";
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"66";
    constant REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"66";
    constant REG_DAQ_OH5_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH5_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"67";
    constant REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"68";
    constant REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"69";
    constant REG_DAQ_OH5_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"6a";
    constant REG_DAQ_OH5_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"6b";
    constant REG_DAQ_OH5_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"6c";
    constant REG_DAQ_OH5_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"6d";
    constant REG_DAQ_OH5_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"6e";
    constant REG_DAQ_OH5_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"6f";
    constant REG_DAQ_OH5_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH6_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH6_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH6_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH6_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH6_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH6_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH6_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH6_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"71";
    constant REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"72";
    constant REG_DAQ_OH6_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH6_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"73";
    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"74";
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"74";
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"75";
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"75";
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"76";
    constant REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"76";
    constant REG_DAQ_OH6_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH6_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"77";
    constant REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"78";
    constant REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"79";
    constant REG_DAQ_OH6_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7a";
    constant REG_DAQ_OH6_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7b";
    constant REG_DAQ_OH6_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7c";
    constant REG_DAQ_OH6_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7d";
    constant REG_DAQ_OH6_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7e";
    constant REG_DAQ_OH6_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7f";
    constant REG_DAQ_OH6_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH7_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH7_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH7_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH7_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH7_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH7_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH7_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH7_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"81";
    constant REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"82";
    constant REG_DAQ_OH7_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH7_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"83";
    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"84";
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"84";
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"85";
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"85";
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"86";
    constant REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"86";
    constant REG_DAQ_OH7_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH7_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"87";
    constant REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"88";
    constant REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"89";
    constant REG_DAQ_OH7_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"8a";
    constant REG_DAQ_OH7_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"8b";
    constant REG_DAQ_OH7_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"8c";
    constant REG_DAQ_OH7_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"8d";
    constant REG_DAQ_OH7_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"8e";
    constant REG_DAQ_OH7_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"8f";
    constant REG_DAQ_OH7_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH8_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH8_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH8_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH8_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH8_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH8_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH8_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH8_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"91";
    constant REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"92";
    constant REG_DAQ_OH8_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH8_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"93";
    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"94";
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"94";
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"95";
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"95";
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"96";
    constant REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"96";
    constant REG_DAQ_OH8_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH8_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"97";
    constant REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"98";
    constant REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"99";
    constant REG_DAQ_OH8_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9a";
    constant REG_DAQ_OH8_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9b";
    constant REG_DAQ_OH8_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9c";
    constant REG_DAQ_OH8_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9d";
    constant REG_DAQ_OH8_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9e";
    constant REG_DAQ_OH8_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9f";
    constant REG_DAQ_OH8_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH9_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH9_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH9_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH9_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH9_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH9_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH9_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH9_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a1";
    constant REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a2";
    constant REG_DAQ_OH9_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH9_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a3";
    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a4";
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a4";
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a5";
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a5";
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a6";
    constant REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a6";
    constant REG_DAQ_OH9_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH9_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a7";
    constant REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a8";
    constant REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a9";
    constant REG_DAQ_OH9_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"aa";
    constant REG_DAQ_OH9_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ab";
    constant REG_DAQ_OH9_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ac";
    constant REG_DAQ_OH9_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ad";
    constant REG_DAQ_OH9_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ae";
    constant REG_DAQ_OH9_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"af";
    constant REG_DAQ_OH9_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH10_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH10_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH10_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH10_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH10_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH10_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH10_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH10_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b1";
    constant REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b2";
    constant REG_DAQ_OH10_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH10_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b3";
    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b4";
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b4";
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b5";
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b5";
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b6";
    constant REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b6";
    constant REG_DAQ_OH10_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH10_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b7";
    constant REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b8";
    constant REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b9";
    constant REG_DAQ_OH10_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ba";
    constant REG_DAQ_OH10_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"bb";
    constant REG_DAQ_OH10_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"bc";
    constant REG_DAQ_OH10_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"bd";
    constant REG_DAQ_OH10_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"be";
    constant REG_DAQ_OH10_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"bf";
    constant REG_DAQ_OH10_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH11_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH11_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH11_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH11_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH11_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH11_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH11_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH11_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c1";
    constant REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c2";
    constant REG_DAQ_OH11_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH11_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c3";
    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c4";
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c4";
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c5";
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c5";
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c6";
    constant REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c6";
    constant REG_DAQ_OH11_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH11_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c7";
    constant REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c8";
    constant REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c9";
    constant REG_DAQ_OH11_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ca";
    constant REG_DAQ_OH11_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"cb";
    constant REG_DAQ_OH11_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"cc";
    constant REG_DAQ_OH11_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"cd";
    constant REG_DAQ_OH11_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ce";
    constant REG_DAQ_OH11_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"cf";
    constant REG_DAQ_OH11_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK6_LSB     : integer := 0;


    --============================================================================
    --       >>> OH_LINKS Module <<<    base address: 0x00600000
    --
    -- OH Link monitoring registers
    --============================================================================

    constant REG_OH_LINKS_NUM_REGS : integer := 301;
    constant REG_OH_LINKS_ADDRESS_MSB : integer := 12;
    constant REG_OH_LINKS_ADDRESS_LSB : integer := 0;
    constant REG_OH_LINKS_CTRL_DEBUG_CLK_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_OH_LINKS_CTRL_DEBUG_CLK_CNT_RESET_BIT    : integer := 30;

    constant REG_OH_LINKS_CTRL_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_OH_LINKS_CTRL_CNT_RESET_BIT    : integer := 31;

    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"100";
    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"101";
    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"102";
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"103";
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"104";
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"105";
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"106";
    constant REG_OH_LINKS_OH0_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"107";
    constant REG_OH_LINKS_OH0_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"108";
    constant REG_OH_LINKS_OH0_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"109";
    constant REG_OH_LINKS_OH0_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10a";
    constant REG_OH_LINKS_OH0_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10b";
    constant REG_OH_LINKS_OH0_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10c";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10d";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10e";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10f";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"110";
    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"111";
    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"112";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"113";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"114";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"115";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"120";
    constant REG_OH_LINKS_OH0_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH0_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"121";
    constant REG_OH_LINKS_OH0_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"150";
    constant REG_OH_LINKS_OH0_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH0_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH0_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"150";
    constant REG_OH_LINKS_OH0_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH0_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH0_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"150";
    constant REG_OH_LINKS_OH0_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH0_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"200";
    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"201";
    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"202";
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"203";
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"204";
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"205";
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"206";
    constant REG_OH_LINKS_OH1_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"207";
    constant REG_OH_LINKS_OH1_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"208";
    constant REG_OH_LINKS_OH1_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"209";
    constant REG_OH_LINKS_OH1_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20a";
    constant REG_OH_LINKS_OH1_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20b";
    constant REG_OH_LINKS_OH1_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20c";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20d";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20e";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20f";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"210";
    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"211";
    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"212";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"213";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"214";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"215";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"220";
    constant REG_OH_LINKS_OH1_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH1_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"221";
    constant REG_OH_LINKS_OH1_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"250";
    constant REG_OH_LINKS_OH1_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH1_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH1_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"250";
    constant REG_OH_LINKS_OH1_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH1_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH1_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"250";
    constant REG_OH_LINKS_OH1_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH1_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"300";
    constant REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"301";
    constant REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"302";
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"303";
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"304";
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"305";
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"306";
    constant REG_OH_LINKS_OH2_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"307";
    constant REG_OH_LINKS_OH2_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"308";
    constant REG_OH_LINKS_OH2_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"309";
    constant REG_OH_LINKS_OH2_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30a";
    constant REG_OH_LINKS_OH2_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30b";
    constant REG_OH_LINKS_OH2_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30c";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30d";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30e";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30f";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"310";
    constant REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"311";
    constant REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"312";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"313";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"314";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"315";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"320";
    constant REG_OH_LINKS_OH2_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH2_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"321";
    constant REG_OH_LINKS_OH2_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"350";
    constant REG_OH_LINKS_OH2_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH2_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH2_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"350";
    constant REG_OH_LINKS_OH2_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH2_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH2_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"350";
    constant REG_OH_LINKS_OH2_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH2_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"400";
    constant REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"401";
    constant REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"402";
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"403";
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"404";
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"405";
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"406";
    constant REG_OH_LINKS_OH3_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"407";
    constant REG_OH_LINKS_OH3_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"408";
    constant REG_OH_LINKS_OH3_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"409";
    constant REG_OH_LINKS_OH3_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40a";
    constant REG_OH_LINKS_OH3_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40b";
    constant REG_OH_LINKS_OH3_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40c";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40d";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40e";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40f";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"410";
    constant REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"411";
    constant REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"412";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"413";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"414";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"415";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"420";
    constant REG_OH_LINKS_OH3_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH3_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"421";
    constant REG_OH_LINKS_OH3_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"450";
    constant REG_OH_LINKS_OH3_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH3_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH3_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"450";
    constant REG_OH_LINKS_OH3_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH3_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH3_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"450";
    constant REG_OH_LINKS_OH3_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH3_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH4_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"500";
    constant REG_OH_LINKS_OH4_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"501";
    constant REG_OH_LINKS_OH4_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"502";
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"503";
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"504";
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"505";
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"506";
    constant REG_OH_LINKS_OH4_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"507";
    constant REG_OH_LINKS_OH4_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"508";
    constant REG_OH_LINKS_OH4_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"509";
    constant REG_OH_LINKS_OH4_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50a";
    constant REG_OH_LINKS_OH4_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50b";
    constant REG_OH_LINKS_OH4_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50c";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50d";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50e";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50f";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"510";
    constant REG_OH_LINKS_OH4_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"511";
    constant REG_OH_LINKS_OH4_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"512";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"513";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"514";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"515";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"520";
    constant REG_OH_LINKS_OH4_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH4_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"521";
    constant REG_OH_LINKS_OH4_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"550";
    constant REG_OH_LINKS_OH4_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH4_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH4_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"550";
    constant REG_OH_LINKS_OH4_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH4_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH4_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"550";
    constant REG_OH_LINKS_OH4_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH4_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH5_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"600";
    constant REG_OH_LINKS_OH5_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"601";
    constant REG_OH_LINKS_OH5_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"602";
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"603";
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"604";
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"605";
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"606";
    constant REG_OH_LINKS_OH5_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"607";
    constant REG_OH_LINKS_OH5_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"608";
    constant REG_OH_LINKS_OH5_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"609";
    constant REG_OH_LINKS_OH5_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60a";
    constant REG_OH_LINKS_OH5_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60b";
    constant REG_OH_LINKS_OH5_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60c";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60d";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60e";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60f";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"610";
    constant REG_OH_LINKS_OH5_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"611";
    constant REG_OH_LINKS_OH5_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"612";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"613";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"614";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"615";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"620";
    constant REG_OH_LINKS_OH5_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH5_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"621";
    constant REG_OH_LINKS_OH5_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"650";
    constant REG_OH_LINKS_OH5_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH5_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH5_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"650";
    constant REG_OH_LINKS_OH5_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH5_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH5_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"650";
    constant REG_OH_LINKS_OH5_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH5_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH6_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"700";
    constant REG_OH_LINKS_OH6_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"701";
    constant REG_OH_LINKS_OH6_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"702";
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"703";
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"704";
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"705";
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"706";
    constant REG_OH_LINKS_OH6_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"707";
    constant REG_OH_LINKS_OH6_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"708";
    constant REG_OH_LINKS_OH6_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"709";
    constant REG_OH_LINKS_OH6_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70a";
    constant REG_OH_LINKS_OH6_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70b";
    constant REG_OH_LINKS_OH6_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70c";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70d";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70e";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70f";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"710";
    constant REG_OH_LINKS_OH6_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"711";
    constant REG_OH_LINKS_OH6_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"712";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"713";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"714";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"715";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"720";
    constant REG_OH_LINKS_OH6_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH6_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"721";
    constant REG_OH_LINKS_OH6_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"750";
    constant REG_OH_LINKS_OH6_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH6_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH6_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"750";
    constant REG_OH_LINKS_OH6_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH6_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH6_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"750";
    constant REG_OH_LINKS_OH6_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH6_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH7_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"800";
    constant REG_OH_LINKS_OH7_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"801";
    constant REG_OH_LINKS_OH7_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"802";
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"803";
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"804";
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"805";
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"806";
    constant REG_OH_LINKS_OH7_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"807";
    constant REG_OH_LINKS_OH7_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"808";
    constant REG_OH_LINKS_OH7_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"809";
    constant REG_OH_LINKS_OH7_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80a";
    constant REG_OH_LINKS_OH7_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80b";
    constant REG_OH_LINKS_OH7_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80c";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80d";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80e";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80f";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"810";
    constant REG_OH_LINKS_OH7_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"811";
    constant REG_OH_LINKS_OH7_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"812";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"813";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"814";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"815";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"820";
    constant REG_OH_LINKS_OH7_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH7_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"821";
    constant REG_OH_LINKS_OH7_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"850";
    constant REG_OH_LINKS_OH7_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH7_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH7_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"850";
    constant REG_OH_LINKS_OH7_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH7_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH7_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"850";
    constant REG_OH_LINKS_OH7_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH7_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH8_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"900";
    constant REG_OH_LINKS_OH8_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"901";
    constant REG_OH_LINKS_OH8_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"902";
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"903";
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"904";
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"905";
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"906";
    constant REG_OH_LINKS_OH8_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"907";
    constant REG_OH_LINKS_OH8_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"908";
    constant REG_OH_LINKS_OH8_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"909";
    constant REG_OH_LINKS_OH8_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90a";
    constant REG_OH_LINKS_OH8_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90b";
    constant REG_OH_LINKS_OH8_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90c";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90d";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90e";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90f";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"910";
    constant REG_OH_LINKS_OH8_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"911";
    constant REG_OH_LINKS_OH8_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"912";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"913";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"914";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"915";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"920";
    constant REG_OH_LINKS_OH8_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH8_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"921";
    constant REG_OH_LINKS_OH8_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"950";
    constant REG_OH_LINKS_OH8_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH8_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH8_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"950";
    constant REG_OH_LINKS_OH8_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH8_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH8_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"950";
    constant REG_OH_LINKS_OH8_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH8_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH9_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a00";
    constant REG_OH_LINKS_OH9_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a01";
    constant REG_OH_LINKS_OH9_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a02";
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a03";
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a04";
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a05";
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a06";
    constant REG_OH_LINKS_OH9_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a07";
    constant REG_OH_LINKS_OH9_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a08";
    constant REG_OH_LINKS_OH9_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a09";
    constant REG_OH_LINKS_OH9_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0a";
    constant REG_OH_LINKS_OH9_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0b";
    constant REG_OH_LINKS_OH9_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0c";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0d";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0e";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0f";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a10";
    constant REG_OH_LINKS_OH9_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a11";
    constant REG_OH_LINKS_OH9_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a12";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a13";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a14";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a15";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a20";
    constant REG_OH_LINKS_OH9_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH9_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a21";
    constant REG_OH_LINKS_OH9_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a50";
    constant REG_OH_LINKS_OH9_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH9_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH9_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a50";
    constant REG_OH_LINKS_OH9_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH9_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH9_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a50";
    constant REG_OH_LINKS_OH9_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH9_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH10_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b00";
    constant REG_OH_LINKS_OH10_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b01";
    constant REG_OH_LINKS_OH10_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b02";
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b03";
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b04";
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b05";
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b06";
    constant REG_OH_LINKS_OH10_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b07";
    constant REG_OH_LINKS_OH10_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b08";
    constant REG_OH_LINKS_OH10_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b09";
    constant REG_OH_LINKS_OH10_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0a";
    constant REG_OH_LINKS_OH10_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0b";
    constant REG_OH_LINKS_OH10_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0c";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0d";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0e";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0f";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b10";
    constant REG_OH_LINKS_OH10_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b11";
    constant REG_OH_LINKS_OH10_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b12";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b13";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b14";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b15";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b20";
    constant REG_OH_LINKS_OH10_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH10_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b21";
    constant REG_OH_LINKS_OH10_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b50";
    constant REG_OH_LINKS_OH10_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH10_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH10_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b50";
    constant REG_OH_LINKS_OH10_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH10_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH10_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b50";
    constant REG_OH_LINKS_OH10_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH10_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH11_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c00";
    constant REG_OH_LINKS_OH11_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c01";
    constant REG_OH_LINKS_OH11_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c02";
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c03";
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c04";
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c05";
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_GBT0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c06";
    constant REG_OH_LINKS_OH11_GBT0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_GBT0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_GBT0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c07";
    constant REG_OH_LINKS_OH11_GBT0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_GBT0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_GBT1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c08";
    constant REG_OH_LINKS_OH11_GBT1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_GBT1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_GBT1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c09";
    constant REG_OH_LINKS_OH11_GBT1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_GBT1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_GBT2_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0a";
    constant REG_OH_LINKS_OH11_GBT2_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_GBT2_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_GBT2_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0b";
    constant REG_OH_LINKS_OH11_GBT2_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_GBT2_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0c";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0d";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0e";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0f";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c10";
    constant REG_OH_LINKS_OH11_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c11";
    constant REG_OH_LINKS_OH11_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c12";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c13";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c14";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c15";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c20";
    constant REG_OH_LINKS_OH11_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH11_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c21";
    constant REG_OH_LINKS_OH11_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_CTRL_DAQ_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c50";
    constant REG_OH_LINKS_OH11_CTRL_DAQ_USE_GBT_BIT    : integer := 0;
    constant REG_OH_LINKS_OH11_CTRL_DAQ_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH11_CTRL_REG_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c50";
    constant REG_OH_LINKS_OH11_CTRL_REG_USE_GBT_BIT    : integer := 1;
    constant REG_OH_LINKS_OH11_CTRL_REG_USE_GBT_DEFAULT : std_logic := '0';

    constant REG_OH_LINKS_OH11_CTRL_TTC_USE_GBT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c50";
    constant REG_OH_LINKS_OH11_CTRL_TTC_USE_GBT_BIT    : integer := 2;
    constant REG_OH_LINKS_OH11_CTRL_TTC_USE_GBT_DEFAULT : std_logic := '0';


end registers;
