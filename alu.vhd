library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    port (
        i_alu_a             	: in std_logic_vector(15 downto 0);
        i_alu_b             	: in std_logic_vector(15 downto 0);
        i_alu_opcode        	: in std_logic_vector(3 downto 0);
    
		q_alu_res           	: out std_logic_vector(15 downto 0);           
        q_alu_flag          	: out std_logic
    );
end entity ; -- alu 

architecture arch_alu of alu is

    function overflow(x, y, z : std_logic) return std_logic is
    begin
        return (x and y and (not z)) or ((not x) and (not y) and z);
    end;

    constant ALU_ADD        : std_logic_vector(3 downto 0) := "0000";
    constant ALU_SUB        : std_logic_vector(3 downto 0) := "0001";
    constant ALU_AND        : std_logic_vector(3 downto 0) := "0010";
    constant ALU_OR         : std_logic_vector(3 downto 0) := "0011";
    --constant ALU_EQZ        : std_logic_vector(3 downto 0) := "0100";
    --constant ALU_NEQZ       : std_logic_vector(3 downto 0) := "0101";
    constant ALU_LTE        : std_logic_vector(3 downto 0) := "0110";
    constant ALU_EQU        : std_logic_vector(3 downto 0) := "0111";
    constant ALU_SLL        : std_logic_vector(3 downto 0) := "1000";
    constant ALU_SRA        : std_logic_vector(3 downto 0) := "1001";

    signal wire_add          : std_logic_vector(15 downto 0) := "0000000000000000";
    signal wire_sub          : std_logic_vector(15 downto 0) := "0000000000000000";
    signal wire_and          : std_logic_vector(15 downto 0) := "0000000000000000";
    signal wire_or           : std_logic_vector(15 downto 0) := "0000000000000000";
    signal wire_sll          : std_logic_vector(15 downto 0) := "0000000000000000";
    signal wire_sra          : std_logic_vector(15 downto 0) := "0000000000000000";
	signal wire_lt			 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal wire_equ			 : std_logic_vector(15 downto 0) := "0000000000000000";
	 
    --signal i_alu_c    		  : std_logic_vector(15 downto 0);
	 --signal cin_add			  : std_logic := '0';
	 --signal cin_sub			  : std_logic := '1';
	 --component adders
		--Port ( 
			--i_alu_a : in  STD_LOGIC_VECTOR(15 downto 0);
			--i_alu_b : in  STD_LOGIC_VECTOR(15 downto 0);
			--i_cin : in 	STD_LOGIC;
			--q_alu_res : out  STD_LOGIC_VECTOR(15 downto 0)
		--);
	 --end component;

begin
    process(i_alu_opcode)
    begin
        case(i_alu_opcode) is
            when ALU_ADD =>
                q_alu_res <= wire_add;
                q_alu_flag <= '0';

            when ALU_SUB =>
                q_alu_res <= wire_sub;
                q_alu_flag <= '0';

            when ALU_AND =>
                q_alu_res <= wire_and;
                q_alu_flag <= '0';

            when ALU_OR =>
                q_alu_res <= wire_or;
                q_alu_flag <= '0';

            when ALU_SLL =>
                q_alu_res <= wire_sll;
                q_alu_flag <= '0';

            when ALU_SRA =>
                q_alu_res <= wire_sra;
                q_alu_flag <= '0';
					 
					 
			when ALU_LTE =>
				q_alu_res <= wire_lt;
				q_alu_flag <= '0';
				 
			when ALU_EQU =>
			 	q_alu_res <= wire_equ;
			 	q_alu_flag <= '0';
					 
            when others =>
				q_alu_res <= "0000000000000000";
				q_alu_flag <= '0';

        end case;
    end process;
	 
	wire_add <= i_alu_a + i_alu_b;
	wire_sub <= i_alu_a - i_alu_b;
    wire_and <= i_alu_a and i_alu_b;
    wire_or  <= i_alu_a or  i_alu_b;
	wire_sll <= std_logic_vector(unsigned(i_alu_a) sll CONV_INTEGER(i_alu_b));
    wire_sra <= to_stdlogicvector(to_bitvector(i_alu_a) sra CONV_INTEGER(i_alu_b));
	 
    process(wire_sub)
    begin
        if wire_sub = "0000000000000000" then 
            wire_equ <= "0000000000000001";
            wire_lt <= "0000000000000000";
        elsif wire_sub(15) = '1' then 
            wire_equ <= "0000000000000000";
            wire_lt <= "0000000000000001";
        else 
            wire_equ <= "0000000000000000";
            wire_lt <= "0000000000000000";
        end if;
    end process;
	 
end architecture ; -- arch_alu
