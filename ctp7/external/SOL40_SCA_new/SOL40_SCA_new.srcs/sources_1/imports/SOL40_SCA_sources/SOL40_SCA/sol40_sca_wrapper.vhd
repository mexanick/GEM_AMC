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

entity sol40_sca_wrapper is
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
           rx_sd                        : in STD_LOGIC_VECTOR (1 downto 0)
          );
end sol40_sca_wrapper;

architecture Behavioral of sol40_sca_wrapper is

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
				rx_sd                      : in std_logic_vector(1 downto 0)
			);
	end component;
 
    signal  write_ecs_command : std_logic;  
 
begin
    
    write_ecs_command <= (WRITE_ECS_COMMAND_CMD_i) nor (WRITE_ECS_COMMAND_ADDR_i); -- When both Addr and Cmd FIFOs have data then take both and write 

	sol40_sca_inst : component sol40_sca 
		generic map(
			BASE_ADDRESS           => BASE_ADDRESS
		)
		port map(
			ECS_CLK                => ECS_CLK,     
			ECS_ADDRESS_i          => ECS_ADDRESS_i,     
			READ_ECS_RESPONSE_i    => READ_ECS_RESPONSE_i,     
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
			rx_sd                  => rx_sd
		);

end Behavioral;
