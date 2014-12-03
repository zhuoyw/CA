library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity forward is
	port (
		i_ex_rx_addr 		: in std_logic_vector(3 downto 0);
		i_ex_ry_addr		: in std_logic_vector(3 downto 0);
		i_me_rd				: in std_logic_vector(3 downto 0);
		i_wb_rd 			: in std_logic_vector(3 downto 0);
		i_me_write_reg		: in std_logic;
		i_wb_write_reg		: in std_logic;
		q_forward_a			: out std_logic_vector(1 downto 0);
		q_forward_b			: out std_logic_vector(1 downto 0)
	) ;
end entity ; -- forward

architecture arch of forward is

begin
	process(i_me_write_reg, i_wb_write_reg, 
			i_me_rd, i_wb_rd, i_ex_rx_addr, i_ex_ry_addr)
	begin
		q_forward_a <= "00";
		q_forward_b <= "00";
		if (i_me_write_reg = '1') then
			if (i_me_rd = i_ex_rx_addr) then 
				q_forward_a <= "01";
			end if;
			if (i_me_rd = i_ex_ry_addr) then 
				q_forward_b <= "01";
			end if;
		elsif (i_wb_write_reg = '1') then
			if (i_wb_rd = i_ex_rx_addr) then 
				q_forward_a <= "01";
			end if;
			if (i_wb_rd = i_ex_ry_addr) then 
				q_forward_b <= "01";
			end if;
		end if;
	end process;
end architecture ; -- arch
