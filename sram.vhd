library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mem_controller is
	port (
		--from/to upper
		clk				: in std_logic;
		i_addr			: in std_logic_vector(15 downto 0);
		i_data 			: in std_logic_vector(15 downto 0);
		q_data 			: out std_logic_vector(15 downto 0);
		write_mem 		: in std_logic;
		read_mem 		: in std_logic;
		--from/to mem
		mem_data 		: inout std_logic_vector(15 downto 0);
		mem_addr 		: out std_logic_vector(15 downto 0);
		mem_oe 			: out std_logic;
		mem_we 			: out std_logic;
		mem_en 			: out std_logic
    );
	
end mem_controller;

architecture bhv of mem_controller is
	
	type state_tpye is (s0, r1, r2, r3, w1, w2, w3);
	signal reg_state : state_tpye := s0;

begin
	process (clk)                 
	begin
		if (clk'event and clk = '1') then
			case(reg_state) is
				when s0 =>
					if (mem_write = '1' and mem_read = '0') then
						reg_state <= w1;
						mem_en <= '0';
						mem_oe <= '1';
						mem_we <= '1';
						mem_addr <= i_addr;
						mem_data <= i_data;
					elsif  (mem_write = '0' and mem_read = '1') then
						reg_state <= r1;
						mem_en <= '0';
						mem_oe <= '1';
						mem_we <= '1';
						mem_addr <= i_addr;
						mem_data <= (others => 'Z');
					elsif
						reg_state <= s0;
						mem_en <= '1';
						mem_oe <= '1';
						mem_we <= '1';
					end if;				
				when w1 =>
					reg_state <= w2;
					mem_we <= '0';
				when w2 => 
					reg_state <= s0;
					mem_en <= '1';
					mem_we <= '1';
				when r1 =>
					reg_state <= r2;
					mem_oe <= '0';
				when r2 =>
					reg_state <= s0;
					mem_oe <= '1';
					mem_we <= '1';
					q_data <= mem_data;
				when others =>
					reg_state <= s0;
			end case;
		end if;
	end process;     
end bhv;