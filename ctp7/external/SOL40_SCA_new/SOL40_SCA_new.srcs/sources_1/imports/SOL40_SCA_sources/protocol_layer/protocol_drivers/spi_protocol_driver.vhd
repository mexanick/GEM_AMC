library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SCA_Package.all;


entity spi_protocol_driver is
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
end entity spi_protocol_driver;

architecture RTL of spi_protocol_driver is
	
--Protocol Specific SPI - {'0',INVSCLK,'0',IE = 1b, LSB=1b,TX_NEG= 1b,RX_NEG=1b,GO = 1b,   '0',Nbits = 7b}
--Control Register of the SPI --{'0',INVSCLK,'0',IE,LSB,TXNEG,RXNEG,GO/BUSY,"0",CHARLEN = 6b}
		
begin
	
--CHARLEN The value contained in the CharLen field represents how many bits will be transmitted during 
--	the following transmission, from 1 to 128 (value 0 -> 128bit transmission)
	
	spi_protocol_builder : process (
		prot_cmd_en_i, tr_cmd_i, ecs_cmd_packet
	) is
		variable ecs_spi_cmd			:	ecs_spi_cmd_enum;
		variable new_cmd_batch		:	prot_cmd_t;		
		variable Nbits				:	natural range 1 to 128;
		variable CHARLEN			:	natural range 0 to 127;
		variable k					:	natural range 0 to 4;
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
		
		ecs_spi_cmd := INVALID;
		
			
		if prot_cmd_en_i='1' then
			for i in ecs_spi_cmd_table_t'left to ecs_spi_cmd_table_t'right loop
				if ecs_cmd_packet.ecs_cmd = ecs_spi_cmd_table(i) then
					ecs_spi_cmd := i;
					exit;
				end if;
			end loop;
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
			
			
			new_cmd_batch.ecs_len := ecs_cmd_packet.len;
			
			case ecs_spi_cmd is 
				when ECS_SPI_GO =>
					--
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_GO);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_W_CTRL =>
					--
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_wrt_CTRL);
					--
					new_cmd_batch.sca_cmds_data(0).data(31 downto 21) := 
						ecs_cmd_packet.data(31 downto 21) ;
					new_cmd_batch.sca_cmds_data(0).data(19 downto 16) := 
						ecs_cmd_packet.data(19 downto 16) ;
						
					--RESERVED UNMASKED BIT
					new_cmd_batch.sca_cmds_data(0).data(20) := '1';
					new_cmd_batch.sca_cmds_data(0).data(15 downto 0) := 
						(others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := 
						std_logic_vector(to_unsigned(4, 8));
				when ECS_SPI_R_CTRL =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_rea_CTRL);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_W_SS =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_wrt_SS);
					--new_cmd_batch.sca_cmds_data(0).data(23 downto 16) :=  ecs_cmd_packet.data(23 downto 16);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 24) :=  ecs_cmd_packet.data(31 downto 24);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 4 ,8));	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_R_SS =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_rea_SS);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_W_FREQ =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_wrt_DIV);
					new_cmd_batch.sca_cmds_data(0).data(31 downto 16) :=  ecs_cmd_packet.data(31 downto 16);
					new_cmd_batch.sca_cmds_data(0).len := std_logic_vector(to_unsigned( 4 ,8));	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_R_FREQ =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_rea_DIV);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_wrt_Tx0 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_wrt_Tx0);
					new_cmd_batch.sca_cmds_data(0).data :=  ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := ecs_cmd_packet.len;	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_rea_Tx0 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_rea_Tx0);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_wrt_Tx1 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_wrt_Tx1);
					new_cmd_batch.sca_cmds_data(0).data :=  ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := ecs_cmd_packet.len;	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_rea_Tx1 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_rea_Tx1);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_wrt_Tx2 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_wrt_Tx2);
					new_cmd_batch.sca_cmds_data(0).data :=  ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := ecs_cmd_packet.len;	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_rea_Tx2 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_rea_Tx2);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_wrt_Tx3 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_wrt_Tx3);
					new_cmd_batch.sca_cmds_data(0).data :=  ecs_cmd_packet.data(31 downto 0);
					new_cmd_batch.sca_cmds_data(0).len := ecs_cmd_packet.len;	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MOSI_rea_Tx3 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MOSI_rea_Tx3);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MISO_rea_Rx0 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MISO_rea_Rx0);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MISO_rea_Rx1 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MISO_rea_Rx1);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MISO_rea_Rx2 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MISO_rea_Rx2);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_MISO_rea_Rx3 =>
					new_cmd_batch.sca_cmds(0) := spi_cmd_table(SPI_MISO_rea_Rx3);
					new_cmd_batch.sca_cmds_data(0).data := (others=>'0');
					new_cmd_batch.sca_cmds_data(0).len := (others=>'0');	
					new_cmd_batch.cmd_count := 1;
				when ECS_SPI_WRITE_TX_REG =>
					k:=0;
					while (4*k < to_integer(unsigned(ecs_cmd_packet.len)) and k<4)  loop
						case k is
							when 0 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MOSI_wrt_Tx0);
							when 1 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MOSI_wrt_Tx1);
							when 2 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MOSI_wrt_Tx2);
							when 3 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MOSI_wrt_Tx3);
							when others => null;
						end case;
						
						new_cmd_batch.sca_cmds_data(k).data :=ecs_cmd_packet.data(32*(k+1)-1 downto 32*k);
						new_cmd_batch.sca_cmds_data(k).len := x"04"; --lazy
						k:=k+1;
					end loop;
					new_cmd_batch.cmd_count := k;
				when ECS_SPI_READ_RX_REG =>
					k:=0;
					while (4*k < to_integer(unsigned(ecs_cmd_packet.len)) and k<4) loop
						case k is
							when 0 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MISO_rea_Rx0);
							when 1 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MISO_rea_Rx1);
							when 2 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MISO_rea_Rx2);
							when 3 => 
								new_cmd_batch.sca_cmds(k) := spi_cmd_table(SPI_MISO_rea_Rx3);
							when others => null;
						end case;
						
						new_cmd_batch.sca_cmds_data(k).data :=(others=>'0');
						new_cmd_batch.sca_cmds_data(k).len := x"00";
						k:=k+1;
					end loop;
					new_cmd_batch.cmd_count := k;
				when INVALID =>
					null;
			end case;
			
		end if;
		
		sca_cmd_batch_o <= new_cmd_batch;
	end process spi_protocol_builder;
	
	
	spi_protocol_decoder : process ( sca_rpy_batch_i, ecs_cmd_packet.len, prot_rpy_en_i) is
		variable new_ecs_rpy_packet		:	ecs_packet_t;
		variable ecs_spi_cmd			:	ecs_spi_cmd_enum;
		variable j						:	natural range 0 to 128;
		variable k						:	natural;
		
		
	begin	
		
		new_ecs_rpy_packet.gbt_nr := (others=>'0');
		new_ecs_rpy_packet.sca_nr  := (others=>'0');
		new_ecs_rpy_packet.sca_ch  := (others=>'0');
		new_ecs_rpy_packet.ecs_cmd := (others=>'0');
		new_ecs_rpy_packet.data := (others=>'0');
		new_ecs_rpy_packet.len := (others=>'0');
		new_ecs_rpy_packet.protocol_specific  := (others=>'0');
		new_ecs_rpy_packet.err := (others=>'0');
		
		ecs_spi_cmd := INVALID;
		
		if prot_rpy_en_i='1' then
		
			for i in ecs_spi_cmd_table_t'left to ecs_spi_cmd_table_t'right loop
				if sca_rpy_batch_i.ecs_cmd = ecs_spi_cmd_table(i) then
					ecs_spi_cmd := i;
					exit;
				end if;
			end loop;
			new_ecs_rpy_packet.ecs_cmd := ecs_spi_cmd_table(ecs_spi_cmd);
			
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
			
			new_ecs_rpy_packet.protocol_specific(15 downto 0) := (others=>'0');
			
			case ecs_spi_cmd is 
				when ECS_SPI_GO =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_W_CTRL =>
					null;
				when ECS_SPI_R_CTRL =>
					new_ecs_rpy_packet.data(31 downto 16) := sca_rpy_batch_i.sca_rpys_data(0).data(31 downto 16);
					new_ecs_rpy_packet.len :=  std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_W_SS =>
					null;
				when ECS_SPI_R_SS =>
					new_ecs_rpy_packet.data(31 downto 24) := sca_rpy_batch_i.sca_rpys_data(0).data(31 downto 24);
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_W_FREQ =>
					null;
				when ECS_SPI_R_FREQ =>
					new_ecs_rpy_packet.data(31 downto 16) := sca_rpy_batch_i.sca_rpys_data(0).data(31 downto 16);
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MOSI_wrt_Tx0 =>
					null;
				when ECS_SPI_MOSI_rea_Tx0 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MOSI_wrt_Tx1 =>
					null;
				when ECS_SPI_MOSI_rea_Tx1 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MOSI_wrt_Tx2 =>
					null;
				when ECS_SPI_MOSI_rea_Tx2 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MOSI_wrt_Tx3 =>
					null;
				when ECS_SPI_MOSI_rea_Tx3 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MISO_rea_Rx0 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MISO_rea_Rx1 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MISO_rea_Rx2 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_MISO_rea_Rx3 =>
					new_ecs_rpy_packet.data(31 downto 0) := sca_rpy_batch_i.sca_rpys_data(0).data;
					new_ecs_rpy_packet.len := std_logic_vector( to_unsigned(4,8));
				when ECS_SPI_WRITE_TX_REG =>
					null;
				when ECS_SPI_READ_RX_REG =>
					new_ecs_rpy_packet.data := sca_rpy_batch_i.sca_rpys_data(3).data & 
							sca_rpy_batch_i.sca_rpys_data(2).data &
							sca_rpy_batch_i.sca_rpys_data(1).data &
							sca_rpy_batch_i.sca_rpys_data(0).data;
					if to_integer(unsigned(ecs_cmd_packet.len))>=16 then
						k:=16;
					else
						k := to_integer(unsigned(ecs_cmd_packet.len));
					end if;						
					j:= new_ecs_rpy_packet.data'length - k*8;
					report "j";
					for k in 0 to  new_ecs_rpy_packet.data'high loop
						if k >=  new_ecs_rpy_packet.data'high-j then
						--new_ecs_rpy_packet.data(new_ecs_rpy_packet.data'high downto 
						--	new_ecs_rpy_packet.data'high-j) :=(others=>'0');
						new_ecs_rpy_packet.data(k) := '0';
						end if;
					end loop; 
				when INVALID =>
					null;
			end case;
			
		end if;
		
		ecs_rpy_packet <= new_ecs_rpy_packet;
		
	
	end process spi_protocol_decoder;
	
end architecture RTL;
