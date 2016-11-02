library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SCA_Package.all;


entity i2c_protocol_driver is
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
end entity i2c_protocol_driver;

architecture RTL of i2c_protocol_driver is
	
begin
	
	--Format of the ECS Data Field for I2C:
	-- (I2CFREQ = 2 bit, NByte = 4 bits, ADDR = 10b, DATA .. 
	
	--For RMW commands: 
	-- Command: MASK = 8b, ADDR_6_0 = 8b
	
	--For WRITE, READ commands: 
	-- Command: ( NBytes = 4b,2b = Speed,  3b unused, ADDR_6_0 = 7b)
	
	--For WRITE_EXT, READ_EXT
	-- Command: ( NBytes = 4b,2b = Speed,  ADDR_9_0 = 10b)
	
	
	i2c_protocol_builder : process (  
		 prot_cmd_en_i, tr_cmd_i, ecs_cmd_packet
	) is
		--variable valid_i2c_packet 	: 	std_logic;
		
		variable ecs_i2c_cmd			:	ecs_i2c_cmd_enum;
		--variable sca_num			:	natural range 0 to SCA_COUNT -1;
		
		variable protocol_specific	:	std_logic_vector(15 downto 0);
		--variable protocol_data		:	std_logic_vector(ecs_cmd_packet_int.data'high - 16 downto 0);
		
		
		variable new_cmd_batch		:	prot_cmd_t;
		
		
		variable NByte				:	natural range 0 to 16;
		
		variable j					:	natural range 0 to 6;
		variable k					:	natural range 1 to 16;
		

		
		
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
		
		ecs_i2c_cmd := INVALID;
		
			
		if prot_cmd_en_i='1' then
			--\TODO Report if command is not valid
			for i in ecs_i2c_table_t'left to ecs_i2c_table_t'right loop
				if ecs_cmd_packet.ecs_cmd = ecs_i2c_table(i) then
					ecs_i2c_cmd := i;
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
			--new_cmd_batch.curr_tr := tr;
			j:=0;
			
			if to_integer(unsigned(ecs_cmd_packet.len)) >16 then
				NByte := 0;
				new_cmd_batch.err :=x"01";
			else
				NByte := to_integer(unsigned(ecs_cmd_packet.len)); 
			end if;
			new_cmd_batch.ecs_len := ecs_cmd_packet.len;
			report "NByte = " & natural'image(NByte);
			
			-- Protocol Specific field: {"XXXX",  Freq = 2b, I2C Address = 10b}	
			
			
			case ecs_i2c_cmd is 
				when ECS_I2C_S_7B_W =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_S_7B_W);
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8));
				when ECS_I2C_S_7B_R =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_S_7B_R);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := ecs_cmd_packet.data(7 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
				when ECS_I2C_S_10B_W =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_S_10B_W);
					new_cmd_batch.sca_cmds_data(0).data(23 downto 0) := ecs_cmd_packet.data(23 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(3, 8));
				when ECS_I2C_S_10B_R =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_S_10B_R);
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8));
				when ECS_I2C_M_7B_W =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_M_7B_R);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := ecs_cmd_packet.data(7 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
				when ECS_I2C_M_7B_R =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_M_7B_R);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := ecs_cmd_packet.data(7 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
				when ECS_I2C_M_10B_W =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_M_10B_W );
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8));
				when ECS_I2C_M_10B_R =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_M_10B_R);
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8)); 
				when ECS_I2C_RMW_AND =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_RMW_AND);
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8)); 
				when ECS_I2C_RMW_OR =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_RMW_OR);
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8)); 
				when ECS_I2C_RMW_XOR =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_RMW_XOR);
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := ecs_cmd_packet.data(15 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8)); 
				when ECS_I2C_W_DATA0 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA0);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 0) := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8)); 
				when ECS_I2C_R_DATA0 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_DATA0);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');
				when ECS_I2C_W_DATA1 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA1);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 0) := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8));  
				when ECS_I2C_R_DATA1 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_DATA1);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');
				when ECS_I2C_W_DATA2 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA2);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 0) := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8)); 
				when ECS_I2C_R_DATA2 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_DATA2);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');
				when ECS_I2C_W_DATA3 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA3);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 0) := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8)); 
				when ECS_I2C_R_DATA3 =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_DATA2);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');
				when ECS_I2C_W_CTRL =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_CTRL);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := 
						ecs_cmd_packet.data(7 downto 0) ;
					new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8));
				when ECS_I2C_R_CTRL =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_CTRL);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');
				when ECS_I2C_W_MSK =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_MSK);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := 
						ecs_cmd_packet.data(7 downto 0) ;
					new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8));
				when ECS_I2C_R_MSK =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_MSK);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');
				when ECS_I2C_R_STR =>
					new_cmd_batch.cmd_count := 1;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_STR);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');
				when ECS_I2C_WRITE | ECS_I2C_WRITE_EXT | ECS_I2C_READ | ECS_I2C_READ_EXT =>
				
					-- First write the I2C CTRL register
					--{'0',I2CNBYTE,I2CFREQ}
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_CTRL);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := 
						'0' & ecs_cmd_packet.len(4 downto 0) & protocol_specific(11 downto 10);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
					
					j := 1;
					
					if ecs_i2c_cmd = ECS_I2C_WRITE or ecs_i2c_cmd = ECS_I2C_WRITE_EXT then
						
						
						if NByte>1 then --MULTI BYTE WRITE
							
							new_cmd_batch.cmd_count := 1 + (((NByte-1)/4) +1 ) + 1;
							--On multi byte writes first you have to fill the data registers
							-- then issue the I2C Write commmand
							
							--k:=1;
							--For each byte on the ecs_cmd_packet
							--for i in 1 to ecs_cmd_packet.data'length/8 loop
							for i in 1 to 4  loop
								if i > ((NByte-1)/4)+1 then
									exit;
								end if;
								new_cmd_batch.sca_cmds_data(i).data := ecs_cmd_packet.data(32*i -1 downto 32*(i-1)); 
								new_cmd_batch.sca_cmds_data(i).len := std_logic_vector(to_unsigned(4, 8));
								case (i) is
								when 1 =>
									new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_W_DATA0);
								when 2=>
									new_cmd_batch.sca_cmds(2) := i2c_cmd_table(I2C_W_DATA1);
								when 3=>
									new_cmd_batch.sca_cmds(3) := i2c_cmd_table(I2C_W_DATA2);
								when others=> --4
									new_cmd_batch.sca_cmds(4) := i2c_cmd_table(I2C_W_DATA3);
								end case;
								j := j + 1;
							end loop;
							if ecs_i2c_cmd = ECS_I2C_WRITE then
								new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_M_7B_W);
								new_cmd_batch.sca_cmds_data(j).data(31 downto 8) := (others=>'0');
								new_cmd_batch.sca_cmds_data(j).data(7 downto 0) :=  "0" & protocol_specific(6 downto 0);
								new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(1, 8));
							else
								new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_M_10B_W);
								new_cmd_batch.sca_cmds_data(j).data(31 downto 16) := (others=>'0');
								new_cmd_batch.sca_cmds_data(j).data(15 downto 0) := "011110" & protocol_specific(9 downto 0);
								new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(2, 8));
							end if;
						else
							
							new_cmd_batch.cmd_count := 2;
							--Single Byte Operation
							if ecs_i2c_cmd = ECS_I2C_WRITE then
								new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_7B_W);
								--7bit addr
								new_cmd_batch.sca_cmds_data(j).data(7 downto 0) := '0' & ecs_cmd_packet.protocol_specific(6 downto 0);
								--1 byte data
								new_cmd_batch.sca_cmds_data(j).data(15 downto 8) := ecs_cmd_packet.data(7 downto 0);
								new_cmd_batch.sca_cmds_data(j).data(31 downto 16) := (others=>'0');
								new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned( 2 ,8));
								 
							else
								new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_10B_W);
								
								--10 bit addr
								new_cmd_batch.sca_cmds_data(j).data(7 downto 0) := "011110" & ecs_cmd_packet.protocol_specific(9 downto 8);
								--1 byte data
								new_cmd_batch.sca_cmds_data(j).data(15 downto 8) :=ecs_cmd_packet.protocol_specific(7 downto 0);
								new_cmd_batch.sca_cmds_data(j).data(23 downto 16) := ecs_cmd_packet.data(7 downto 0);
								new_cmd_batch.sca_cmds_data(1).data(31 downto 24) := (others=>'0');
								new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned( 3 ,8));
								
							end if;
							
						end if;
					elsif ecs_i2c_cmd = ECS_I2C_READ or ecs_i2c_cmd = ECS_I2C_READ_EXT then
						
						if NByte>1 then --MULTI BYTE READ
							
							--new_cmd_batch.cmd_count := ((NByte+1)/4) + 2;
							-- 1 I2c ctrl write + 1 I2c multibyte read + 1 up to 4 i2c data buffers read  
							new_cmd_batch.cmd_count := 1 + 1  + (((NByte-1)/4) +1 );
							
							--On multi byte reads first you have to issue the I2C Read Command
							-- then Read each of the data registers associated
							if ecs_i2c_cmd = ECS_I2C_READ then
								new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_M_7B_R);
								new_cmd_batch.sca_cmds_data(1).data(7 downto 0) := "0" & ecs_cmd_packet.protocol_specific(6 downto 0);
								new_cmd_batch.sca_cmds_data(1).data(31 downto 8) := (others=>'0');
								new_cmd_batch.sca_cmds_data(1).len := std_logic_vector(to_unsigned( 1 ,8));
							else
								new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_M_10B_R);
								--10 bit addr
								new_cmd_batch.sca_cmds_data(1).data(7 downto 0) := "011110" & ecs_cmd_packet.protocol_specific(9 downto 8);
								--1 byte data
								new_cmd_batch.sca_cmds_data(1).data(15 downto 8) :=ecs_cmd_packet.protocol_specific(7 downto 0);
								new_cmd_batch.sca_cmds_data(1).data(31 downto 16) := (others=>'0');
								new_cmd_batch.sca_cmds_data(1).len := std_logic_vector(to_unsigned( 2 ,8));
							end if;
							
							--Read each of the required data registers needed
							--i = total byte counter, j = 32 bit data buffer counter, k = in word byte counter
							j:= 1;
							k:=1;
							for i in 1 to ecs_cmd_packet.data'length/8 loop
								if i > NByte  then
									exit;
								end if;
								if i > j*4 then
									j:=j+1;
									k:=1;
								end if;
								--new_cmd_batch.sca_cmds_data(j+1).data(k*8-1 downto (k-1)*8) := ecs_cmd_packet.data(i*8-1 downto (i-1)*8); 
								--new_cmd_batch.sca_cmds_data(j+1).len := std_logic_vector(to_unsigned(4, 8));
								new_cmd_batch.sca_cmds_data(j+1).data := (others=>'0');
								new_cmd_batch.sca_cmds_data(j+1).len := std_logic_vector(to_unsigned(0, 8));
								k:=k+1;
								--case (j-2) is
								case (j-1) is
								when 0 =>
									new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA0);
								when 1=>
									new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA1);
								when 2=>
									new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA2);
								when others=> --3
									new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA3);
								end case;
							end loop;
							--
							
						else
							
							new_cmd_batch.cmd_count := 2;
							
							j:= 1;
							if ecs_i2c_cmd = ECS_I2C_READ then
								new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_7B_R);
								--protocol_specific(6 downto 0) = 7 bits I2c address
								new_cmd_batch.sca_cmds_data(j).data(31 downto 8) := (others=>'0');
								new_cmd_batch.sca_cmds_data(j).data(7 downto 0) :=  "0" & protocol_specific(6 downto 0);
								new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(1, 8));
							else
								new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_10B_R);
								--protocol_specific(6 downto 0) = 10 bits I2c address
								new_cmd_batch.sca_cmds_data(j).data(31 downto 16) := (others=>'0');
								new_cmd_batch.sca_cmds_data(j).data(15 downto 0) := "011110" & protocol_specific(9 downto 0);
								new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(2, 8));
							end if;
						end if;
						
					end if;
				
				-- End by writing the Proper I2C command
				
				
				when ECS_I2C_W_R_DATA0 =>
					new_cmd_batch.cmd_count := 2;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA0);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8)); 
					new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_R_DATA0);
					new_cmd_batch.sca_cmds_data(1).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(1).len := (others=>'0');
				when ECS_I2C_W_R_DATA1 =>
					new_cmd_batch.cmd_count := 2;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA1);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8)); 
					new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_R_DATA1);
					new_cmd_batch.sca_cmds_data(1).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(1).len := (others=>'0');
				when ECS_I2C_W_R_DATA2 =>
					new_cmd_batch.cmd_count := 2;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA2);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8)); 
					new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_R_DATA2);
					new_cmd_batch.sca_cmds_data(1).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(1).len := (others=>'0');
				when ECS_I2C_W_R_DATA3 =>
					new_cmd_batch.cmd_count := 2;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_DATA3);
					new_cmd_batch.sca_cmds_data(0).data := ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(4, 8)); 
					new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_R_DATA3);
					new_cmd_batch.sca_cmds_data(1).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(1).len := (others=>'0');
				when ECS_I2C_W_R_CTRL =>
					new_cmd_batch.cmd_count := 2;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_CTRL);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := 
						ecs_cmd_packet.data(7 downto 0) ;
					new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8));
					new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_R_CTRL);
					new_cmd_batch.sca_cmds_data(1).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(1).len := std_logic_vector(to_unsigned(2, 8));
				when ECS_I2C_W_R_MSK =>
					new_cmd_batch.cmd_count := 2;
					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_MSK);
					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := 
						ecs_cmd_packet.data(7 downto 0) ;
					new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(2, 8));
					new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_R_MSK);
					new_cmd_batch.sca_cmds_data(1).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(1).len := std_logic_vector(to_unsigned(2, 8));
				when INVALID =>
					new_cmd_batch.err :=x"01";
				new_cmd_batch.ecs_cmd := x"FF";
				new_cmd_batch.cmd_count := 0;
			end case;
			
--			case ecs_i2c_cmd is
--				
--			 
--			when ECS_I2C_WRITE | ECS_I2C_WRITE_EXT | ECS_I2C_READ | ECS_I2C_READ_EXT =>
--				
--					-- First write the I2C CTRL register
--				--{"00",I2CNBYTE,I2CFREQ}
--				new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_CTRL);
--				new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := 
--					"00" & ecs_cmd_packet.len(3 downto 0) & protocol_specific(11 downto 10);
--				new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
--				new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
--				
--				j := 1;
--				
--				if ecs_i2c_cmd = ECS_I2C_WRITE or ecs_i2c_cmd = ECS_I2C_WRITE_EXT then
--					
--					
--					if NByte>1 then --MULTI BYTE WRITE
--						
--						new_cmd_batch.cmd_count := 1 + (((NByte-1)/4) +1 ) + 1;
--						--On multi byte writes first you have to fill the data registers
--						-- then issue the I2C Write commmand
--						
--						--k:=1;
--						--For each byte on the ecs_cmd_packet
--						--for i in 1 to ecs_cmd_packet.data'length/8 loop
--						for i in 1 to ecs_cmd_packet.data'length/8  loop
--							if i > ((NByte-1)/4)+1 or i >= 4 then
--								exit;
--							end if;
--							new_cmd_batch.sca_cmds_data(i).data := ecs_cmd_packet.data(32*i -1 downto 32*(i-1)); 
--							new_cmd_batch.sca_cmds_data(i).len := std_logic_vector(to_unsigned(4, 8));
--							case (i) is
--							when 1 =>
--								new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_W_DATA0);
--							when 2=>
--								new_cmd_batch.sca_cmds(2) := i2c_cmd_table(I2C_W_DATA1);
--							when 3=>
--								new_cmd_batch.sca_cmds(3) := i2c_cmd_table(I2C_W_DATA2);
--							when others=> --4
--								new_cmd_batch.sca_cmds(4) := i2c_cmd_table(I2C_W_DATA3);
--							end case;
--							j := j + 1;
--						end loop;
--						if ecs_i2c_cmd = ECS_I2C_WRITE then
--							new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_M_7B_W);
--							new_cmd_batch.sca_cmds_data(j).data(31 downto 8) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(j).data(7 downto 0) :=  "0" & protocol_specific(6 downto 0);
--							new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(1, 8));
--						else
--							new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_M_10B_W);
--							new_cmd_batch.sca_cmds_data(j).data(31 downto 16) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(j).data(15 downto 0) := "011110" & protocol_specific(9 downto 0);
--							new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(2, 8));
--						end if;
--					else
--						
--						new_cmd_batch.cmd_count := 2;
--						--Single Byte Operation
--						if ecs_i2c_cmd = ECS_I2C_WRITE then
--							new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_7B_W);
--							--7bit addr
--							new_cmd_batch.sca_cmds_data(j).data(7 downto 0) := '0' & ecs_cmd_packet.protocol_specific(6 downto 0);
--							--1 byte data
--							new_cmd_batch.sca_cmds_data(j).data(15 downto 8) := ecs_cmd_packet.data(7 downto 0);
--							new_cmd_batch.sca_cmds_data(j).data(31 downto 16) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned( 2 ,8));
--							 
--						else
--							new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_10B_W);
--							
--							--10 bit addr
--							new_cmd_batch.sca_cmds_data(j).data(7 downto 0) := "011110" & ecs_cmd_packet.protocol_specific(9 downto 8);
--							--1 byte data
--							new_cmd_batch.sca_cmds_data(j).data(15 downto 8) :=ecs_cmd_packet.protocol_specific(7 downto 0);
--							new_cmd_batch.sca_cmds_data(j).data(23 downto 16) := ecs_cmd_packet.data(7 downto 0);
--							new_cmd_batch.sca_cmds_data(1).data(31 downto 24) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned( 3 ,8));
--							
--						end if;
--						
--					end if;
--				elsif ecs_i2c_cmd = ECS_I2C_READ or ecs_i2c_cmd = ECS_I2C_READ_EXT then
--					
--					if NByte>1 then --MULTI BYTE READ
--						
--						--new_cmd_batch.cmd_count := to_integer((unsigned(protocol_specific(15 downto 12))+1)/4) + 1;
--						new_cmd_batch.cmd_count := ((NByte+1)/4) + 2;
--						
--						--On multi byte reads first you have to issue the I2C Read Command
--						-- then Read each of the data registers associated
--						if ecs_i2c_cmd = ECS_I2C_READ then
--							new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_M_7B_R);
--							new_cmd_batch.sca_cmds_data(1).data(7 downto 0) := "0" & ecs_cmd_packet.protocol_specific(6 downto 0);
--							new_cmd_batch.sca_cmds_data(1).data(31 downto 8) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(1).len := std_logic_vector(to_unsigned( 1 ,8));
--						else
--							new_cmd_batch.sca_cmds(1) := i2c_cmd_table(I2C_M_10B_R);
--							--10 bit addr
--							new_cmd_batch.sca_cmds_data(1).data(7 downto 0) := "011110" & ecs_cmd_packet.protocol_specific(9 downto 8);
--							--1 byte data
--							new_cmd_batch.sca_cmds_data(1).data(15 downto 8) :=ecs_cmd_packet.protocol_specific(7 downto 0);
--							new_cmd_batch.sca_cmds_data(1).data(31 downto 16) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(1).len := std_logic_vector(to_unsigned( 2 ,8));
--						end if;
--						
--						--Read each of the required data registers needed
--						j:= 1;
--						k:=1;
--						for i in 1 to ecs_cmd_packet.data'length/8 loop
--							if i >= NByte or i >= 16  then
--								exit;
--							end if;
--							if i > j*4 then
--								j:=j+1;
--								k:=1;
--							end if;
--							new_cmd_batch.sca_cmds_data(j+1).data(k*8-1 downto (k-1)*8) := ecs_cmd_packet.data(i*8-1 downto (i-1)*8); 
--							new_cmd_batch.sca_cmds_data(j+1).len := std_logic_vector(to_unsigned(4, 8));
--							K:=k+1;
--							case (j-2) is
--							when 0 =>
--								new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA0);
--							when 1=>
--								new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA1);
--							when 2=>
--								new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA2);
--							when others=> --3
--								new_cmd_batch.sca_cmds(j+1) := i2c_cmd_table(I2C_R_DATA3);
--							end case;
--						end loop;
--						--
--						
--					else
--						
--						new_cmd_batch.cmd_count := 2;
--						
--						j:= 1;
--						if ecs_i2c_cmd = ECS_I2C_READ then
--							new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_7B_R);
--							--protocol_specific(6 downto 0) = 7 bits I2c address
--							new_cmd_batch.sca_cmds_data(j).data(31 downto 8) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(j).data(7 downto 0) :=  "0" & protocol_specific(6 downto 0);
--							new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(1, 8));
--						else
--							new_cmd_batch.sca_cmds(j) := i2c_cmd_table(I2C_S_10B_R);
--							--protocol_specific(6 downto 0) = 10 bits I2c address
--							new_cmd_batch.sca_cmds_data(j).data(31 downto 16) := (others=>'0');
--							new_cmd_batch.sca_cmds_data(j).data(15 downto 0) := "011110" & protocol_specific(9 downto 0);
--							new_cmd_batch.sca_cmds_data(j).len := std_logic_vector(to_unsigned(2, 8));
--						end if;
--					end if;
--					
--				end if;
--				
--				-- End by writing the Proper I2C command
--				
--				
--						
--			when ECS_I2C_RMW_AND | ECS_I2C_RMW_OR | ECS_I2C_RMW_XOR =>
--				--These kind of commands comprehends a write on the mask register and a rmw operation 
--				new_cmd_batch.cmd_count := 2;
--				--SCA Data Field has only one byte
--				--I2C_wrt_MASK
--				new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_MSK);
--				new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
--				--Mask value
--				new_cmd_batch.sca_cmds_data(0).data(31 downto 31 - 7) :=  protocol_specific(15 downto 8);
--				new_cmd_batch.sca_cmds_data(0).data(31 - 8 downto 0) := (others=>'0');
--				
--				
--				--Now the RMW command
--				if ecs_i2c_cmd = ECS_I2C_RMW_AND then
--					new_cmd_batch.sca_cmds(1) :=  i2c_cmd_table(I2C_RMW_AND);
--				elsif ecs_i2c_cmd = ECS_I2C_RMW_OR then
--					new_cmd_batch.sca_cmds(1) :=  i2c_cmd_table(I2C_RMW_OR);
--				else
--					new_cmd_batch.sca_cmds(1):=  i2c_cmd_table(I2C_RMW_XOR);
--				end if;
--				--SCA Data Field has only one byte
--				new_cmd_batch.sca_cmds_data(1).len := std_logic_vector(to_unsigned(1, 8));
--				--7 bit I2C address
--				new_cmd_batch.sca_cmds_data(1).data(7 downto 0) :=  "0" & protocol_specific(6 downto 0);
--				new_cmd_batch.sca_cmds_data(1).data(31 downto 8) := (others=>'0');
--				--
--			when ECS_I2C_W_CTRL | ECS_I2C_W_MSK =>
--				new_cmd_batch.cmd_count := 1;
--				if ecs_i2c_cmd = ECS_I2C_W_CTRL then
--					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_CTRL);
--					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) := 
--					"00" & ecs_cmd_packet.len(3 downto 0) & protocol_specific(11 downto 10);
--				new_cmd_batch.sca_cmds_data(0).data(31 downto 8) := (others=>'0');
--				new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
--				else
--					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_W_MSK);
--					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(1, 8));
--					new_cmd_batch.sca_cmds_data(0).data(7 downto 0) :=  ecs_cmd_packet.data(7 downto 0);
--					new_cmd_batch.sca_cmds_data(0).data(31 downto 0) := (others=>'0');
--				end if;
--				
--				--
--			when ECS_I2C_R_CTRL | ECS_I2C_R_MSK =>
--				new_cmd_batch.cmd_count := 1;
--				if ecs_i2c_cmd = ECS_I2C_R_CTRL then
--					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_CTRL);
--				else
--					new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_MSK);
--				end if;
--				--SCA Data Field has only one byte
--				new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(0, 8));
--				new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(0, 8));
--				new_cmd_batch.sca_cmds_data(0).data(31 downto 0) :=  (others=>'0');
--			when ECS_I2C_R_STR =>
--				new_cmd_batch.cmd_count := 1;
--				new_cmd_batch.sca_cmds(0) := i2c_cmd_table(I2C_R_STR);
--				new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned(0, 8));
--				new_cmd_batch.sca_cmds_data(0).data(31 downto 0) :=  (others=>'0');
--			when others=>
--				new_cmd_batch.err :=x"01";
--				new_cmd_batch.ecs_cmd := x"FF";
--				new_cmd_batch.cmd_count := 0;
--			end case;

			--new_cmd_batch.cmd_counter := 0;
			
			
				
		end if;
		
		
		sca_cmd_batch_o <= new_cmd_batch;
		
	end process i2c_protocol_builder;
	
	--error <= '0';
	
	
	
	
	i2c_protocol_decoder : process ( sca_rpy_batch_i, prot_rpy_en_i) is
		variable new_ecs_rpy_packet		:	ecs_packet_t;
		variable ecs_i2c_cmd			:	ecs_i2c_cmd_enum;
		variable j						:	natural range 0 to 6;
		variable k						:	natural range 1 to 16;
		
		variable NByte				:	natural range 1 to 16;
		
	begin	
		
		new_ecs_rpy_packet.err := (others=>'0');
		new_ecs_rpy_packet.gbt_nr := (others=>'0');
		new_ecs_rpy_packet.sca_nr  := (others=>'0');
		new_ecs_rpy_packet.sca_ch  := (others=>'0');
		new_ecs_rpy_packet.ecs_cmd := (others=>'0');
		new_ecs_rpy_packet.data := (others=>'0');
		new_ecs_rpy_packet.len := (others=>'0');
		new_ecs_rpy_packet.protocol_specific  := (others=>'0');
		
		
		ecs_i2c_cmd := INVALID;
		
		if prot_rpy_en_i ='1' then 
			for i in ecs_i2c_table_t'left to ecs_i2c_table_t'right loop
				if sca_rpy_batch_i.ecs_cmd = ecs_i2c_table(i) then
					ecs_i2c_cmd := i;
					exit;
				end if;
			end loop;
		
			new_ecs_rpy_packet.sca_ch := sca_rpy_batch_i.ch;
			new_ecs_rpy_packet.gbt_nr := std_logic_vector( to_unsigned( sca_rpy_batch_i.gbt, 8));
			new_ecs_rpy_packet.sca_nr := std_logic_vector( to_unsigned(sca_rpy_batch_i.sca,8));
			
			new_ecs_rpy_packet.err := (others=>'0');
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
	
			new_ecs_rpy_packet.ecs_cmd := ecs_i2c_table(ecs_i2c_cmd);
			if to_integer(unsigned(sca_rpy_batch_i.ecs_len)) >=16 then
				NByte := 16;
				new_ecs_rpy_packet.len :=  std_logic_vector(to_unsigned(16,8));
			else
				NByte := to_integer(unsigned(sca_rpy_batch_i.ecs_len));
				new_ecs_rpy_packet.len :=  sca_rpy_batch_i.ecs_len;
			end if;
			new_ecs_rpy_packet.protocol_specific(15 downto 0) := (others=>'0');
			
			
			case ecs_i2c_cmd is 
			when ECS_I2C_WRITE | ECS_I2C_WRITE_EXT | ECS_I2C_READ | ECS_I2C_READ_EXT =>
				if ecs_i2c_cmd = ECS_I2C_WRITE or ecs_i2c_cmd = ECS_I2C_WRITE_EXT then
					new_ecs_rpy_packet.data := (others=>'0');
				elsif ecs_i2c_cmd = ECS_I2C_READ_EXT or ecs_i2c_cmd = ECS_I2C_READ then
					-- i = total byte counter, j = 32 bit data buffer counter, k = in data buffer byte counter
					if NByte>1 then --MULTI BYTE Read
						j := 1;
						k := 1;
						
						for i in 1 to ecs_cmd_packet.data'length/8 loop
							if i > NByte or i > 16 then
								exit;
							end if;
							if i > j*4 then
								j:=j+1;
								k:=1;
							end if;
							--! j = {1,2,3,4} , data buffers starts at reply packet index 2, so we use j+1 = {2,3,4,5}
							new_ecs_rpy_packet.data(i*8-1 downto (i-1)*8)  := sca_rpy_batch_i.sca_rpys_data(j+1).data(k*8-1 downto (k-1)*8);
							k:=k+1;
						end loop;
						j := j + 1;
					else
						--new_ecs_rpy_packet.data(7 downto 0) :=  sca_rpy_batch_i.sca_rpys_data(1).data(7 downto 0);
						--Test
						new_ecs_rpy_packet.data(7 downto 0) :=  sca_rpy_batch_i.sca_rpys_data(1).data(15 downto 8);
					end if;
				end if;
			when ECS_I2C_RMW_AND | ECS_I2C_RMW_OR | ECS_I2C_RMW_XOR =>
				new_ecs_rpy_packet.data := (others=>'0');
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(2, 8));
			when ECS_I2C_W_CTRL | ECS_I2C_W_MSK =>
				new_ecs_rpy_packet.data := (others=>'0');
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(2, 8));
			when ECS_I2C_R_CTRL =>
				new_ecs_rpy_packet.data(7 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(7 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(1, 8));
			when ECS_I2C_R_MSK =>
				new_ecs_rpy_packet.data(7 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(7 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(1, 8));
			when ECS_I2C_R_STR  =>
				new_ecs_rpy_packet.data(7 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(7 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(1, 8));
			when ECS_I2C_S_7B_W | ECS_I2C_S_10B_W | ECS_I2C_M_7B_W | ECS_I2C_M_7B_R 
				| ECS_I2C_M_10B_W | ECS_I2C_M_10B_R =>
					new_ecs_rpy_packet.data(7 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(7 downto 0);
					new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(2, 8));
			when ECS_I2C_S_7B_R | ECS_I2C_S_10B_R   =>
				new_ecs_rpy_packet.data(15 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data(15 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(2, 8));
			when ECS_I2C_W_DATA0 | ECS_I2C_W_DATA1 | ECS_I2C_W_DATA2 | ECS_I2C_W_DATA3 =>
				new_ecs_rpy_packet.data := (others=>'0');
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(2, 8));
			when ECS_I2C_R_DATA0 | ECS_I2C_R_DATA1 | ECS_I2C_R_DATA2 | ECS_I2C_R_DATA3 =>
				new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(4, 8));
			when ECS_I2C_W_R_DATA0 | ECS_I2C_W_R_DATA1 | ECS_I2C_W_R_DATA2 | ECS_I2C_W_R_DATA3  =>
				new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(1).data;
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(4, 8));
			when ECS_I2C_W_R_CTRL | ECS_I2C_W_R_MSK =>
				new_ecs_rpy_packet.data(7 downto 0) := sca_rpy_batch_i.sca_rpys_data(1).data(7 downto 0);
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(2, 8));
			when others=>
				new_ecs_rpy_packet.ecs_cmd := x"FF";
				new_ecs_rpy_packet.len := std_logic_vector(to_unsigned(0, 8));
			end case;
		end if;
--		else
--			new_ecs_rpy_packet.sca_nr  := 0;
--			new_ecs_rpy_packet.sca_ch  := (others=>'X');
--			new_ecs_rpy_packet.ecs_cmd := (others=>'X');
--			new_ecs_rpy_packet.data := (others=>'X');
--			new_ecs_rpy_packet.len := (others=>'X');
--			new_ecs_rpy_packet.protocol_specific  := (others=>'X');
--		end if;
		ecs_rpy_packet <= new_ecs_rpy_packet;
	end process i2c_protocol_decoder;
	
	
	
	
	

--	i2c_protocol_builder : process(valid_ecs_packet, ecs_cmd_packet) is
--	
--	variable i2c_cmd				:	i2c_cmd_enum;
--	variable i2c_len			:	std_logic_vector(7 downto 0);
--	variable a_7_0				:	std_logic_vector(7 downto 0);
--	variable a_9_8				:	std_logic_vector(7 downto 0); -- has to fill a full byte to keep alignement
--	variable valid_i2c_packet 	: 	std_logic;
--	
--	variable data				:	std_logic_vector(payload.data'high downto 0);
--	begin
--		valid_i2c_packet:='0';
--		if valid_ecs_packet='1' then
--			for i in i2c_cmd_table'left to i2c_cmd_table'right loop
--				if i2c_cmd_table(i) = ecs_cmd_packet.sca_cmd then
--					i2c_cmd := i;
--					valid_i2c_packet:='1';
--					exit;
--				end if;
--			end loop;
--			--
--			
--			a_7_0 := ecs_cmd_packet.protocol_specific(7 downto 0);
--			a_9_8 := "000000" & ecs_cmd_packet.protocol_specific(9 downto 8);
--			i2c_len :=  ecs_cmd_packet.protocol_specific(23 downto 16);
--			
--			--
--			data := (others=>'0');
--			payload.cmd_or_ack <= i2c_cmd_table(i2c_cmd);
--			--
--			case i2c_cmd is 
--				when single_byte_write_normal_mode =>
--					-- C: CH# + TR# + CMD + A[7:0] + DW
--					data(2*8 -1 downto 0) := a_7_0 & ecs_cmd_packet.data(7 downto 0);
--					payload_len <= 2;
--				when single_byte_read_normal_mode =>
--					-- C: CH# + TR# + CMD + A[7:0]
--					data(1*8 -1 downto 0) := a_7_0;
--					payload_len <= 1;
--				when single_byte_write_extended_mode =>
--					-- C: CH# + TR# + CMD + A[9:8] + A[7:0] + DW
--					data(3*8 -1 downto 0) := a_9_8 & a_7_0 & ecs_cmd_packet.data(7 downto 0);
--					payload_len <= 3;
--				when single_byte_read_extended_mode =>
--					-- C: CH# + TR# + CMD + A[9:8] + A[7:0]
--					data(2*8 -1 downto 0) := a_9_8 & a_7_0;
--					payload_len <= 2;
--				when rmw_and_normal_mode | rmw_or_normal_mode | rmw_xor_normal_mode  =>
--					-- C: CH# + TR# + CMD + A[7:0]
--					data(1*8 -1 downto 0) :=  a_7_0;
--					payload_len <= 1;
--				when rmw_and_extended_mode | rmw_or_extended_mode | rmw_xor_extended_mode =>
--					-- C: CH# + TR# + CMD + A[9:8] + A[7:0]
--					data(2*8 -1 downto 0) :=  a_9_8 & a_7_0;
--					payload_len <= 2;
--				when multiple_byte_write_in_extended_mode  =>
--					-- C: CH# + TR# + CMD + LEN + A[9:8] + A[7:0] + DW
--					data(4*8 -1 downto 0) := i2c_len & a_9_8 & a_7_0 & ecs_cmd_packet.data(7 downto 0);
--					payload_len <= 4;
--				when multiple_byte_read_in_extended_mode =>
--					-- C: CH# + TR# + CMD + LEN + A[9:8] + A[7:0]
--					data(3*8 -1 downto 0) := i2c_len & a_9_8 & a_7_0;
--					payload_len <= 3;
--				when multiple_byte_write_in_normal_mode =>
--					-- C: CH# + TR# + CMD + LEN + A[7:0] + DW
--					data(3*8 -1 downto 0) := i2c_len & a_7_0 & ecs_cmd_packet.data(7 downto 0);
--					payload_len <= 3;
--				when multiple_byte_read_in_normal_mode =>
--					-- C: CH# + TR# + CMD + LEN + A[7:0]
--					data(2*8 -1 downto 0) := i2c_len & a_7_0;
--					payload_len <= 2;
--				when write_control_register_a =>
--					-- C: CH# + TR# + CMD + DW
--					data(1*8 -1 downto 0) := ecs_cmd_packet.data(7 downto 0);
--					payload_len <= 1;
--				when read_control_register_a | read_status_register_a | read_status_register_b =>
--					-- C: CH# + TR# + CMD
--					payload_len <= 0;
--				when write_mask_register =>
--					-- C: CH# + TR# + CMD + DW
--					data(1*8 -1 downto 0) := ecs_cmd_packet.data(7 downto 0);
--					payload_len <= 1;
--				when read_mask_register | i2c_channel_reset =>
--					-- C: CH# + TR# + CMD
--					payload_len <= 0;
--			end case;
--	
--		end if;
--		
--		payload.data <= data;
--		payload.ch <= ecs_cmd_packet.sca_ch;
--		
--		valid_sca_packet <= valid_i2c_packet;
--	end process i2c_protocol_builder;	

end architecture RTL;
