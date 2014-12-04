library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity com is
  port (
	clk		: in std_logic;
	rst		: in std_logic;
	--i_data	: in std_logic_vector(7 downto 0);
	q_data	: out std_logic_vector(7 downto 0);
	q_digit : out std_logic_vector(7 downto 0);
	iq_data	: inout std_logic_vector(7 downto 0);
	ram_oe	: out std_logic;
	ram_we	: out std_logic;
	ram_en	: out std_logic;
	data_ready : in std_logic;
	tbre	: in std_logic;
	tsre	: in std_logic;
	rdn		: out std_logic;
	wrn		: out std_logic
  ) ;
end entity ; -- com

architecture arch of com is
	
	type state_type is (r0, r1, r2, r3, w0, w1, w2, w3, w4);
	signal reg_state : state_type := r0;
	signal reg_data0 : std_logic_vector(7 downto 0);
	signal reg_data1 : std_logic_vector(7 downto 0);

begin
	process(rst, clk)
	begin
		if (rst = '0') then
			reg_state <= r0;
			ram_en <= '1';
			ram_we <= '1';
			ram_oe <= '1';
			rdn <= '1';
			wrn <= '1';
		elsif(clk = '1' and clk'event) then
			case(reg_state) is
				when r0 =>
					q_digit <= "00000001";
					reg_state <= r1;
					rdn <= '1';
					iq_data <= (others => 'Z');
				when r1 =>
					q_digit <= "00000011";
					if (data_ready = '1') then
						reg_state <= r2;
						rdn <= '0'; 
					else
						reg_state <= r1;
					end if;
				when r2 =>
					q_digit <= "00000111";
					reg_state <= r3;
					rdn <= '1';
					q_data <= iq_data;
					reg_data0 <= iq_data;
				when r3 =>
					q_digit <= "00000111";
					reg_state <= w0;
					reg_data1 <= std_logic_vector(unsigned(reg_data0) + 1);
				when w0 =>
					q_digit <= "00001111";
					reg_state <= w1;
					wrn <= '0';
					iq_data <= reg_data1; 
				when w1 => 
					q_digit <= "00011111";
					reg_state <= w2;
					wrn <= '1';
				when w2 => 
					q_digit <= "00111111";
					if (tbre = '1') then
						reg_state <= w3;
					else
						reg_state <= w2;
					end if;
				when w3 =>
					q_digit <= "01111111";
					reg_state <= w4;
					if (tsre = '1') then
						reg_state <= w4;
					else
						reg_state <= w3;
					end if;
				when others => 
					q_digit <= "01111110";
					reg_state <= r0;
			end case;
		end if;
	end process; -- 

end architecture; -- arch
