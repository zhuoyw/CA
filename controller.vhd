library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controller is
  port (
	inst			: in std_logic_vector(15 downto 0);
	branch		: out std_logic;
	jump			: out std_logic;
	alu_src		: out std_logic;
	alu_opcode	: out std_logic_vector(2 downto 0);
	mem_to_reg	: out std_logic;
	read_mem		: out std_logic;
	write_mem	: out std_logic;
	write_reg	: out std_logic;
	rd          : out std_logic_vector(2 downto 0);
	immd			: out std_logic_vector(15 downto 0)
  ) ;
end controller ; -- controller

architecture arch of controller is



begin
	--combinational logic
	--no clk
	process(inst)

	begin
		case inst(15 downto 11) is
			when "01001"=> --addiu
				branch <= '0';
				jump <= '0';
				alu_src <= '1';
				--alu_opcode <= "add";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '1';
				rd <= inst(10 downto 8);
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when "01000"=> --addiu3
				branch <= '0';
				jump <= '0';
				alu_src <= '1';
				--alu_opcode <= "add";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '1';
				rd <= inst(7 downto 5);
				immd(15 downto 4) <= (others=>inst(3));
				immd(3 downto 0) <= inst(3 downto 0);
			when "01100"=> 
				case inst(10 downto 8) is 
					when "011"=> --addsp
						branch <= '0';
						jump <= '0';
						alu_src <= '1';
						--alu_opcode <= "add";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						--rd <= "sp";
						immd(15 downto 8) <= (others=>inst(7));
						immd(7 downto 0) <= inst(7 downto 0);
					when "000"=> --bteqz
						branch <= '1';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '0';
						--rd <= inst(10 downto 8);
						immd(15 downto 8) <= (others=>inst(7));
						immd(7 downto 0) <= inst(7 downto 0);
					when "100"=> --???mtsp
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						--rd <= "???";
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
					when others=>
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '0';
						rd <= "000";
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
				end case;
			when "11100"=>
				case inst(1) is
					when '0'=> --addu
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "add";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						rd <= inst(4 downto 2);
						immd(15 downto 3) <= (others=>'0');
						immd(2 downto 0) <= inst(4 downto 2);
					when '1'=> --subu
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "sub";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						rd <= inst(4 downto 2);
						immd(15 downto 3) <= (others=>'0');
						immd(2 downto 0) <= inst(4 downto 2);
					when others=>
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '0';
						rd <= "000";
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
				end case;
			when "11101"=>
				case inst(4 downto 0) is
					when "01100"=> --and
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "and";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						rd <= inst(10 downto 8);
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
					when "01010"=> --cmp???
						branch <= '1';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '0';
						--rd <= inst(10 downto 8);
						immd(15 downto 8) <= (others=>inst(7));
						immd(7 downto 0) <= inst(7 downto 0);
					when "01101"=> --or
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "or";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						rd <= inst(10 downto 8);
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
					when "00000"=> 
						case inst(7 downto 5) is
							when "110"=> --???jalr
								branch <= '0';
								jump <= '1';
								alu_src <= '0';
								--alu_opcode <= "???";
								mem_to_reg <= '0';
								read_mem <= '0';
								write_mem <= '0';
								write_reg <= '1';
								--rd <= "???";
								immd(15 downto 8) <= (others=>inst(7));
								immd(7 downto 0) <= inst(7 downto 0);
							when "001"=> --???jrra
								branch <= '0';
								jump <= '1';
								alu_src <= '0';
								--alu_opcode <= "???";
								mem_to_reg <= '0';
								read_mem <= '0';
								write_mem <= '0';
								write_reg <= '1';
								--rd <= "???";
								immd(15 downto 8) <= (others=>inst(7));
								immd(7 downto 0) <= inst(7 downto 0);
							when "000"=> --jr
								branch <= '0';
								jump <= '1';
								alu_src <= '0';
								--alu_opcode <= "???";
								mem_to_reg <= '0';
								read_mem <= '0';
								write_mem <= '0';
								write_reg <= '0';
								--rd <= inst(10 downto 8);
								immd(15 downto 8) <= (others=>inst(7));
								immd(7 downto 0) <= inst(7 downto 0);
							when "010"=> --???mfpc
								branch <= '0';
								jump <= '0';
								alu_src <= '0';
								--alu_opcode <= "???";
								mem_to_reg <= '0';
								read_mem <= '0';
								write_mem <= '0';
								write_reg <= '1';
								rd <= inst(10 downto 8);
								immd(15 downto 5) <= (others=>inst(4));
								immd(4 downto 0) <= inst(4 downto 0);
							when others=>
								branch <= '0';
								jump <= '0';
								alu_src <= '0';
								--alu_opcode <= "???";
								mem_to_reg <= '0';
								read_mem <= '0';
								write_mem <= '0';
								write_reg <= '0';
								rd <= "000";
								immd(15 downto 5) <= (others=>inst(4));
								immd(4 downto 0) <= inst(4 downto 0);
						end case;
					when others=>
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '0';
						rd <= "000";
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
				end case;
			when "00010"=> --b
				branch <= '1';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "XXX";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '0';
				rd <= "XXX";
				immd(15 downto 11) <= (others=>inst(10));
				immd(10 downto 0) <= inst(10 downto 0);
			when "00100"=> --beqz
				branch <= '1';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "???";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '0';
				--rd <= inst(10 downto 8);
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when "00101"=> --bnez
				branch <= '1';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "???";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '0';
				--rd <= inst(10 downto 8);
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			
			when "01101"=> --li
				branch <= '0';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "???";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '1';
				rd <= inst(10 downto 8);
				immd(15 downto 8) <= (others=>'0');
				immd(7 downto 0) <= inst(7 downto 0);
			when "01110"=> --???cmpi
				branch <= '0';
				jump <= '0';
				alu_src <= '1';
				--alu_opcode <= "sub";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '1';
				--rd <= "???";
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when "01111"=> --???move
				branch <= '0';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "???";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '1';
				rd <= inst(10 downto 8);
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when "10011"=> --lw
				branch <= '0';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "add";
				mem_to_reg <= '1';
				read_mem <= '1';
				write_mem <= '0';
				write_reg <= '1';
				rd <= inst(7 downto 5);
				immd(15 downto 5) <= (others=>inst(4));
				immd(4 downto 0) <= inst(4 downto 0);
			when "10010"=> --???lw_sp
				branch <= '0';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "add";
				mem_to_reg <= '1';
				read_mem <= '1';
				write_mem <= '0';
				write_reg <= '1';
				rd <= inst(10 downto 8);
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when "11110"=>
				case inst(0) is
					when '0'=> --???mfih
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						rd <= inst(10 downto 8);
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
					when '1'=> --???mtih
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						--rd <= "???";
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
					when others=>
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '0';
						rd <= "000";
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
				end case;
			
			when "00001"=> --???nop
				branch <= '0';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "???";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '0';
				rd <= inst(10 downto 8);
				immd(15 downto 5) <= (others=>inst(4));
				immd(4 downto 0) <= inst(4 downto 0);
			when "01010"=> --???slti
				branch <= '0';
				jump <= '0';
				alu_src <= '1';
				--alu_opcode <= "???";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '1';
				--rd <= "???";
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when "00110"=>
				case inst(0) is 
					when '0'=> --???sll
						branch <= '0';
						jump <= '0';
						alu_src <= '1';
						--alu_opcode <= "sll";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						rd <= inst(10 downto 8);
						immd(15 downto 3) <= (others=>'0');
						immd(2 downto 0) <= inst(4 downto 2);
					when '1'=> --???sra
						branch <= '0';
						jump <= '0';
						alu_src <= '1';
						--alu_opcode <= "sra";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '1';
						rd <= inst(10 downto 8);
						immd(15 downto 3) <= (others=>'0');
						immd(2 downto 0) <= inst(4 downto 2);
					when others=>
						branch <= '0';
						jump <= '0';
						alu_src <= '0';
						--alu_opcode <= "???";
						mem_to_reg <= '0';
						read_mem <= '0';
						write_mem <= '0';
						write_reg <= '0';
						rd <= "000";
						immd(15 downto 5) <= (others=>inst(4));
						immd(4 downto 0) <= inst(4 downto 0);
				end case;
			when "11011"=> --sw
				branch <= '0';
				jump <= '0';
				alu_src <= '1';
				--alu_opcode <= "add";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '1';
				write_reg <= '0';
				rd <= inst(10 downto 8);
				immd(15 downto 5) <= (others=>inst(4));
				immd(4 downto 0) <= inst(4 downto 0);
			when "11010"=> --???sw_sp
				branch <= '0';
				jump <= '0';
				alu_src <= '1';
				--alu_opcode <= "add";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '1';
				write_reg <= '0';
				rd <= inst(10 downto 8);
				immd(15 downto 8) <= (others=>inst(7));
				immd(7 downto 0) <= inst(7 downto 0);
			when others =>
				branch <= '0';
				jump <= '0';
				alu_src <= '0';
				--alu_opcode <= "???";
				mem_to_reg <= '0';
				read_mem <= '0';
				write_mem <= '0';
				write_reg <= '0';
				rd <= "000";
				immd(15 downto 5) <= (others=>inst(4));
				immd(4 downto 0) <= inst(4 downto 0);
		end case;
	end process;
end arch ; -- arch