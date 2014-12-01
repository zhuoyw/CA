library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity sram_controller is
	port (
		--from/to upper
		i_clk			: in std_logic;
		i_addr			: in std_logic_vector(15 downto 0);
		i_data 			: in std_logic_vector(15 downto 0);
		q_data 			: out std_logic_vector(15 downto 0);
		write_mem 		: in std_logic;
		read_mem 		: in std_logic;
		--from/to mem
		sram_data 		: inout std_logic_vector(15 downto 0);
		sram_addr 		: out std_logic_vector(15 downto 0);
		sram_oe 			: out std_logic;
		sram_we 			: out std_logic;
		sram_en 			: out std_logic
    );
	
end sram_controller;

architecture bhv of sram_controller is
	
	type state_tpye is (s0, r1, r2, r3, w1, w2, w3);
	signal reg_state : state_tpye := s0;

begin
	process (i_clk)                 
	begin
		if (i_clk'event and i_clk = '1') then
			case(reg_state) is
				when s0 =>
					if write_mem = '1' and read_mem = '0' then
						reg_state <= w1;
						sram_en <= '0';
						sram_oe <= '1';
						sram_we <= '1';
						sram_addr <= i_addr;
						sram_data <= i_data;
					elsif  (write_mem = '0' and read_mem = '1') then
						reg_state <= r1;
						sram_en <= '0';
						sram_oe <= '1';
						sram_we <= '1';
						sram_addr <= i_addr;
						sram_data <= (others => 'Z');
					else
						reg_state <= s0;
						sram_en <= '1';
						sram_oe <= '1';
						sram_we <= '1';
					end if;				
				when w1 =>
					reg_state <= w2;
					sram_we <= '0';
				when w2 => 
					reg_state <= s0;
					sram_en <= '1';
					sram_we <= '1';
				when r1 =>
					reg_state <= r2;
					sram_oe <= '0';
				when r2 =>
					reg_state <= s0;
					sram_oe <= '1';
					sram_we <= '1';
					q_data <= sram_data;
				when others =>
					reg_state <= s0;
					sram_en <= '1';
					sram_oe <= '1';
					sram_we <= '1';
			end case;
		end if;
	end process;     
end bhv;
