library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity partpipe is
  port (
	clk				: in std_logic;
	rst				: in std_logic;
	if_inst 		: in std_logic_vector(15 downto 0)
  ) ;
end entity ; -- partpipe

architecture arch of partpipe is

	--clock
	signal sys_clk 		: std_logic;
	
	--data if
	signal if_pc_mux_res	: std_logic_vector(15 downto 0);
	signal if_pc_plus_4		: std_logic_vector(15 downto 0);
		
	signal if_pc_res		: std_logic_vector(15 downto 0);
	--signal if_inst			: std_logic_vector(15 downto 0);

	--data id
	signal id_pc_src		: std_logic_vector(1 downto 0);
	signal id_pc_plus_immd 	: std_logic_vector(15 downto 0);

	signal id_pc_res 		: std_logic_vector(15 downto 0);
	signal id_inst			: std_logic_vector(15 downto 0);
	signal id_immd			: std_logic_vector(15 downto 0);
	signal id_rx 			: std_logic_vector(15 downto 0);
	signal id_ry 			: std_logic_vector(15 downto 0);
	signal id_t 			: std_logic_vector(15 downto 0);
	signal id_ra 			: std_logic_vector(15 downto 0);
	signal id_sp			: std_logic_vector(15 downto 0);
	signal id_ih 			: std_logic_vector(15 downto 0);

	--control
	--control pc
	signal id_branch		: std_logic_vector(2 downto 0);
	--control alu
	signal id_mem_data_src  : std_logic;
	signal id_alu_src_a		: std_logic_vector(2 downto 0);
	signal id_alu_src_b		: std_logic;
	signal id_alu_opcode	: std_logic_vector(3 downto 0);
	--control mem
	signal id_read_mem		: std_logic;
	signal id_write_mem		: std_logic;
	--control reg_file
	signal id_write_reg		: std_logic;
	signal id_write_ext		: std_logic;
	--control wb
	signal id_rd 			: std_logic_vector(2 downto 0);
	signal id_mem_to_reg	: std_logic;

	--data ex
	signal ex_immd			: std_logic_vector(15 downto 0);
	signal ex_rx 			: std_logic_vector(15 downto 0);
	signal ex_ry 			: std_logic_vector(15 downto 0);
	signal ex_ra 			: std_logic_vector(15 downto 0);
	signal ex_sp			: std_logic_vector(15 downto 0);
	signal ex_ih 			: std_logic_vector(15 downto 0);
	signal ex_alu_a 		: std_logic_vector(15 downto 0);
	signal ex_alu_b 		: std_logic_vector(15 downto 0);
	signal ex_pc_res 		: std_logic_vector(15 downto 0);
	--control ex 
	signal ex_mem_data_src	: std_logic;
	signal ex_alu_src_a		: std_logic_vector(2 downto 0);
	signal ex_alu_src_b		: std_logic;
	signal ex_alu_opcode		: std_logic_vector(3 downto 0);
	signal ex_read_mem		: std_logic;
	signal ex_write_mem		: std_logic;
	signal ex_write_reg		: std_logic;
	signal ex_write_ext		: std_logic;
	signal ex_rd 			: std_logic_vector(2 downto 0);
	signal ex_mem_to_reg	: std_logic;
	--data ex out
	signal ex_alu_res		: std_logic_vector(15 downto 0);
	signal ex_mux_res		: std_logic_vector(15 downto 0);
	signal ex_flag			: std_logic;

	signal me_data		: std_logic_vector(15 downto 0);
	--contrl me in
	signal me_read_mem		: std_logic;
	signal me_write_mem	: std_logic;
	signal me_alu_res		: std_logic_vector(15 downto 0);
	signal me_mem_res		: std_logic_vector(15 downto 0);
	--control me out
	signal me_write_reg	: std_logic;
	signal me_write_ext	: std_logic;
	signal me_rd 			: std_logic_vector(2 downto 0);
	signal me_mem_to_reg	: std_logic;
	
	component clock
	port (
		i_clk		: in std_logic;
		q_clk		: out std_logic
  	);
	end component;
	
	component pc
	port (
		i_clk		: in std_logic;
		i_rst		: in std_logic;
		i_pc		: in std_logic_vector(15 downto 0);
		q_pc		: out std_logic_vector(15 downto 0)
	);
	end component;
	
	component if_id_reg 
	port (
		i_clk 		: in std_logic; 
		i_inst 		: in std_logic_vector(15 downto 0);
		i_pc_res 	: in std_logic_vector(15 downto 0);

		q_inst 		: out std_logic_vector(15 downto 0);
		q_pc_res 	: out std_logic_vector(15 downto 0)
	);
	end component; 

	component id_ex_reg
	port (
		i_clk 			: in std_logic;
		--data
		i_rx 			: in std_logic_vector(15 downto 0);
		i_ry 			: in std_logic_vector(15 downto 0);
		i_ra 			: in std_logic_vector(15 downto 0);
		i_sp 			: in std_logic_vector(15 downto 0);
		i_ih 			: in std_logic_vector(15 downto 0);
		i_pc_res		: in std_logic_vector(15 downto 0);
		--control id
		i_mem_data_src	: in std_logic;
		i_alu_src_a 	: in std_logic_vector(2 downto 0);
		i_alu_src_b 	: in std_logic;
		i_alu_opcode 	: in std_logic_vector(3 downto 0);
		i_mem_to_reg 	: in std_logic;
		i_read_mem 		: in std_logic;
		i_write_mem 	: in std_logic;
		i_write_reg 	: in std_logic;
		i_write_ext 	: in std_logic;
		i_rd 			: in std_logic_vector(2 downto 0);
		i_immd 			: in std_logic_vector(15 downto 0);
		
		q_rx 			: out std_logic_vector(15 downto 0);
		q_ry 			: out std_logic_vector(15 downto 0);
		q_ra 			: out std_logic_vector(15 downto 0);
		q_sp 			: out std_logic_vector(15 downto 0);
		q_ih 			: out std_logic_vector(15 downto 0);
		q_pc_res		: out std_logic_vector(15 downto 0);
		
		q_mem_data_src	: out std_logic;
		q_alu_src_a 	: out std_logic_vector(2 downto 0);
		q_alu_src_b 	: out std_logic;
		q_alu_opcode 	: out std_logic_vector(3 downto 0);
		q_mem_to_reg 	: out std_logic;
		q_read_mem 		: out std_logic;
		q_write_mem 	: out std_logic;
		q_write_reg 	: out std_logic;
		q_write_ext 	: out std_logic;
		q_rd 			: out std_logic_vector(2 downto 0);
		q_immd 			: out std_logic_vector(15 downto 0)
	);
	end component;

	component ex_me_reg
	port (
		i_clk 			: in std_logic;
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
	end component; -- ex_me_reg

	component me_wb_reg is
	port (
		i_clk 			: in std_logic;
		--data
		i_alu_res		: in std_logic_vector(15 downto 0);
		i_mem_res		: in std_logic_vector(15 downto 0);
		
		--control
		i_mem_to_reg 	: in std_logic;
		i_write_reg 	: in std_logic;
		i_write_ext 	: in std_logic;
		i_rd 			: in std_logic_vector(2 downto 0);
		
		--data
		q_alu_res		: out std_logic_vector(15 downto 0);
		q_mem_res		: out std_logic_vector(15 downto 0);
		
		--control
		q_mem_to_reg 	: out std_logic;
		q_write_reg 	: out std_logic;
		q_write_ext 	: out std_logic;
		q_rd 			: out std_logic_vector(2 downto 0)

	);
	end component; -- me_wb_reg

	component reg_file
	port(
		i_clk		: in std_logic;
		write_reg	: in std_logic;
		i_addr		: in std_logic_vector(2 downto 0);
		i_data		: in std_logic_vector(15 downto 0);		
		i_rx		: in std_logic_vector(2 downto 0);
		i_ry		: in std_logic_vector(2 downto 0);
		q_rx		: out std_logic_vector(15 downto 0);
		q_ry		: out std_logic_vector(15 downto 0)	
	);
	end component;

	component ext_file
  	port (
		i_clk		: in std_logic;
		write_ext	: in std_logic;
		i_addr		: in std_logic_vector(2 downto 0);
		i_data		: in std_logic_vector(15 downto 0);		
		q_t 		: out std_logic_vector(15 downto 0);
		q_ra 		: out std_logic_vector(15 downto 0);
		q_sp		: out std_logic_vector(15 downto 0);
		q_ih		: out std_logic_vector(15 downto 0)
	);
	end component; -- ext_file

	component alu
    port (
        i_alu_a             : in std_logic_vector(15 downto 0);
        i_alu_b             : in std_logic_vector(15 downto 0);
        i_alu_opcode        : in std_logic_vector(3 downto 0);
    
        q_alu_res           : out std_logic_vector(15 downto 0);           
        q_alu_flag          : out std_logic
    );
	end component;

	component controller is
		port (
		inst			: in std_logic_vector(15 downto 0);
		branch			: out std_logic_vector(2 downto 0);
		--mem_data_src 	: '0'->rx; '1'->ry
		mem_data_src	: out std_logic;
		--alu_src_a     : "000"->rx;	"001"->ry;	"010"->ra; "011"->sp;	"100"->pc
		alu_src_a		: out std_logic_vector(2 downto 0);
		--alu_src_b     : '0'->immd;	'1'->ry
		alu_src_b		: out std_logic;
		--alu_opcode	: "0000"->add;	"0001"->sub;	"0010"->and;	"0011"->or;	"0100"->eqz;	"0101"->neqz;					  "0110"->lte;	"0111"->equ;	"1000"->sll;					  "1001"->sra	
		alu_opcode		: out std_logic_vector(3 downto 0);
		mem_to_reg		: out std_logic;
		read_mem		: out std_logic;
		write_mem		: out std_logic;
		write_reg		: out std_logic;
		write_ext		: out std_logic;
		--rd 			: "000"~"111"->r0~r7; "001"->ra; "010"->sp;	"011"->ih; "000"->t			
		rd          	: out std_logic_vector(2 downto 0);
		immd			: out std_logic_vector(15 downto 0)
		) ;
	end component;

begin
	--clock
	u_clock: clock
	port map(
		i_clk => clk,
		q_clk => sys_clk
	);

	--data
	--pc
	u_pc: pc
	port map(
		i_clk => sys_clk,
		i_rst => rst,
		i_pc => if_pc_mux_res,
		q_pc => if_pc_res
	);

	id_pc_plus_immd <= id_pc_res + id_immd;
	if_pc_plus_4 <= if_pc_res + "0000000000000001";

	process(id_pc_src)--??
	begin
		case(id_pc_src) is
			when "00" =>
				if_pc_mux_res <= if_pc_plus_4;
			when "01" =>
				if_pc_mux_res <= id_pc_plus_immd;
			when "10" => 
				if_pc_mux_res <= id_rx;
			when "11" =>
				if_pc_mux_res <= id_ra;
			when others =>
				if_pc_mux_res <= (others=>'1');
				--raise error
		end case ;
	end process;

	--if

	--if/id
	u_if_id_reg: if_id_reg 
	port map(
		i_clk => sys_clk, 
		i_inst => if_inst,
		i_pc_res => if_pc_res,

		q_inst => id_inst,
		q_pc_res => id_pc_res
	);

	--id
	--control
	u_controller: controller
	port map(
		inst => id_inst,

		branch => id_branch,
		mem_data_src => id_mem_data_src,
		alu_src_a => id_alu_src_a,
		alu_src_b => id_alu_src_b,
		alu_opcode => id_alu_opcode,
		mem_to_reg => id_mem_to_reg,
		read_mem => id_read_mem,
		write_mem => id_write_mem,		
		write_reg => id_write_reg,
		write_ext => id_write_ext,
		rd => id_rd,
		immd => id_immd
	);

	process(id_branch, id_t, id_rx)
	begin
		case(id_branch) is
			when "000" =>
				id_pc_src <= "00";
			when "001" => 
				id_pc_src <= "01";
			when "010" =>
				if (id_rx = "0000000000000000") then
					id_pc_src <= "01";
				else
					id_pc_src <= "00";
				end if;
			when "011" =>
				if (id_rx = "0000000000000000") then
					id_pc_src <= "00";
				else
					id_pc_src <= "01";
				end if;
			when "100" =>
				if (id_t = "0000000000000000") then
					id_pc_src <= "01";
				else
					id_pc_src <= "00";
				end if;
			when "101" =>
				id_pc_src <= "10";
			when "110" =>
				id_pc_src <= "11";
			when others =>
				id_pc_src <= "00";
				--raise error
		end case ;
	end process;
	
	u_reg_file: reg_file 
	port map(
		i_clk => sys_clk,
		write_reg => '0',
		i_addr => "000",
		i_data => (others=>'0'), 
		i_rx => id_inst(10 downto 8), 
		i_ry => id_inst(7 downto 5),
		q_rx => id_rx,
		q_ry => id_ry
	);
	
	u_ext_file: ext_file 
	port map(
		i_clk => sys_clk,
		write_ext => '0',
		i_addr => "000",
		i_data => (others=>'0'), 
		q_t => id_t,
		q_ra => id_ra,
		q_sp => id_sp,
		q_ih => id_ih
	);

	--id/ex
	u_id_ex_reg: id_ex_reg
	port map(
		i_clk => sys_clk,
		--data
		i_rx => id_rx,
		i_ry =>	id_ry,
		i_ra => id_ra,
		i_sp => id_sp,
		i_ih => id_ih,
		i_pc_res => id_pc_res,
		--control id
		i_mem_data_src => id_mem_data_src,
		i_alu_src_a => id_alu_src_a,
		i_alu_src_b => id_alu_src_b,
		i_alu_opcode => id_alu_opcode,
		i_mem_to_reg => id_mem_to_reg,
		i_read_mem => id_read_mem,
		i_write_mem => id_write_mem,
		i_write_reg => id_write_reg,
		i_write_ext => id_write_ext,
		i_rd => id_rd,
		i_immd => id_immd,
		
		q_rx => ex_rx,
		q_ry => ex_ry,
		q_ra => ex_ra,
		q_sp => ex_sp,
		q_ih => ex_ih,
		q_pc_res => ex_pc_res,
		q_mem_data_src => ex_mem_data_src,
		q_alu_src_a => ex_alu_src_a,
		q_alu_src_b => ex_alu_src_b,
		q_alu_opcode => ex_alu_opcode,
		q_mem_to_reg => ex_mem_to_reg,
		q_read_mem => ex_read_mem,
		q_write_mem => ex_write_mem,
		q_write_reg => ex_write_reg,
		q_write_ext => ex_write_ext,
		q_rd => ex_rd,
		q_immd => ex_immd
	);

	--ex
	process(ex_alu_src_a, ex_rx, ex_ry, ex_ra, ex_sp, ex_pc_res, ex_ih)
	begin
		case ex_alu_src_a is
			when "000" => 
				ex_alu_a <= ex_rx;
			when "001" =>
				ex_alu_a <= ex_ry;
			when "010" =>
				ex_alu_a <= ex_ra;
			when "011" =>
				ex_alu_a <= ex_sp;
			when "100"  =>
				ex_alu_a <= ex_pc_res;
			when "101" =>
				ex_alu_a <= (others=>'0');
			when "110" =>
				ex_alu_a <= ex_ih;
			when others => 
				ex_alu_a <= (others=>'0'); 
		end case;
	end process;

	process(ex_alu_src_b, ex_immd, ex_ry)
	begin
		case ex_alu_src_b is
			when '0' =>
				ex_alu_b <= ex_immd;
			when '1' =>
				ex_alu_b <= ex_ry;
			when others =>
				ex_alu_b <= ex_immd;
				--raise error
		end case;
	end process;

	u_alu: alu
	port map(
		i_alu_a => ex_alu_a,
		i_alu_b => ex_alu_b,
		i_alu_opcode => ex_alu_opcode,
		q_alu_res => ex_alu_res,
		q_alu_flag => ex_flag
	);

	process(ex_mem_data_src, ex_rx, ex_ry)
	begin
		case(ex_mem_data_src) is
			when '0' =>
				ex_mux_res <= ex_rx;
			when '1' =>
				ex_mux_res <= ex_ry;
			when others =>
				ex_mux_res <= (others=>'1');
				--raise error
		end case;
	end process;
	--ex/me
	u_ex_me_reg: ex_me_reg
	port map(
		i_clk => sys_clk,
		--data
		i_alu_res => ex_alu_res,
		i_mem_data => ex_mux_res,--todo select rx and ra 
		--control
		i_mem_to_reg => ex_mem_to_reg,
		i_read_mem => ex_read_mem,
		i_write_mem => ex_write_mem,
		i_write_reg => ex_write_reg,
		i_write_ext => ex_write_ext,
		i_rd => ex_rd,
		
		q_alu_res => me_alu_res,
		q_mem_data => me_data,
		q_mem_to_reg => me_mem_to_reg,
		q_read_mem => me_read_mem,
		q_write_mem => me_write_mem,
		q_write_reg => me_write_reg,
		q_write_ext => me_write_ext,
		q_rd => me_rd
	);

end architecture ; -- arch
