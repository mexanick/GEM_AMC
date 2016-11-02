----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2016 11:09:31
-- Design Name: 
-- Module Name: sol40_sca_wrapper - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SCA_wrapper is
    generic (
        BASE_ADDRESS            : in std_logic_vector(18 downto 0) := (others=>'0')
    );
    Port ( ECS_CLK                  	: in STD_LOGIC;
           ECS_ADDRESS_i                : in STD_LOGIC_VECTOR (18 downto 0);
           READ_ECS_RESPONSE_i          : in STD_LOGIC;
           ECS_RESPONSE_o               : out STD_LOGIC_VECTOR (31 downto 0);
           ECS_RESPONSE_VALID_o         : out STD_LOGIC;
           ECS_COMMAND_i                : in STD_LOGIC_VECTOR (31 downto 0);
           WRITE_ECS_COMMAND_CMD_i      : in STD_LOGIC;                         -- Connected to Command FIFO empty port
           WRITE_ECS_COMMAND_ADDR_i     : in STD_LOGIC;                         -- Connected to Address FIFO empty port
           txClock40                    : in STD_LOGIC;
           rxClock40                    : in STD_LOGIC;
           SRES_i                       : in STD_LOGIC;
           tx_sd                        : out STD_LOGIC_VECTOR (1 downto 0);
           rx_sd                        : in STD_LOGIC_VECTOR (1 downto 0);
           
           READ_CMD_FIFO_IS_FULL        : in STD_LOGIC;
           -- ILA debug ports
           -- Output from interface layer
           ecs_cmd_int_data_o_intlay_gbt_nr    : out std_logic_vector(7 downto 0);
           ecs_cmd_int_data_o_intlay_sca_nr    : out std_logic_vector(7 downto 0);
           ecs_cmd_int_data_o_intlay_sca_ch    : out std_logic_vector(7 downto 0);
           ecs_cmd_int_data_o_intlay_ecs_cmd   : out std_logic_vector(7 downto 0);
           ecs_cmd_int_data_o_intlay_err       : out std_logic_vector(7 downto 0);
           ecs_cmd_int_data_o_intlay_len       : out std_logic_vector(7 downto 0);
           ecs_cmd_int_data_o_intlay_prot_spec : out std_logic_vector(15 downto 0);
           ecs_cmd_int_data_o_intlay_data      : out std_logic_vector(127 downto 0);
           -- Output from buffer layer
           ecs_cmd_prot_data_o_buflay_gbt_nr    : out std_logic_vector(7 downto 0);
           ecs_cmd_prot_data_o_buflay_sca_nr    : out std_logic_vector(7 downto 0);
           ecs_cmd_prot_data_o_buflay_sca_ch    : out std_logic_vector(7 downto 0);
           ecs_cmd_prot_data_o_buflay_ecs_cmd   : out std_logic_vector(7 downto 0);
           ecs_cmd_prot_data_o_buflay_err       : out std_logic_vector(7 downto 0);
           ecs_cmd_prot_data_o_buflay_len       : out std_logic_vector(7 downto 0);
           ecs_cmd_prot_data_o_buflay_prot_spec : out std_logic_vector(15 downto 0);
           ecs_cmd_prot_data_o_buflay_data      : out std_logic_vector(127 downto 0);
           -- Output from protocol layer
           sca_cmd_data_protlay_payload_tr         : out std_logic_vector(7 downto 0);
           sca_cmd_data_protlay_payload_ch         : out std_logic_vector(7 downto 0);
           sca_cmd_data_protlay_payload_cmd_or_err : out std_logic_vector(7 downto 0);
           sca_cmd_data_protlay_payload_len        : out std_logic_vector(7 downto 0);
           sca_cmd_data_protlay_payload_data       : out std_logic_vector(31 downto 0)
          );
end SCA_wrapper;

architecture Behavioral of SCA_wrapper is

	component sol40_sca 
			generic(
				BASE_ADDRESS            : in std_logic_vector(18 downto 0) := (others=>'0')
			);
			port(
				ECS_CLK                    : in std_logic;   -- 40 MHz clock
				ECS_ADDRESS_i              : in std_logic_vector(18 downto 0);
				READ_ECS_RESPONSE_i        : in std_logic;
				ECS_RESPONSE_o             : out std_logic_vector(31 downto 0);
				ECS_RESPONSE_VALID_o       : out std_logic;
				ECS_COMMAND_i              : in std_logic_vector (31 downto 0);
				WRITE_ECS_COMMAND_i        : in std_logic;
				--
				txClock40                  : in std_logic;
				rxClock40                  : in std_logic;
				SRES_i                     : in std_logic;
				--
				tx_sd                      : out std_logic_vector(1 downto 0);
				rx_sd                      : in std_logic_vector(1 downto 0);
				-- Output from interface layer
                ecs_cmd_int_data_o_intlay_gbt_nr    : out std_logic_vector(7 downto 0);
                ecs_cmd_int_data_o_intlay_sca_nr    : out std_logic_vector(7 downto 0);
                ecs_cmd_int_data_o_intlay_sca_ch    : out std_logic_vector(7 downto 0);
                ecs_cmd_int_data_o_intlay_ecs_cmd   : out std_logic_vector(7 downto 0);
                ecs_cmd_int_data_o_intlay_err       : out std_logic_vector(7 downto 0);
                ecs_cmd_int_data_o_intlay_len       : out std_logic_vector(7 downto 0);
                ecs_cmd_int_data_o_intlay_prot_spec : out std_logic_vector(15 downto 0);
                ecs_cmd_int_data_o_intlay_data      : out std_logic_vector(127 downto 0);
                -- Output from buffer layer
                ecs_cmd_prot_data_o_buflay_gbt_nr    : out std_logic_vector(7 downto 0);
                ecs_cmd_prot_data_o_buflay_sca_nr    : out std_logic_vector(7 downto 0);
                ecs_cmd_prot_data_o_buflay_sca_ch    : out std_logic_vector(7 downto 0);
                ecs_cmd_prot_data_o_buflay_ecs_cmd   : out std_logic_vector(7 downto 0);
                ecs_cmd_prot_data_o_buflay_err       : out std_logic_vector(7 downto 0);
                ecs_cmd_prot_data_o_buflay_len       : out std_logic_vector(7 downto 0);
                ecs_cmd_prot_data_o_buflay_prot_spec : out std_logic_vector(15 downto 0);
                ecs_cmd_prot_data_o_buflay_data      : out std_logic_vector(127 downto 0);
                -- Output from protocol layer
                sca_cmd_data_protlay_payload_tr         : out std_logic_vector(7 downto 0);
                sca_cmd_data_protlay_payload_ch         : out std_logic_vector(7 downto 0);
                sca_cmd_data_protlay_payload_cmd_or_err : out std_logic_vector(7 downto 0);
                sca_cmd_data_protlay_payload_len        : out std_logic_vector(7 downto 0);
                sca_cmd_data_protlay_payload_data       : out std_logic_vector(31 downto 0)
			);
	end component;
 
    signal write_ecs_command : std_logic;  
    signal read_ecs_response : std_logic;
 
begin

    process (ECS_CLK)
    begin
        if rising_edge(ECS_CLK) then
            write_ecs_command <= (WRITE_ECS_COMMAND_CMD_i) nor (WRITE_ECS_COMMAND_ADDR_i); -- When both Addr and Cmd FIFOs have data then take both and write 
            read_ecs_response <= (not(READ_ECS_RESPONSE_i)) and WRITE_ECS_COMMAND_CMD_i; -- When there is only data in addr FIFO, but not in the cmd FIFO, there is a read
        end if; 
    end process;

	sol40_sca_inst : component sol40_sca 
		generic map(
			BASE_ADDRESS           => BASE_ADDRESS
		)
		port map(
			ECS_CLK                => ECS_CLK,     
			ECS_ADDRESS_i          => ECS_ADDRESS_i,     
			READ_ECS_RESPONSE_i    => read_ecs_response,     
			ECS_RESPONSE_o         => ECS_RESPONSE_o,     
			ECS_RESPONSE_VALID_o   => ECS_RESPONSE_VALID_o,     
			ECS_COMMAND_i          => ECS_COMMAND_i,     
			WRITE_ECS_COMMAND_i    => write_ecs_command,     
			--                          
			txClock40              => txClock40,     
			rxClock40              => rxClock40,     
			SRES_i                 => SRES_i,     
			--                          
			tx_sd                  => tx_sd,     
			rx_sd                  => rx_sd, 
			ecs_cmd_int_data_o_intlay_gbt_nr        => ecs_cmd_int_data_o_intlay_gbt_nr, 			    
            ecs_cmd_int_data_o_intlay_sca_nr        => ecs_cmd_int_data_o_intlay_sca_nr,
            ecs_cmd_int_data_o_intlay_sca_ch        => ecs_cmd_int_data_o_intlay_sca_ch,
            ecs_cmd_int_data_o_intlay_ecs_cmd       => ecs_cmd_int_data_o_intlay_ecs_cmd,
            ecs_cmd_int_data_o_intlay_err           => ecs_cmd_int_data_o_intlay_err,
            ecs_cmd_int_data_o_intlay_len           => ecs_cmd_int_data_o_intlay_len,
            ecs_cmd_int_data_o_intlay_prot_spec     => ecs_cmd_int_data_o_intlay_prot_spec,
            ecs_cmd_int_data_o_intlay_data          => ecs_cmd_int_data_o_intlay_data,
            -- Output from buffer layer              
            ecs_cmd_prot_data_o_buflay_gbt_nr       => ecs_cmd_prot_data_o_buflay_gbt_nr,
            ecs_cmd_prot_data_o_buflay_sca_nr       => ecs_cmd_prot_data_o_buflay_sca_nr,
            ecs_cmd_prot_data_o_buflay_sca_ch       => ecs_cmd_prot_data_o_buflay_sca_ch,
            ecs_cmd_prot_data_o_buflay_ecs_cmd      => ecs_cmd_prot_data_o_buflay_ecs_cmd,
            ecs_cmd_prot_data_o_buflay_err          => ecs_cmd_prot_data_o_buflay_err,
            ecs_cmd_prot_data_o_buflay_len          => ecs_cmd_prot_data_o_buflay_len,
            ecs_cmd_prot_data_o_buflay_prot_spec    => ecs_cmd_prot_data_o_buflay_prot_spec,
            ecs_cmd_prot_data_o_buflay_data         => ecs_cmd_prot_data_o_buflay_data,
            -- Output from protocol layer            
            sca_cmd_data_protlay_payload_tr         => sca_cmd_data_protlay_payload_tr,
            sca_cmd_data_protlay_payload_ch         => sca_cmd_data_protlay_payload_ch,
            sca_cmd_data_protlay_payload_cmd_or_err => sca_cmd_data_protlay_payload_cmd_or_err,
            sca_cmd_data_protlay_payload_len        => sca_cmd_data_protlay_payload_len,
            sca_cmd_data_protlay_payload_data       => sca_cmd_data_protlay_payload_data
		);

end Behavioral;

