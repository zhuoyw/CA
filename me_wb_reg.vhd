library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity me_wb_reg is
  port (
		i_clk 			: in std_logic;
		--data
		i_alu_res		: in std_logic_vector(15 downto 0);
		i_mem_res		: in std_logic_vector(15 downto 0);
		
		--control
		i_mem_to_reg 	: in std_logic;
		i_write_reg 	: in std_logic;
		i_rd 			: in std_logic_vector(3 downto 0);
		
		--data
		q_alu_res		: out std_logic_vector(15 downto 0);
		q_mem_res		: out std_logic_vector(15 downto 0);
		
		--control
		q_mem_to_reg 	: out std_logic;
		q_write_reg 	: out std_logic;
		q_rd 			: out std_logic_vector(3 downto 0)

	);
end me_wb_reg; -- me_wb_reg

architecture arch of me_wb_reg is
	--data
	signal reg_alu_res		: std_logic_vector(15 downto 0):=(others => '0');
	signal reg_mem_res		: std_logic_vector(15 downto 0):=(others => '0');
	
	--control
	signal reg_mem_to_reg 	: std_logic:='0';
	signal reg_write_reg 	: std_logic:='0';
	signal reg_rd 			: std_logic_vector(3 downto 0):=(others => '0');

begin

	process(i_clk)
	begin
		if (i_clk'event and i_clk = '1') then			
			--data
			reg_alu_res <= i_alu_res;
			reg_mem_res <= i_mem_res;
			--control
			reg_mem_to_reg <= i_mem_to_reg;
			reg_write_reg <= i_write_reg;
			reg_rd <= i_rd;
		end if;
	end process;
	
	--data
	q_alu_res <= reg_alu_res;
	q_mem_res <= reg_mem_res;
	--control
	q_mem_to_reg <= reg_mem_to_reg;
	q_write_reg <= reg_write_reg;
	q_rd <= reg_rd;
	
end arch;
