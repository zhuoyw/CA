library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity im_controller is
	port (
		--from/to upper
		i_clk			: in std_logic;
		i_addr			: in std_logic_vector(15 downto 0);
		q_data 			: out std_logic_vector(15 downto 0);
		--from/to mem
		sram_data 		: inout std_logic_vector(15 downto 0);
		sram_addr 		: out std_logic_vector(15 downto 0);
		sram_oe 			: out std_logic;
		sram_we 			: out std_logic;
		sram_en 			: out std_logic
    );
	
end im_controller;

architecture bhv of im_controller is
	
	type state_tpye is (s0, r1, r2, r3);
	signal reg_state : state_tpye := s0;

begin
	process (i_clk)                 
	begin
		if (i_clk'event and i_clk = '1') then
			case(reg_state) is
				when s0 =>
					reg_state <= r1;
					sram_en <= '0';
					sram_oe <= '1';
					sram_we <= '1';
					sram_addr <= i_addr;
					sram_data <= (others => 'Z');			
				when r1 =>
					reg_state <= r2;
					sram_oe <= '0';
				when r2 =>
					reg_state <= r3;
					sram_oe <= '1';
					sram_we <= '1';
					q_data <= sram_data;
				when r3 =>
					reg_state <= s0;
					sram_en <= '1';
					sram_oe <= '1';
					sram_we <= '1';
				when others =>
					reg_state <= s0;
					sram_en <= '1';
					sram_oe <= '1';
					sram_we <= '1';
			end case;
		end if;
	end process;     
end bhv;
