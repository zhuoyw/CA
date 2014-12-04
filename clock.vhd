library ieee;
use ieee.std_logic_1164.all;

entity clock is
  port (
	i_clk		: in std_logic;
	q_clk		: out std_logic
  ) ;
end entity ; -- clock

architecture bhv of clock is

	signal clk4 : std_logic := '0';
	signal counter : integer range 0 to 1 := 0; 

begin

	process(i_clk)
	begin
		if (i_clk'event and i_clk = '1') then
			if (counter = 1) then
				clk4 <= not clk4;
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;

	q_clk <= clk4;

end architecture ; -- bhv
