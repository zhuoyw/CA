library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ex_me_reg is
  port (
		i_clk 		: in std_logic;
		--data
		i_alu_res		: in std_logic_vector(15 downto 0);
		i_mem_data		: in std_logic_vector(15 downto 0);
		
		--control
		i_mem_to_reg 	: in std_logic;
		i_read_mem 		: in std_logic;
		i_write_mem 	: in std_logic;
		i_write_reg 	: in std_logic;
		i_write_ext 	: in std_logic;
		i_rd 			: in std_logic_vector(2 downto 0);
		
		--data
		q_alu_res		: out std_logic_vector(15 downto 0);
		q_mem_data		: out std_logic_vector(15 downto 0);
		
		--control
		q_mem_to_reg 	: out std_logic;
		q_read_mem 		: out std_logic;
		q_write_mem 	: out std_logic;
		q_write_reg 	: out std_logic;
		q_write_ext 	: out std_logic;
		q_rd 			: out std_logic_vector(2 downto 0)

	);
end ex_me_reg; -- ex_me_reg

architecture arch of ex_me_reg is
	--data
	signal reg_alu_res		: std_logic_vector(15 downto 0);
	signal reg_mem_data		: std_logic_vector(15 downto 0);
	
	--control
	signal reg_mem_to_reg 	: std_logic;
	signal reg_read_mem 	: std_logic;
	signal reg_write_mem 	: std_logic;
	signal reg_write_reg 	: std_logic;
	signal reg_write_ext 	: std_logic;
	signal reg_rd 			: std_logic_vector(2 downto 0);

begin

	process(i_clk)
	begin
		if (i_clk'event and i_clk = '1') then			
			--data
			reg_alu_res <= i_alu_res;
			reg_mem_data <= i_mem_data;
			--control
			reg_mem_to_reg <= i_mem_to_reg;
			reg_read_mem <= i_read_mem;
			reg_write_mem <= i_write_mem;
			reg_write_reg <= i_write_reg;
			reg_write_ext <= i_write_ext;
			reg_rd <= i_rd;
		end if;
	end process;
	
	--data
	q_alu_res <= reg_alu_res;
	q_mem_data <= reg_mem_data;
	--control
	q_mem_to_reg <= reg_mem_to_reg;
	q_read_mem <= reg_read_mem;
	q_write_mem <= reg_write_mem;
	q_write_reg <= reg_write_reg;
	q_write_ext <= reg_write_ext;
	q_rd <= reg_rd;
end arch;
