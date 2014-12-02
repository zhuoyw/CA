library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity if_id_reg is
  port (
		i_clk 		: in std_logic; 
		i_inst 		: in std_logic_vector(15 downto 0);
		i_pc_res 	: in std_logic_vector(15 downto 0);

		q_inst 		: out std_logic_vector(15 downto 0);
		q_pc_res 	: out std_logic_vector(15 downto 0)
	);
end if_id_reg; -- if_id_reg

architecture arch of if_id_reg is
	signal reg_inst	: std_logic_vector(15 downto 0):=(others => '0');
	signal reg_pc_res	: std_logic_vector(15 downto 0):=(others => '0');

begin

	process(i_clk)
	begin
		if (i_clk'event and i_clk = '1') then			
			reg_inst <= i_inst;
			reg_pc_res <= i_pc_res;
		end if;
	end process;
	
	q_inst <= reg_inst;
	q_pc_res <= reg_pc_res;
end arch;
