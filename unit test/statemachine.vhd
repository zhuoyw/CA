library ieee;
use ieee.std_logic_1164.all;

entity main is
  port (
	clk			: in std_logic;
	rst 		: in std_logic;
	i_num		: in std_logic_vector(15 downto 0);
	q_data		: out std_logic_vector(15 downto 0);

	digit		: out std_logic_vector(6 downto 0);
	digit2		: out std_logic_vector(6 downto 0);
	ram_data: inout std_logic_vector(15 downto 0);
	ram_addr: out std_logic_vector(15 downto 0);
	ram_reserve: out std_logic_vector(1 downto 0) := "00";
	ram_oe: out std_logic;
	ram_we: out std_logic;
	ram_en: out std_logic;
	wrn	: out std_logic;
	rdn	: out std_logic
  ) ;
end entity ; -- main

architecture bhv of main is
	component sram_controller
	port (
		--from/to upper
		i_clk			: in std_logic;
		i_addr			: in std_logic_vector(15 downto 0);
		i_data 			: in std_logic_vector(15 downto 0);
		q_data 			: out std_logic_vector(15 downto 0);
		write_mem 		: in std_logic;
		read_mem 		: in std_logic;
		--from/to sram
		sram_data 		: inout std_logic_vector(15 downto 0);
		sram_addr 		: out std_logic_vector(15 downto 0);
		sram_oe 			: out std_logic;
		sram_we 			: out std_logic;
		sram_en 			: out std_logic
    );
	end component;

	type state_type is (s0, s1, s2, s3 , s4, s5, s6, s7, s8, s9, s10);
	signal reg_addr : std_logic_vector(15 downto 0);
	signal reg_data : std_logic_vector(15 downto 0); 
	signal reg_read : std_logic := '0';
	signal reg_write: std_logic := '0';
	signal reg_state: state_type := s0;

begin
	u1:sram_controller port map (clk, reg_addr, reg_data, q_data, reg_write, reg_read, ram_data, ram_addr, ram_oe, ram_we, ram_en);
	wrn <= '1';
	rdn <= '1';
	digit2 <= "0000000";
	ram_reserve <= "00";
	process(clk, rst)
	begin
		if (rst = '0') then
			reg_state <= s0;
			reg_read <= '0';
			reg_write <= '0';
			digit <= "1111111";
			--digit2 <= "1111111";
			--q_data <= "0000000000000000";
		elsif (clk='1' and clk'event) then
			case(reg_state) is
				when s0 =>
					reg_data <= i_num;
					digit <= "0000001";
					--q_data <= i_num;
					reg_state <= s1;
				when s1 =>
					reg_addr <= i_num;
					digit <= "0000011";
					--q_data <= i_num;
					reg_state <= s2;
				when s2 =>
					reg_read <= '0';
					reg_write <= '1';
					digit <= "0000111";
					reg_state <= s3;
				when s3 =>
					digit <= "0001111";
					reg_state <= s4;
				when s4 =>
					digit <= "0011011";
					reg_state <= s5;
				when s5 =>
					digit <= "0011111";
					reg_read <= '1';
					reg_write <= '0';
					reg_state <= s6;
				when s6 =>
					digit <= "0111111";
					--reg_read <= '1';
					--reg_write <= '0';
					reg_state <= s7;
				when s7 =>
					digit <= "1111111";
					reg_state <= s8;
				when s8 =>
					digit <= "1000001";
					reg_read <= '0';
					reg_write <= '0';
					reg_state <= s9;
				when s9 =>
					digit <= "0000001";
					reg_state <= s10;
				when s10 =>
					digit <= "0000011";
					reg_state <= s0;
				when others =>
					reg_state <= s0;
			end case;
		end if;
	end process;
end bhv ; -- bhmain 

