library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc is
	port (
		i_clk		: in std_logic;
		i_rst		: in std_logic;
		i_stall 	: in std_logic;
		i_pc		: in std_logic_vector(15 downto 0);
		q_pc		: out std_logic_vector(15 downto 0)
	);
end entity ; -- pc

architecture arch of pc is

	signal reg_pc : std_logic_vector(15 downto 0) := (others => '0');

begin

	process(i_rst, i_clk)
	begin
		if (i_rst = '1') then
			reg_pc <= (others => '0');
		elsif (i_clk = '1' and i_clk'event) then
			if (i_stall = '0') then
				reg_pc <= i_pc;
			end if; -- do nothing to hold on
		end if;
	end process;

	q_pc <= reg_pc; 

end architecture ; -- arch
