library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity id_forward is
	port (
		i_me_rd  			: in std_logic_vector(3 downto 0);
		i_id_rx_addr 		: in std_logic_vector(3 downto 0);
		q_forward_t			: out std_logic;
		q_forward_ra			: out std_logic;
		q_forward_x			: out std_logic
		
	) ;
end entity ; -- id_forward

architecture arch of id_forward is

begin
	process(i_me_rd, i_id_rx_addr)
	begin
		q_forward_t	<= '0';
		q_forward_x	<= '0';
		q_forward_ra	<= '0';
		if (i_me_rd = "1000") then
			q_forward_t <= '1';
		elsif (i_me_rd = "1001") then
			q_forward_ra <= '1';
		elsif (i_me_rd = i_id_rx_addr) then
			q_forward_x <= '1';
		end if;
	end process;
end architecture ; -- arch
