library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controller is
  port (
	inst			: in std_logic_vector(15 downto 0);
	branch			: out std_logic_vector(2 downto 0);
	--mem_data_sexrc: '0'->rx; '1'->ry
	mem_data_src	: out std_logic;
	--alu_src_a     : '0'->pc_res;	'1'->rx
	alu_src_a		: out std_logic;
	--alu_src_b     : '0'->immd;	'1'->ry
	alu_src_b		: out std_logic;
	--alu_opcode	: "0000"->add;	"0001"->sub;	"0010"->and;	"0011"->or;	"0100"->eqz;	"0101"->neqz;					  "0110"->lte;	"0111"->equ;	"1000"->sll;					  "1001"->sra	
	alu_opcode		: out std_logic_vector(3 downto 0);
	mem_to_reg		: out std_logic;
	read_mem		: out std_logic;
	write_mem		: out std_logic;
	write_reg		: out std_logic;
	--addr/rd 		: "0000"~"0111"->r0~r7;	"1000"->t;	"1001"->ra; "1010"->sp;	"1011"->ih; "1111"->zero			
	rx_addr			: out std_logic_vector(3 downto 0);
	ry_addr			: out std_logic_vector(3 downto 0);
	rd          	: out std_logic_vector(3 downto 0);
	immd			: out std_logic_vector(15 downto 0)
  ) ;
end controller ; -- controller

architecture arch of controller is
	
	constant mem_data_rx    : std_logic := '0';
	constant mem_data_ry    : std_logic := '1';
	
	constant alu_a_pc	    : std_logic := '0';
	constant alu_a_rx	    : std_logic := '1';
	
	constant alu_b_immd	    : std_logic := '0';
	constant alu_b_ry	    : std_logic := '1';
    
    constant addr_t	        : std_logic_vector(3 downto 0) := "1000";
    constant addr_ra	    : std_logic_vector(3 downto 0) := "1001";
    constant addr_sp	    : std_logic_vector(3 downto 0) := "1010";
    constant addr_ih	    : std_logic_vector(3 downto 0) := "1011";
    constant addr_zero      : std_logic_vector(3 downto 0) := "1111";
    constant addr_null      : std_logic_vector(3 downto 0) := "1111";
    

	constant op_add	        : std_logic_vector(3 downto 0) := "0000";
    constant op_sub	        : std_logic_vector(3 downto 0) := "0001";
    constant op_and	        : std_logic_vector(3 downto 0) := "0010";
    constant op_or          : std_logic_vector(3 downto 0) := "0011";
    constant op_eqz         : std_logic_vector(3 downto 0) := "0100";
    constant op_neqz        : std_logic_vector(3 downto 0) := "0101";
    constant op_lte	        : std_logic_vector(3 downto 0) := "0110";
    constant op_equ	        : std_logic_vector(3 downto 0) := "0111";
    constant op_sll	        : std_logic_vector(3 downto 0) := "1000";
    constant op_sra	        : std_logic_vector(3 downto 0) := "1001";
	
    

begin
	
	

	--combinational logic
	--no clk
	process(inst)
		variable addr_rx 		: std_logic_vector(3 downto 0) := "0000";
		variable addr_ry 		: std_logic_vector(3 downto 0) := "0000";
		variable addr_rz 		: std_logic_vector(3 downto 0) := "0000";
	begin
		addr_rx(2 downto 0) := inst(10 downto 8);
		addr_ry(2 downto 0) := inst(7 downto 5);
		addr_rz(2 downto 0) := inst(4 downto 2);
		addr_rx(3) := '0';
		addr_ry(3) := '0';
		addr_rz(3) := '0';

		case inst(15 downto 11) is
			when "01001"=> --addiu
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_add;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_rx;
				ry_addr			<= addr_null;
				rd				<= addr_rx;
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
				
			when "01000"=> --addiu3
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_add;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_rx;
				ry_addr			<= addr_null;
				rd				<= addr_ry;
				immd(15 downto 4) <= (others=>inst(3));
				immd(3 downto 0) <= inst(3 downto 0);

			when "01100"=> 
				case inst(10 downto 8) is 
					when "011"=> --addsp
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_immd;
						alu_opcode		<= op_add;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_sp;
						ry_addr			<= addr_null;
						rd				<= addr_sp;
						immd(15 downto 8) <= (others=>inst(7));
						immd(7 downto 0) <= inst(7 downto 0);

					when "000"=> --bteqz
						branch			<= "100";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= "0000";
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '0';
						rx_addr			<= addr_null;
						ry_addr			<= addr_null;
						rd				<= addr_null;
						immd 			<= (others=>'0');

					when "100"=> --mtsp
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_add;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_ry;
						ry_addr			<= addr_null;
						rd				<= addr_sp;
						immd 			<= (others=>'0');
						
					when others=>
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= "0000";
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '0';
						rx_addr			<= addr_null;
						ry_addr			<= addr_null;
						rd				<= addr_null;
						immd 			<= (others=>'0');

				end case;
			
			when "11100"=>
				case inst(1) is
					when '0'=> --addu
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_add;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_rx;
						ry_addr			<= addr_ry;
						rd				<= addr_rz;
						immd 			<= (others=>'0');

					when '1'=> --subu
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_sub;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_rx;
						ry_addr			<= addr_ry;
						rd				<= addr_rz;
						immd 			<= (others=>'0');

					when others=>
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= "0000";
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '0';
						rx_addr			<= addr_null;
						ry_addr			<= addr_null;
						rd				<= addr_null;
						immd 			<= (others=>'0');

				end case;
			when "11101"=>
				case inst(4 downto 0) is
					when "01100"=> --and
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_and;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_rx;
						ry_addr			<= addr_ry;
						rd				<= addr_rx;
						immd 			<= (others=>'0');

					when "01010"=> --cmp
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_equ;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_rx;
						ry_addr			<= addr_ry;
						rd				<= addr_t;
						immd 			<= (others=>'0');

					when "01101"=> --or
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_or;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_rx;
						ry_addr			<= addr_ry;
						rd				<= addr_rx;
						immd 			<= (others=>'0');

					when "00000"=> 
						case inst(7 downto 5) is
							when "110"=> --jalr
								branch			<= "101";
								mem_data_src	<= '0';
								alu_src_a		<= alu_a_pc;
								alu_src_b		<= alu_b_immd;
								alu_opcode		<= op_add;
								mem_to_reg		<= '0';
								read_mem		<= '0';
								write_mem		<= '0';
								write_reg		<= '1';
								rx_addr			<= addr_null;
								ry_addr			<= addr_null;
								rd				<= addr_ra;
								immd 			<= "0000000000000010";

							when "001"=> --jrra
								branch			<= "110";
								mem_data_src	<= '0';
								alu_src_a		<= alu_a_rx;
								alu_src_b		<= alu_b_ry;
								alu_opcode		<= "0000";
								mem_to_reg		<= '0';
								read_mem		<= '0';
								write_mem		<= '0';
								write_reg		<= '0';
								rx_addr			<= addr_null;
								ry_addr			<= addr_null;
								rd				<= addr_null;
								immd 			<= (others=>'0');

							when "000"=> --jr
								branch			<= "101";
								mem_data_src	<= '0';
								alu_src_a		<= alu_a_rx;
								alu_src_b		<= alu_b_ry;
								alu_opcode		<= "0000";
								mem_to_reg		<= '0';
								read_mem		<= '0';
								write_mem		<= '0';
								write_reg		<= '0';
								rx_addr			<= addr_null;
								ry_addr			<= addr_null;
								rd				<= addr_null;
								immd 			<= (others=>'0');

							when "010"=> --mfpc
								branch			<= "000";
								mem_data_src	<= '0';
								alu_src_a		<= alu_a_pc;
								alu_src_b		<= alu_b_immd;
								alu_opcode		<= op_add;
								mem_to_reg		<= '0';
								read_mem		<= '0';
								write_mem		<= '0';
								write_reg		<= '1';
								rx_addr			<= addr_null;
								ry_addr			<= addr_null;
								rd				<= addr_rx;
								--???是否为pc+1
								immd 			<= (0=>'1', others=>'0');
								
							when others=>
								branch			<= "000";
								mem_data_src	<= '0';
								alu_src_a		<= alu_a_rx;
								alu_src_b		<= alu_b_ry;
								alu_opcode		<= "0000";
								mem_to_reg		<= '0';
								read_mem		<= '0';
								write_mem		<= '0';
								write_reg		<= '0';
								rx_addr			<= addr_null;
								ry_addr			<= addr_null;
								rd				<= addr_null;
								immd 			<= (others=>'0');

						end case;
					when others=>
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= "0000";
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '0';
						rx_addr			<= addr_null;
						ry_addr			<= addr_null;
						rd				<= addr_null;
						immd 			<= (others=>'0');

				end case;
			when "00010"=> --b
				branch			<= "001";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_ry;
				alu_opcode		<= "0000";
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '0';
				rx_addr			<= addr_null;
				ry_addr			<= addr_null;
				rd				<= addr_null;
				immd(15 downto 11) <= (others=>inst(10));
				immd(10 downto 0) <= inst(10 downto 0);

			when "00100"=> --beqz
				branch			<= "010";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_ry;
				alu_opcode		<= "0000";
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '0';
				rx_addr			<= addr_null;
				ry_addr			<= addr_null;
				rd				<= addr_null;
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);

			when "00101"=> --bnez
				branch			<= "011";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_ry;
				alu_opcode		<= "0000";
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '0';
				rx_addr			<= addr_null;
				ry_addr			<= addr_null;
				rd				<= addr_null;
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			
			when "01101"=> --li
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_add;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_zero;
				ry_addr			<= addr_null;
				rd				<= addr_rx;
				immd(15 downto 8) <= (others=>'0');
				immd(7 downto 0) <= inst(7 downto 0);

			when "01110"=> --cmpi
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_equ;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_rx;
				ry_addr			<= addr_null;
				rd				<= addr_t;
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);

			when "01111"=> --move
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_ry;
				alu_opcode		<= op_add;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_zero;
				ry_addr			<= addr_ry;
				rd				<= addr_rx;
				immd 			<= (others=>'0');

			when "10011"=> --lw
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_add;
				mem_to_reg		<= '1';
				read_mem		<= '1';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_rx;
				ry_addr			<= addr_null;
				rd				<= addr_rx;
				immd(15 downto 5) <= (others=>inst(4));
				immd(4 downto 0) <= inst(4 downto 0);

			when "10010"=> --lw_sp
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_add;
				mem_to_reg		<= '1';
				read_mem		<= '1';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_sp;
				ry_addr			<= addr_null;
				rd				<= addr_rx;
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);

			when "11110"=>
				case inst(0) is
					when '0'=> --mfih
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_add;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_ih;
						ry_addr			<= addr_null;
						rd				<= addr_rx;
						immd 			<= (others=>'0');
					when '1'=> --mtih
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= op_add;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_rx;
						ry_addr			<= addr_null;
						rd				<= addr_ih;
						immd 			<= (others=>'0');

					when others=>
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= "0000";
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '0';
						rx_addr			<= addr_null;
						ry_addr			<= addr_null;
						rd				<= addr_null;
						immd 			<= (others=>'0');
				end case;
			
			when "00001"=> --nop
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_ry;
				alu_opcode		<= "0000";
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '0';
				rx_addr			<= addr_null;
				ry_addr			<= addr_null;
				rd				<= addr_null;
				immd 			<= (others=>'0');

			when "01010"=> --slti
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_lte;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '1';
				rx_addr			<= addr_rx;
				ry_addr			<= addr_null;
				rd				<= addr_t;
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);

			when "00110"=>
				case inst(0) is 
					when '0'=> --sll
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_immd;
						alu_opcode		<= op_sll;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_ry;
						ry_addr			<= addr_null;
						rd				<= addr_rx;
						if(inst(4 downto 2) = "000") then
							immd <= "0000000000001000";
						else
							immd(15 downto 3) <= (others=>'0');
							immd(2 downto 0) <= inst(4 downto 2);
						end if;
						
					when '1'=> --sra
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_immd;
						alu_opcode		<= op_sra;
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '1';
						rx_addr			<= addr_ry;
						ry_addr			<= addr_null;
						rd				<= addr_rx;
						if(inst(4 downto 2) = "000") then
							immd <= "0000000000001000";
						else
							immd(15 downto 3) <= (others=>'0');
							immd(2 downto 0) <= inst(4 downto 2);
						end if;

					when others=>
						branch			<= "000";
						mem_data_src	<= '0';
						alu_src_a		<= alu_a_rx;
						alu_src_b		<= alu_b_ry;
						alu_opcode		<= "0000";
						mem_to_reg		<= '0';
						read_mem		<= '0';
						write_mem		<= '0';
						write_reg		<= '0';
						rx_addr			<= addr_null;
						ry_addr			<= addr_null;
						rd				<= addr_null;
						immd 			<= (others=>'0');

				end case;
			when "11011"=> --sw
				branch			<= "000";
				mem_data_src	<= mem_data_ry;
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_add;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '1';
				write_reg		<= '0';
				rx_addr			<= addr_rx;
				ry_addr			<= addr_ry;
				rd				<= addr_null;
				immd(15 downto 5) <= (others=>inst(4));
				immd(4 downto 0) <= inst(4 downto 0);

			when "11010"=> --sw_sp
				branch			<= "000";
				mem_data_src	<= mem_data_ry;
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_immd;
				alu_opcode		<= op_add;
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '1';
				write_reg		<= '0';
				rx_addr			<= addr_sp;
				ry_addr			<= addr_rx;
				rd				<= addr_null;
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when others =>
				branch			<= "000";
				mem_data_src	<= '0';
				alu_src_a		<= alu_a_rx;
				alu_src_b		<= alu_b_ry;
				alu_opcode		<= "0000";
				mem_to_reg		<= '0';
				read_mem		<= '0';
				write_mem		<= '0';
				write_reg		<= '0';
				rx_addr			<= addr_null;
				ry_addr			<= addr_null;
				rd				<= addr_null;
				immd 			<= (others=>'0');
				
		end case;
	end process;
end arch ; -- arch