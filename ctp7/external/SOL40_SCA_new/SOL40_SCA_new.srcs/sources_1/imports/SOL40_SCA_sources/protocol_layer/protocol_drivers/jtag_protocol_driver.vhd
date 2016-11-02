library ieee;
use ieee.std_logic_1164.all;
use work.SCA_Package.all;

use ieee.numeric_std.all;

entity jtag_protocol_driver is
	port (
		-- Interface with the ECS CMD Protocol Arbiter
		prot_cmd_en_i 		:	in	std_logic;
		ecs_cmd_packet		:	in	ecs_packet_t;
		
		-- Interface with the ECS RPY Protocol Arbiter
		prot_rpy_en_i		:	in	std_logic;
		ecs_rpy_packet		:	out	ecs_packet_t;
		
		-- Interface with the Command Queue manager
		sca_cmd_batch_o		:	out prot_cmd_t;
		sca_rpy_batch_i		:	in prot_cmd_t;
		-- Others:
		tr_cmd_i			:	in	byte_t
	);
end entity jtag_protocol_driver;

architecture RTL of jtag_protocol_driver is
	
begin
	
	jtag_protocol_builder : process (ecs_cmd_packet, prot_cmd_en_i, tr_cmd_i) is
		variable ecs_jtag_cmd			:	ecs_jtag_cmd_enum;
		
		variable protocol_specific	:	std_logic_vector(15 downto 0);

		variable new_cmd_batch		:	prot_cmd_t;
		
		
		variable NByte				:	natural range 0 to 16;
		
		variable j					:	natural range 0 to 6;
		variable k					:	natural range 1 to 4;
	begin
		
		new_cmd_batch.tr := x"00";
		new_cmd_batch.ch := x"FF";
		new_cmd_batch.cmd_count := 0;
		new_cmd_batch.gbt := 0;
		new_cmd_batch.sca := 0;
		
		new_cmd_batch.ecs_cmd := (others=>'0');
		new_cmd_batch.ecs_len := (others=>'0');
		new_cmd_batch.err := (others=>'0');
			
		new_cmd_batch.sca_cmds := (others=>(others=>'0'));
		new_cmd_batch.sca_cmds_data :=  (others=>(others=>(others=>'0')));
		new_cmd_batch.sca_rpys_data :=  (others=>(others=>(others=>'0')));
		
		ecs_jtag_cmd := INVALID;
		
		
		if prot_cmd_en_i='1' then
			--\TODO Report if command is not valid
			for i in ecs_jtag_cmd_table_t'left to ecs_jtag_cmd_table_t'right loop
				if ecs_cmd_packet.ecs_cmd = ecs_jtag_cmd_table(i) then
					ecs_jtag_cmd := i;
					exit;
				end if;
			end loop;
			
			protocol_specific := ecs_cmd_packet.protocol_specific;
			--protocol_data := ecs_cmd_packet_int.data(ecs_cmd_packet_int.data'high - 16 downto 0);
			
			new_cmd_batch.tr := tr_cmd_i;
			new_cmd_batch.ch := ecs_cmd_packet.sca_ch;
			new_cmd_batch.cmd_count := 0;
			new_cmd_batch.gbt := to_integer(unsigned(ecs_cmd_packet.gbt_nr));
			new_cmd_batch.sca := to_integer(unsigned(ecs_cmd_packet.sca_nr));
			
			new_cmd_batch.ecs_cmd := ecs_cmd_packet.ecs_cmd;
			
			for i in 0 to new_cmd_batch.sca_cmds'high loop
				new_cmd_batch.sca_cmds(i) := (others=>'0');
				new_cmd_batch.sca_cmds_data(i).data := (others=>'0');
				new_cmd_batch.sca_cmds_data(i).len := (others=>'0');
				new_cmd_batch.sca_rpys_data(i).data := (others=>'0');
				new_cmd_batch.sca_rpys_data(i).len := (others=>'0');
			end loop;	
			
			j := 0;
			
			case ecs_jtag_cmd is 
			when ECS_JTAG_GO =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_GO);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_wrt_CTRL =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_wrt_CTRL);
					new_cmd_batch.sca_cmds_data(0).data(16 downto 0) := 
						ecs_cmd_packet.data(16) & '0' & ecs_cmd_packet.data(14) & '0' 
						& ecs_cmd_packet.data(12 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 3 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_rea_CTRL =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_rea_CTRL);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_wrt_DIV =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_wrt_DIV);
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 2 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_rea_DIV =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_rea_DIV);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_wrt_Tx0 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_wrt_Tx0);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_rea_Tx0 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_rea_Tx0);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_wrt_Tx1 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_wrt_Tx1);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_rea_Tx1 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_rea_Tx1);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_wrt_Tx2 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_wrt_Tx2);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_rea_Tx2 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_rea_Tx2);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_wrt_Tx3 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_wrt_Tx3);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TMS_rea_Tx3 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TMS_rea_Tx3);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_wrt_Tx0 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_wrt_Tx0);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_rea_Tx0 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_rea_Tx0);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_wrt_Tx1 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_wrt_Tx1);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_rea_Tx1 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_rea_Tx1);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_wrt_Tx2 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_wrt_Tx2);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_rea_Tx2 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_rea_Tx2);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_wrt_Tx3 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_wrt_Tx3);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len :=  ecs_cmd_packet.len;
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDO_rea_Tx3 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDO_rea_Tx3);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDI_rea_Rx0 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDI_rea_Rx0);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDI_rea_Rx1 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDI_rea_Rx1);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDI_rea_Rx2 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDI_rea_Rx2);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_TDI_rea_Rx3 =>
					new_cmd_batch.sca_cmds(0) := jtag_cmd_table(JTAG_TDI_rea_Rx3);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 0 ,8));
					new_cmd_batch.cmd_count := 1;
				when ECS_JTAG_WRITE_TMS =>
					null;
				when ECS_JTAG_READ_TMS =>
					null;
				when ECS_JTAG_WRITE_TDO =>
					null;
				when ECS_JTAG_READ_TDO =>
					null;
				when INVALID =>
					null;
			end case;
				
		end if;	
		
		sca_cmd_batch_o <= new_cmd_batch;
	end process jtag_protocol_builder;
	
	jtag_protocol_decoder : process(sca_rpy_batch_i, prot_rpy_en_i) is
		variable new_ecs_rpy_packet		:	ecs_packet_t;
		variable ecs_jtag_cmd			:	ecs_jtag_cmd_enum;
	begin
		new_ecs_rpy_packet.gbt_nr := (others=>'0');
		new_ecs_rpy_packet.sca_nr  := (others=>'0');
		new_ecs_rpy_packet.sca_ch  := (others=>'0');
		new_ecs_rpy_packet.ecs_cmd := (others=>'0');
		new_ecs_rpy_packet.data := (others=>'0');
		new_ecs_rpy_packet.len := (others=>'0');
		new_ecs_rpy_packet.protocol_specific  := (others=>'0');
		new_ecs_rpy_packet.err := (others=>'0');
		
		ecs_jtag_cmd := INVALID;
		
		if prot_rpy_en_i='1' then
			
			for i in ecs_jtag_cmd_table_t'left to ecs_jtag_cmd_table_t'right loop
				if sca_rpy_batch_i.ecs_cmd = ecs_jtag_cmd_table(i) then
					ecs_jtag_cmd := i;
					exit;
				end if;
			end loop;
			new_ecs_rpy_packet.ecs_cmd := ecs_jtag_cmd_table(ecs_jtag_cmd);
			
			new_ecs_rpy_packet.sca_ch := sca_rpy_batch_i.ch;
			new_ecs_rpy_packet.gbt_nr := std_logic_vector( to_unsigned( sca_rpy_batch_i.gbt, 8));
			new_ecs_rpy_packet.sca_nr := std_logic_vector( to_unsigned(sca_rpy_batch_i.sca,8));
			
			if sca_rpy_batch_i.err /= (sca_rpy_batch_i.err'range =>'0') then
				for j in 0 to sca_rpy_batch_i.err'high -1 loop
				if sca_rpy_batch_i.err(j)/='0' then
					-- \TODO What to do?
					report "There was an error on the GBT-SCA channel operation" & integer'image(j) severity Note;
					
					exit;
					end if;
				end loop; 
				new_ecs_rpy_packet.err := sca_rpy_batch_i.err;
			end if;
			
			case ecs_jtag_cmd is 
				when ECS_JTAG_GO =>
					null;
				when ECS_JTAG_wrt_CTRL =>
					null;
				when ECS_JTAG_rea_CTRL =>
					new_ecs_rpy_packet.data(16 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(16 downto 0);
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(3,8));
				when ECS_JTAG_wrt_DIV =>
					null;
				when ECS_JTAG_rea_DIV =>
					new_ecs_rpy_packet.data(15 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(15 downto 0);
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(2,8));
				when ECS_JTAG_TMS_wrt_Tx0 =>
					null;
				when ECS_JTAG_TMS_rea_Tx0 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TMS_wrt_Tx1 =>
					null;
				when ECS_JTAG_TMS_rea_Tx1 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TMS_wrt_Tx2 =>
					null;
				when ECS_JTAG_TMS_rea_Tx2 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TMS_wrt_Tx3 =>
					null;
				when ECS_JTAG_TMS_rea_Tx3 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDO_wrt_Tx0 =>
					null;
				when ECS_JTAG_TDO_rea_Tx0 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDO_wrt_Tx1 =>
					null;
				when ECS_JTAG_TDO_rea_Tx1 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDO_wrt_Tx2 =>
					null;
				when ECS_JTAG_TDO_rea_Tx2 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDO_wrt_Tx3 =>
					null;
				when ECS_JTAG_TDO_rea_Tx3 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDI_rea_Rx0 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDI_rea_Rx1 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDI_rea_Rx2 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_TDI_rea_Rx3 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := sca_rpy_batch_i.sca_rpys_data(0).len;
				when ECS_JTAG_WRITE_TMS =>
					null;
				when ECS_JTAG_READ_TMS =>
					null;
				when ECS_JTAG_WRITE_TDO =>
					null;
				when ECS_JTAG_READ_TDO =>
					null;
				when INVALID =>
					null;
			end case;
			
		end if;
		
		ecs_rpy_packet <= new_ecs_rpy_packet;
			
			
	end process jtag_protocol_decoder;
	

end architecture RTL;
