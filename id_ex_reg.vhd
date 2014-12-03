library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity id_ex_reg is
  port (
		i_clk 		: in std_logic;
		--data
		i_rx 			: in std_logic_vector(15 downto 0);
		i_ry 			: in std_logic_vector(15 downto 0);
		i_pc_res		: in std_logic_vector(15 downto 0);
		i_rx_addr 		: in std_logic_vector(3 downto 0);
		i_ry_addr 		: in std_logic_vector(3 downto 0);
		--control
		i_mem_data_src	: in std_logic;
		i_alu_src_a 	: in std_logic;
		i_alu_src_b 	: in std_logic;
		i_alu_opcode 	: in std_logic_vector(3 downto 0);
		i_mem_to_reg 	: in std_logic;
		i_read_mem 		: in std_logic;
		i_write_mem 	: in std_logic;
		i_write_reg 	: in std_logic;
		i_rd 			: in std_logic_vector(3 downto 0);
		i_immd 			: in std_logic_vector(15 downto 0);
		
		q_rx 			: out std_logic_vector(15 downto 0);
		q_ry 			: out std_logic_vector(15 downto 0);
		q_pc_res		: out std_logic_vector(15 downto 0);
		q_rx_addr 		: out std_logic_vector(3 downto 0);
		q_ry_addr 		: out std_logic_vector(3 downto 0);
		
		q_mem_data_src	: out std_logic;
		q_alu_src_a 	: out std_logic;
		q_alu_src_b 	: out std_logic;
		q_alu_opcode 	: out std_logic_vector(3 downto 0);
		q_mem_to_reg 	: out std_logic;
		q_read_mem 		: out std_logic;
		q_write_mem 	: out std_logic;
		q_write_reg 	: out std_logic;
		q_rd 			: out std_logic_vector(3 downto 0);
		q_immd 			: out std_logic_vector(15 downto 0)
	);
end id_ex_reg; -- id_ex_reg

architecture arch of id_ex_reg is
	--data
	signal reg_rx 			: std_logic_vector(15 downto 0) :=(others => '0');
	signal reg_ry 			: std_logic_vector(15 downto 0) :=(others => '0');
	signal reg_pc_res		: std_logic_vector(15 downto 0) :=(others => '0');
	signal reg_immd 		: std_logic_vector(15 downto 0) :=(others => '0');
	signal reg_rx_addr 		: std_logic_vector(3 downto 0) := (others => '0');
	signal reg_ry_addr 		: std_logic_vector(3 downto 0) := (others => '0');

	--control
	signal reg_mem_data_src	: std_logic:='0';
	signal reg_alu_src_a 	: std_logic:='0';
	signal reg_alu_src_b 	: std_logic:='0';
	signal reg_alu_opcode 	: std_logic_vector(3 downto 0):=(others => '0');
	signal reg_mem_to_reg 	: std_logic:='0';
	signal reg_read_mem 	: std_logic:='0';
	signal reg_write_mem 	: std_logic:='0';
	signal reg_write_reg 	: std_logic:='0';
	signal reg_rd 			: std_logic_vector(3 downto 0):=(others => '0');
	

begin

	process(i_clk)
	begin
		if (i_clk'event and i_clk = '1') then			
			--data
			reg_rx <= i_rx;
			reg_ry <= i_ry;
			reg_immd <= i_immd;
			reg_pc_res <= i_pc_res;
			reg_rx_addr <= i_rx_addr;
			reg_ry_addr <= i_ry_addr;
			--control id
			reg_mem_data_src <= i_mem_data_src;
			reg_alu_src_a <= i_alu_src_a;
			reg_alu_src_b <= i_alu_src_b;
			reg_alu_opcode <= i_alu_opcode;
			reg_mem_to_reg <= i_mem_to_reg;
			reg_read_mem <= i_read_mem;
			reg_write_mem <= i_write_mem;
			reg_write_reg <= i_write_reg;
			reg_rd <= i_rd;
		end if;
	end process;
	
	--data
	q_rx <= reg_rx;
	q_ry <= reg_ry;
	q_pc_res <= reg_pc_res;
	q_immd <= reg_immd;
	q_rx_addr <= reg_rx_addr;
	q_ry_addr <= reg_ry_addr;
	--control id
	q_mem_data_src <= reg_mem_data_src;
	q_alu_src_a <= reg_alu_src_a;
	q_alu_src_b <= reg_alu_src_b;
	q_alu_opcode <= reg_alu_opcode;
	q_mem_to_reg <= reg_mem_to_reg;
	q_read_mem <= reg_read_mem;
	q_write_mem <= reg_write_mem;
	q_write_reg <= reg_write_reg;
	q_rd <= reg_rd;

end arch;
