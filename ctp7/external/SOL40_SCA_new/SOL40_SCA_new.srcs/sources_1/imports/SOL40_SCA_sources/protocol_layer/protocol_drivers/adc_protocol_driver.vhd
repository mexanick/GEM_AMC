library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SCA_Package.all;

entity adc_protocol_driver is
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
		--Others
		tr_cmd_i			:	in	byte_t
	);
end entity adc_protocol_driver;

architecture RTL of adc_protocol_driver is
	
begin
	
	
	adc_protocol_builder : process (  
		 prot_cmd_en_i, tr_cmd_i, ecs_cmd_packet
	) is
		variable ecs_adc_cmd			:	ecs_adc_cmd_enum;
		variable new_cmd_batch		:	prot_cmd_t;
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
		
		ecs_adc_cmd := INVALID;
		
		
		if prot_cmd_en_i='1' then
			
			for i in ecs_adc_cmd_table_t'left to ecs_adc_cmd_table_t'right loop
				if ecs_cmd_packet.ecs_cmd = ecs_adc_cmd_table(i) then
					ecs_adc_cmd := i;
					exit;
				end if;
			end loop;
			
			new_cmd_batch.tr := tr_cmd_i;
			new_cmd_batch.ch := ecs_cmd_packet.sca_ch;
			new_cmd_batch.cmd_count := 0;
			new_cmd_batch.gbt := to_integer(unsigned(ecs_cmd_packet.gbt_nr));
			new_cmd_batch.sca := to_integer(unsigned(ecs_cmd_packet.sca_nr));
			new_cmd_batch.ecs_cmd := ecs_cmd_packet.ecs_cmd;
			new_cmd_batch.ecs_len := ecs_cmd_packet.len;
			
			case ecs_adc_cmd is 
				when ECS_ADC_GO =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_GO);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_set_InputLine =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_set_InputLine);
					new_cmd_batch.sca_cmds_data(0).data(12 downto 8) := ecs_cmd_packet.data(12 downto 8);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 4 ,8));	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_InputLine =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_InputLine);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_set_CurrentSource =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_set_CurrentSource);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 0) :=  ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 4 ,8));	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_CurrentSource =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_CurrentSource);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_DATA_Ofs_Ga =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_DATA_Ofs_Ga);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_DATA_Ofs =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_DATA_Ofs);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_DATA =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_DATA);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_OFFSET =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_OFFSET);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_wrt_CTRL =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_wrt_CTRL);
					new_cmd_batch.sca_cmds_data(0).data(4 downto 0) := ecs_cmd_packet.data(4 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 1 ,8));	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_CTRL =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_CTRL);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_GO_SingleSlope =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_GO_SingleSlope);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_wrt_GainCalibrReg =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_wrt_GainCalibrReg);
					new_cmd_batch.sca_cmds_data(0).data(12 downto 0) := ecs_cmd_packet.data(12 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 2 ,8));	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_GainCalibrReg =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_GainCalibrReg);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_wrt_ID =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_wrt_ID);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 0) := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 4 ,8));		
					new_cmd_batch.cmd_count := 1;
				when ECS_ADC_rea_ID =>
					new_cmd_batch.sca_cmds(0) := adc_cmd_table(ADC_rea_ID);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when INVALID =>
					new_cmd_batch.sca_cmds(0) := x"FF";
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 0;
			end case;
		end if;
		
		sca_cmd_batch_o <= new_cmd_batch;
		
	end process adc_protocol_builder;
	
adc_protocol_decoder : process ( sca_rpy_batch_i, prot_rpy_en_i) is
		variable new_ecs_rpy_packet		:	ecs_packet_t;
		variable ecs_adc_cmd			:	ecs_adc_cmd_enum;
	begin
		new_ecs_rpy_packet.gbt_nr := (others=>'0');
		new_ecs_rpy_packet.sca_nr  := (others=>'0');
		new_ecs_rpy_packet.sca_ch  := (others=>'0');
		new_ecs_rpy_packet.ecs_cmd := (others=>'0');
		new_ecs_rpy_packet.data := (others=>'0');
		new_ecs_rpy_packet.len := (others=>'0');
		new_ecs_rpy_packet.protocol_specific  := (others=>'0');
		new_ecs_rpy_packet.err := (others=>'0');
		
		ecs_adc_cmd := INVALID;
		
		if prot_rpy_en_i='1' then
		
			for i in ecs_adc_cmd_table_t'left to ecs_adc_cmd_table_t'right loop
				if sca_rpy_batch_i.ecs_cmd = ecs_adc_cmd_table(i) then
					ecs_adc_cmd := i;
					exit;
				end if;
			end loop;
			new_ecs_rpy_packet.ecs_cmd := ecs_adc_cmd_table(ecs_adc_cmd);
			
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
			
			
			case ecs_adc_cmd is 
			when ECS_ADC_GO =>
				new_ecs_rpy_packet.data(27 downto 16) := sca_rpy_batch_i.sca_rpys_data(0).data(27 downto 16);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
			when ECS_ADC_set_InputLine =>
				null;
			when ECS_ADC_rea_InputLine =>
				new_ecs_rpy_packet.data(4 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(4 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(1,8));
			when ECS_ADC_set_CurrentSource =>
				null;
			when ECS_ADC_rea_CurrentSource =>
				new_ecs_rpy_packet.data(30 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(30 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
			when ECS_ADC_rea_DATA_Ofs_Ga =>
				new_ecs_rpy_packet.data(12 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(12 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(2,8));
			when ECS_ADC_rea_DATA_Ofs =>
				new_ecs_rpy_packet.data(12 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(12 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(2,8));
			when ECS_ADC_rea_DATA =>
				new_ecs_rpy_packet.data(12 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(12 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(2,8));
			when ECS_ADC_rea_OFFSET =>
				new_ecs_rpy_packet.data(12 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(12 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(2,8));
			when ECS_ADC_wrt_CTRL =>
				null;
			when ECS_ADC_rea_CTRL =>
				new_ecs_rpy_packet.data(4 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(4 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(1,8));
			when ECS_ADC_GO_SingleSlope =>
				null;
			when ECS_ADC_wrt_GainCalibrReg =>
				null;
			when ECS_ADC_rea_GainCalibrReg =>
				new_ecs_rpy_packet.data(12 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(12 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(2,8));
			when ECS_ADC_wrt_ID =>
				null;
			when ECS_ADC_rea_ID =>
				new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(31 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
			when INVALID =>
				null;
			end case;
		
			
		end if;
	
		ecs_rpy_packet <= new_ecs_rpy_packet;
	end process adc_protocol_decoder;	

end architecture RTL;
