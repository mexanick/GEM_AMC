library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SCA_Package.all;

entity sca_controller_protocol_driver is
	port (
		clk : in std_logic;
		rst : in std_logic;
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
		tr_cmd_i			:	in	byte_t;
		--Internal Protocol Layer register regarding which SCA and which of its channels are enabled
		activated_channels_o:	out activated_channels_t
	);
end entity sca_controller_protocol_driver;

architecture RTL of sca_controller_protocol_driver is
	
	--! Register with the list of the activated channels, including the SCA itself. It updates with the
	--! CH_EN register on the SCA, plus the SCA enable as bit 0.
	signal activated_channels	:	activated_channels_t := (others=>(others=>'1'));
	
	signal err_rply				:	std_logic;
begin
	-- \TODO activated_channels register is written by two different process, this generates a race condition
	sca_controller_protocol_builder : process(ecs_cmd_packet,  prot_cmd_en_i, tr_cmd_i) is
	
		variable ecs_sca_cmd			:	ecs_sca_cmd_enum;
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
		
		ecs_sca_cmd := INVALID;
				
		if prot_cmd_en_i = '1' then
			--\TODO Report if command is not valid
			for i in ecs_sca_cmd_table_t'left to ecs_sca_cmd_table_t'right loop
				if ecs_cmd_packet.ecs_cmd = ecs_sca_cmd_table(i) then
					ecs_sca_cmd := i;
					exit;
				end if;
			end loop;
			
			
			--protocol_data := ecs_cmd_packet_int.data(ecs_cmd_packet_int.data'high - 16 downto 0);
			new_cmd_batch.tr := tr_cmd_i;
			new_cmd_batch.ch := ecs_cmd_packet.sca_ch;
			
			new_cmd_batch.gbt := to_integer(unsigned(ecs_cmd_packet.gbt_nr));
			new_cmd_batch.sca := to_integer(unsigned(ecs_cmd_packet.sca_nr));
			
			new_cmd_batch.ecs_cmd := ecs_cmd_packet.ecs_cmd;
			
			new_cmd_batch.cmd_count := 1;
			new_cmd_batch.ecs_len := x"01";
			
			case ecs_sca_cmd is 
				when ECS_CRA_wrt | ECS_CRB_wrt | ECS_CRC_wrt | ECS_CRD_wrt  =>
					-- new_cmd_batch.sca_cmds_data(0).data (31 downto 31 - 7) := 
					-- new_cmd_batch.sca_cmds_data(0).data (31 - 8  downto 0) := (others=>'0');
					-- 06/05/2015:
					if ecs_sca_cmd = ECS_CRB_wrt then
						new_cmd_batch.sca_cmds_data(0).data(7 downto 0) :=  
							ecs_cmd_packet.data(7 downto 1)& "0";
					elsif ecs_sca_cmd = ECS_CRD_wrt then
						new_cmd_batch.sca_cmds_data(0).data(7 downto 0) :=  
							"00" & ecs_cmd_packet.data(5 downto 0);
					else
						new_cmd_batch.sca_cmds_data(0).data(7 downto 0) :=  
							ecs_cmd_packet.data(7 downto 0);
					end if;
					new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1,8));
					if ecs_sca_cmd = ECS_CRA_wrt then
						--activated_channels(sca_num)(7 downto 1) <= ecs_cmd_packet.data(7 downto 1);
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRA_WRT);	
					elsif ecs_sca_cmd = ECS_CRB_wrt then
						--activated_channels(sca_num)(7 downto 1) <= ecs_cmd_packet.data(7 downto 1);
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRB_WRT);
					elsif ecs_sca_cmd = ECS_CRC_wrt then
						--activated_channels(sca_num)(15 downto 8) <= ecs_cmd_packet.data(7 downto 0);
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRC_WRT);
					elsif ecs_sca_cmd = ECS_CRD_wrt then
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRD_WRT);
						--activated_channels(sca_num)(21 downto 16) <= ecs_cmd_packet.data(5 downto 0);
					end if;
					
				when ECS_CRA_rea | ECS_CRB_rea | ECS_CRC_rea | ECS_CRD_rea =>
					new_cmd_batch.sca_cmds_data(0).data (31 downto 0) := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(0,8));
					if ecs_sca_cmd = ECS_CRA_rea then
						--activated_channels(sca_num)(7 downto 1) <= ecs_cmd_packet.data(7 downto 1);
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRA_REA);
					elsif ecs_sca_cmd = ECS_CRB_rea then
						--activated_channels(sca_num)(15 downto 8) <= ecs_cmd_packet.data(7 downto 0);
						--new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1,8));
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRB_REA);
					elsif ecs_sca_cmd = ECS_CRC_rea then
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRC_REA);
						--activated_channels(sca_num)(21 downto 16) <= ecs_cmd_packet.data(5 downto 0);
					elsif ecs_sca_cmd = ECS_CRD_rea then
						new_cmd_batch.sca_cmds(0) := sca_cmd_table(CRD_REA);
					end if;
				when others=>
					new_cmd_batch.err :=x"01";
					new_cmd_batch.sca_cmds(0) := x"FF";
					new_cmd_batch.cmd_count := 0;
			end case;
		else
			
			new_cmd_batch.sca :=0;
			new_cmd_batch.ch := (others=>'X');
			new_cmd_batch.cmd_count := 0;
			new_cmd_batch.err := (others=>'X');
			new_cmd_batch.tr := (others=>'X');
			for i in 0 to new_cmd_batch.sca_cmds'high loop
				new_cmd_batch.sca_cmds(i) := (others=>'X');
				new_cmd_batch.sca_cmds_data(i).data := (others=>'X');
				new_cmd_batch.sca_cmds_data(i).len := (others=>'X');
				new_cmd_batch.sca_rpys_data(i).data := (others=>'X');
				new_cmd_batch.sca_rpys_data(i).len := (others=>'X');
			end loop;
		end if;
			
			
			
		sca_cmd_batch_o <= 	new_cmd_batch;	
	end process sca_controller_protocol_builder;
	
	
	
	---------------------------------------------------
	
	sca_controller_protocol_decoder : process ( sca_rpy_batch_i, prot_rpy_en_i) is
		variable ecs_sca_cmd			:	ecs_sca_cmd_enum;
		variable new_ecs_rpy_packet		:	ecs_packet_t;
		
	begin
		new_ecs_rpy_packet.gbt_nr := (others=>'0');
		new_ecs_rpy_packet.sca_nr  := (others=>'0');
		new_ecs_rpy_packet.sca_ch  := (others=>'0');
		new_ecs_rpy_packet.ecs_cmd := (others=>'0');
		new_ecs_rpy_packet.data := (others=>'0');
		new_ecs_rpy_packet.len := (others=>'0');
		new_ecs_rpy_packet.protocol_specific  := (others=>'0');	
		
--		if prot_rpy_en_i='1' then
			ecs_sca_cmd := INVALID;
			for i in ecs_sca_cmd_table_t'left to ecs_sca_cmd_table_t'right loop
				if sca_rpy_batch_i.ecs_cmd = ecs_sca_cmd_table(i) then
					ecs_sca_cmd := i;
					exit;
				end if;
			end loop;
			
			
			new_ecs_rpy_packet.sca_ch := sca_rpy_batch_i.ch;
			
			new_ecs_rpy_packet.gbt_nr := std_logic_vector( to_unsigned(sca_rpy_batch_i.gbt, 8));
			new_ecs_rpy_packet.sca_nr := std_logic_vector( to_unsigned(sca_rpy_batch_i.sca,8));
			new_ecs_rpy_packet.err := (others=>'0');
			
			-- If one of the commands of the batched returned (on their replies) an error, put this first error code as the
			-- ECS Reply's command field
			if sca_rpy_batch_i.err /= (sca_rpy_batch_i.err'range =>'0') and prot_rpy_en_i='1' then
				for j in 0 to sca_rpy_batch_i.err'high -1 loop
				if sca_rpy_batch_i.err(j)/='0' then
						-- \TODO What to do?
						report "There was an error on the GBT-SCA channel operation" & integer'image(j) severity Note;
						
						exit;
					end if;
				end loop; 
				new_ecs_rpy_packet.err := sca_rpy_batch_i.err;
			end if;
				new_ecs_rpy_packet.ecs_cmd := ecs_sca_cmd_table(ecs_sca_cmd);
			case ecs_sca_cmd is 
				when ECS_CRA_wrt | ECS_CRB_wrt | ECS_CRC_wrt | ECS_CRD_wrt  =>
					new_ecs_rpy_packet.len :=  (others=>'0');
					
				when ECS_CRA_rea | ECS_CRB_rea | ECS_CRC_rea | ECS_CRD_rea =>
					new_ecs_rpy_packet.data(31 downto 8) := (others=>'0');
					new_ecs_rpy_packet.data(7 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(7 downto 0);
					
					new_ecs_rpy_packet.protocol_specific(15 downto 0) := (others=>'0');
					--new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(1,16));
					new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(1,8));
				when others =>
					--new_ecs_rpy_packet.ecs_cmd := x"FF";
					null;
			end case;
--		else
--			new_ecs_rpy_packet.sca_nr  := 0;
--			new_ecs_rpy_packet.sca_ch  := (others=>'X');
--			new_ecs_rpy_packet.ecs_cmd := (others=>'X');
--			new_ecs_rpy_packet.data := (others=>'X');
--			new_ecs_rpy_packet.len := (others=>'X');
--			new_ecs_rpy_packet.protocol_specific  := (others=>'X');	
--				
--		end if;
--		
		
		if new_ecs_rpy_packet.ecs_cmd /= (new_ecs_rpy_packet.ecs_cmd'range => '0') then
			err_rply <= '1';
		else
			err_rply <= '0';
		end if;
		ecs_rpy_packet <= new_ecs_rpy_packet;
	end process sca_controller_protocol_decoder;
	
	
	activated_channels_reg_manager : process (clk, rst) is
		variable ecs_sca_cmd			:	ecs_sca_cmd_enum;
	begin
		if rst = '1' then
			for i in 0 to SCA_BY_GBT_COUNT -1 loop
				activated_channels(i) <= (others=>'1');
			end loop;
		elsif rising_edge(clk) then
			if prot_rpy_en_i='1' and err_rply = '0' then
				ecs_sca_cmd := INVALID;
				for i in ecs_sca_cmd_table_t'left to ecs_sca_cmd_table_t'right loop
					if sca_rpy_batch_i.ecs_cmd = ecs_sca_cmd_table(i) then
						ecs_sca_cmd := i;
						exit;
					end if;
				end loop;
				-- \TODO see if this line is not required anymore without inferring a Latch
				activated_channels(sca_rpy_batch_i.sca)(0) <= '1';
				if ecs_sca_cmd = ECS_CRB_wrt then
					activated_channels(sca_rpy_batch_i.sca)(7 downto 1) <= sca_rpy_batch_i.sca_cmds_data(0).data(7 downto 1);
				elsif ecs_sca_cmd = ECS_CRC_wrt then
					activated_channels(sca_rpy_batch_i.sca)(15 downto 8) <= sca_rpy_batch_i.sca_cmds_data(0).data(7 downto 0);
				elsif ecs_sca_cmd = ECS_CRD_wrt then
					activated_channels(sca_rpy_batch_i.sca)(21 downto 16) <=sca_rpy_batch_i.sca_cmds_data(0).data(5 downto 0);
				elsif ecs_sca_cmd = ECS_CRB_rea then
					activated_channels(sca_rpy_batch_i.sca)(7 downto 1) <= sca_rpy_batch_i.sca_rpys_data(0).data(7 downto 1);
				elsif ecs_sca_cmd = ECS_CRC_rea then
					activated_channels(sca_rpy_batch_i.sca)(15 downto 8) <= sca_rpy_batch_i.sca_rpys_data(0).data(7 downto 0);
				elsif ecs_sca_cmd = ECS_CRD_rea then
					activated_channels(sca_rpy_batch_i.sca)(21 downto 16) <=sca_rpy_batch_i.sca_rpys_data(0).data(5 downto 0);
				else
					null;
				end if;
			else
				activated_channels <= activated_channels;
			end if;
		end if;
	end process activated_channels_reg_manager;
	
	
	activated_channels_o <= activated_channels;
	


end architecture RTL;
