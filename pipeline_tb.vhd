LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY pipeline_tb IS
END pipeline_tb;
 
ARCHITECTURE behavior OF pipeline_tb IS 
    COMPONENT pipeline
    port (
	clk				: in std_logic;
	rst				: in std_logic;
	if_inst 		: in std_logic_vector(15 downto 0)
 	 ) ;
    END COMPONENT;
    
   signal inst : std_logic_vector(15 downto 0) := "0100100100000010";
 
   constant clocktime : time := 20 ns;
	
	signal clock : std_logic := '0';
	signal reset : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pipeline PORT MAP (clock,reset,inst);

   -- Clock process definitions
   process
   begin
		wait for clocktime/2;
		clock <= '1';
		wait for clocktime/2;
		clock <= '0';
		wait for clocktime/2;
		clock <= '1';
		wait for clocktime/2;
		clock <= '0';
		wait for clocktime/2;
		clock <= '1';
		wait for clocktime/2;
		clock <= '0';
		wait for clocktime/2;
		clock <= '1';
		wait for clocktime/2;
		clock <= '0';
   end process;
 

   -- Stimulus process
END;
