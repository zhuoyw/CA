library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file is
  	port (
		i_clk			: in std_logic;
		write_reg	: in std_logic;
		-- 0000~0111 general
		-- 1000 t
		-- 1001 ra
		-- 1010 sp
		-- 1011 ih 
		i_addr		: in std_logic_vector(3 downto 0);
		i_data		: in std_logic_vector(15 downto 0);		
		i_rx_addr	: in std_logic_vector(3 downto 0);
		i_ry_addr	: in std_logic_vector(3 downto 0);
		q_rx		: out std_logic_vector(15 downto 0);
		q_ry		: out std_logic_vector(15 downto 0);
		q_t 		: out std_logic_vector(15 downto 0);
		q_ra		: out std_logic_vector(15 downto 0)
	);
end entity ; -- reg_file

architecture arch of reg_file is

	signal counter : integer range 0 to 4 := 0;
	type regfile_type is array(0 to 15) of std_logic_vector(15 downto 0);
	signal regfile : regfile_type := (others => (others => '0'));

	constant addr_t	        : std_logic_vector(3 downto 0) := "1000";
    constant addr_ra	    : std_logic_vector(3 downto 0) := "1001";
    constant addr_sp	    : std_logic_vector(3 downto 0) := "1010";
    constant addr_ih	    : std_logic_vector(3 downto 0) := "1011";

begin

	process(i_clk)
	begin
		if (i_clk = '1' and i_clk'event) then
			if (counter = 3) then
				counter <= 0;
			else
				if (counter = 1) then	
					--counter <= counter + 1;
					if (write_reg = '1') then
						regfile(conv_integer(i_addr)) <= i_data;
					end if;
				end if;
				counter <= counter + 1;
			end if;
		end if;
	end process ; -- 

	q_rx <= regfile(conv_integer(i_rx_addr));
	q_ry <= regfile(conv_integer(i_ry_addr));
	q_t  <= regfile(conv_integer(addr_t));
	q_ra <= regfile(conv_integer(addr_ra));
	
end architecture ; -- arch

