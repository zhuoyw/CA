library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_mux is
  port (
	pc_src		: in std_logic_vector(1 downto 0);
	i_pc_plus4	: in std_logic_vector(15 downto 0);
	i_pc_alu	: in std_logic_vector(15 downto 0);
	i_pc_ra		: in std_logic_vector(15 downto 0);
  	q_pc		: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- pc_mux

architecture arch of pc_mux is

begin

	process(pc_src)
	begin
		case(pc_src) is
			when "00" =>
				q_pc <= i_pc_plus4;
			when "01" =>
				q_pc <= i_pc_alu;
			when "10" => 
				q_pc <= i_pc_ra;
			when others =>
				q_pc <= i_pc_plus4;
		end case ;
	end process;
end architecture ; -- arch
