library ieee;
use ieee.std_logic_1164.all;

use work.SCA_Package.all;

entity ecs_buffer_layer is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		--		
		ecs_cmd_int_av_o   	: out std_logic;
		ecs_cmd_int_ena_i   : in  std_logic;
		 ecs_cmd_int_data_i	:	in	ecs_packet_t;
		--
		 ecs_rpy_int_isRead_i :	in std_logic;
		 ecs_rpy_int_addr_i : in  ecs_addr_packet_t;
		 ecs_rpy_int_av_o   : out std_logic;
		 ecs_rpy_int_data_o : out ecs_packet_t;
		 new_rpy_o			: out std_logic;
		 --
		
		ecs_rpy_prot_av_o   : out std_logic;
		ecs_rpy_prot_ena_i  : in  std_logic;
		ecs_rpy_prot_data_i : in  ecs_packet_t;
		--
		ecs_cmd_prot_ena_i  : in  std_logic;
		ecs_cmd_prot_av_o   : out std_logic;
		ecs_cmd_prot_data_o : out ecs_packet_t
		--
		
			 
			 
	);
end entity ecs_buffer_layer;

architecture RTL of ecs_buffer_layer is
	
	component ecs_cmd_fifo
		generic(FIFO_LENGTH : natural := 2);
		port(
			 clk				:	in	std_logic;
			 rst                 : in  std_logic;
			 ecs_cmd_int_av_o   : out std_logic;
			 ecs_cmd_int_data_i  : in  ecs_packet_t;
			 ecs_cmd_int_ena_i    : in  std_logic;
			 ecs_cmd_prot_ena_i  : in  std_logic;
			 ecs_cmd_prot_av_o   : out std_logic;
			 ecs_cmd_prot_data_o : out ecs_packet_t);
	end component ecs_cmd_fifo;
	
	component ecs_rpy_mem
		port(
			clk                  : in  std_logic;
			 rst                  : in  std_logic;
			 ecs_rpy_int_isRead_i : in  std_logic;
			 ecs_rpy_int_addr_i   : in  ecs_addr_packet_t;
			 ecs_rpy_int_av_o     : out std_logic;
			 ecs_rpy_int_data_o   : out ecs_packet_t;
			 new_rpy_o            : out std_logic;
			 ecs_rpy_prot_av_o    : out std_logic;
			 ecs_rpy_prot_ena_i   : in  std_logic;
			 ecs_rpy_prot_data_i  : in  ecs_packet_t);
	end component ecs_rpy_mem;
	
	
begin
	
	ecs_cmd_fifo_inst : component ecs_cmd_fifo
		generic map(FIFO_LENGTH => 32)
		port map(
				clk                 => clk,
			     rst                 => rst,
			     ecs_cmd_int_av_o   => ecs_cmd_int_av_o,
			     ecs_cmd_int_data_i    => ecs_cmd_int_data_i,
			     ecs_cmd_int_ena_i  => ecs_cmd_int_ena_i,
			     ecs_cmd_prot_ena_i  => ecs_cmd_prot_ena_i,
			     ecs_cmd_prot_av_o   => ecs_cmd_prot_av_o,
			     ecs_cmd_prot_data_o => ecs_cmd_prot_data_o);
	
	ecs_rpy_mem_inst : component ecs_rpy_mem
		port map(
			clk                  => clk,
			rst                  => rst,
			ecs_rpy_int_isRead_i => ecs_rpy_int_isRead_i,
			ecs_rpy_int_addr_i   => ecs_rpy_int_addr_i,
			ecs_rpy_int_av_o     => ecs_rpy_int_av_o,
			ecs_rpy_int_data_o   => ecs_rpy_int_data_o,
			new_rpy_o            => new_rpy_o,
			ecs_rpy_prot_av_o    => ecs_rpy_prot_av_o,
			ecs_rpy_prot_ena_i   => ecs_rpy_prot_ena_i,
			ecs_rpy_prot_data_i  => ecs_rpy_prot_data_i
		);
end architecture RTL;
