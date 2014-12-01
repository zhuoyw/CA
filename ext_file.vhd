library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity ext_file is
  	port (
		i_clk		: in std_logic;
		write_ext	: in std_logic;
		i_addr		: in std_logic_vector(2 downto 0);
		i_data		: in std_logic_vector(15 downto 0);		
		q_t 		: out std_logic_vector(15 downto 0);
		q_ra 		: out std_logic_vector(15 downto 0);
		q_sp		: out std_logic_vector(15 downto 0);
		q_ih		: out std_logic_vector(15 downto 0)
	);
end entity ; -- ext_file

architecture arch of ext_file is

	signal reg_t 	: std_logic_vector(15 downto 0) := (others=>'0');
	signal reg_ra 	: std_logic_vector(15 downto 0) := (others=>'0');
	signal reg_sp	: std_logic_vector(15 downto 0) := (others=>'0');
	signal reg_ih	: std_logic_vector(15 downto 0) := (others=>'0');

begin

	process(i_clk)
	begin
		if (i_clk = '1' and i_clk'event) then
			if (write_ext = '1') then
				case(i_addr) is
					when "000" =>
						reg_t <= i_data;
					when "001" =>
						reg_ra <= i_data;
					when "010" =>
						reg_sp <= i_data;
					when "011" =>
						reg_ih <= i_data;
					when others =>
						reg_t <= (others=>'1');
						--raise error
				end case ;
			end if;
		end if;
	end process ; -- 

	q_t <= reg_t;
	q_ra <= reg_ra;
	q_sp <= reg_sp;
	q_ih <= reg_ih;

end architecture ; -- arch
