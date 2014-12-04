library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity hazard is
	port (
		i_id_rx_addr	: in std_logic_vector(3 downto 0);
		i_id_ry_addr	: in std_logic_vector(3 downto 0);
		i_ex_rd 		: in std_logic_vector(3 downto 0);
		i_ex_read_mem	: in std_logic;
		q_stall			: out std_logic
	) ;
end entity ; -- hazard

architecture arch of hazard is

begin
	process(i_ex_read_mem,
			i_id_rx_addr, i_id_ry_addr, i_ex_rd)
	begin
		if (i_ex_read_mem = '1' and (i_ex_rd = i_id_rx_addr or i_ex_rd = i_id_ry_addr)) --lw 
				--or (i_branch /= "00" and (i_ex_rd = i_id_rx_addr or i_ex_rd = "1000")) 
				then
			q_stall <= '1';
		else
			q_stall <= '0';
		end if;
	end process;
end architecture ; -- arch