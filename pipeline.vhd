entity pipeline is
  port (
	clk				: in std_logic;
	rst				: in std_logic;

	mem_data 		: inout std_logic_vector(15 downto 0);
	mem_addr 		: out std_logic_vector(15 downto 0);
	mem_oe 			: out std_logic;
	mem_we 			: out std_logic;
	mem_en 			: out std_logic
  ) ;
end entity ; -- pipeline

architecture arch of pipeline is

	--clock
	signal sys_clk 		: std_logic;
	
	--data if
	signal if_inst			: std_logic_vector(15 downto 0);

	--data id
	signal id_inst			: std_logic_vector(15 downto 0);
	signal id_immd			: std_logic_vector(15 downto 0);
	signal id_rx 			: std_logic_vector(15 downto 0);
	signal id_ry 			: std_logic_vector(15 downto 0);
	--control
	--control pc
	signal id_branch		: std_logic;
	signal id_jump			: std_logic;
	--control alu
	signal id_alu_src_a	: std_logic_vector(1 downto 0);
	signal id_alu_src_b	: std_logic_vector(1 downto 0);
	signal id_alu_opcode	: std_logic_vector(3 downto 0);
	--control mem
	signal id_read_mem		: std_logic;
	signal id_write_mem	: std_logic;
	--control reg_file
	signal id_write_reg	: std_logic;
	signal id_write_ext	: std_logic;
	--control wb
	signal id_rd 			: std_logic_vector(2 downto 0);
	signal id_mem_to_reg	: std_logic;

	--data ex
	signal ex_immd			: std_logic_vector(15 downto 0);
	signal ex_rx 			: std_logic_vector(15 downto 0);
	signal ex_ry 			: std_logic_vector(15 downto 0);
	signal ex_alu_a 		: std_logic_vector(15 downto 0);
	signal ex_alu_b 		: std_logic_vector(15 downto 0);
	--constrol ex 
	signal ex_branch		: std_logic;
	signal ex_jump			: std_logic;
	signal ex_alu_src_a		: std_logic_vector(1 downto 0);
	signal ex_alu_src_b		: std_logic_vector(1 downto 0);
	signal ex_alu_opcode	: std_logic_vector(3 downto 0);
	signal ex_read_mem		: std_logic;
	signal ex_write_mem	: std_logic;
	signal ex_write_reg	: std_logic;
	signal ex_write_ext	: std_logic;
	signal ex_rd 			: std_logic_vector(2 downto 0);
	signal ex_mem_to_reg	: std_logic;
	--data ex out
	signal ex_alu_res		: std_logic_vector(15 downto 0);
	signal ex_flag			: std_logic;

	--data me in
	signal me_data		: std_logic_vector(15 downto 0);
	signal me_addr		: std_logic_vector(15 downto 0);
	--contrl me in
	signal me_read_mem		: std_logic;
	signal me_write_mem	: std_logic;
	--data me out
	signal me_mem_res		: std_logic_vector(15 downto 0);
	signal me_alu_res		: std_logic_vector(15 downto 0);
	--control me out
	signal me_write_reg	: std_logic;
	signal me_write_ext	: std_logic;
	signal me_rd 			: std_logic_vector(2 downto 0);
	signal me_mem_to_reg	: std_logic;

	--data wb in
	signal wb_mem_res		: std_logic_vector(15 downto 0);
	signal wb_alu_res		: std_logic_vector(15 downto 0);
	--control wb in 
	signal wb_write_reg	: std_logic;
	signal wb_write_ext	: std_logic;
	signal wb_rd 			: std_logic_vector(2 downto 0);
	signal wb_mem_to_reg	: std_logic;
	--data wb out
	signal wb_mux_res	: std_logic_vector(15 downto 0);

	component clock
	port (
		i_clk		: in std_logic;
		q_clk		: out std_logic
  	);
	end component;
	
	component if_id_reg 
	port (
		i_clk		: in std_logic;
		i_intr		: in std_logic_vector(15 downto 0)
	);
	end component; 

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

	component alu
    port (
        i_alu_a             : in std_logic_vector(15 downto 0);
        i_alu_b             : in std_logic_vector(15 downto 0);
        i_alu_opcode        : in std_logic_vector(3 downto 0);
    
        q_alu_res           : out std_logic_vector(15 downto 0);           
        q_alu_flag          : out std_logic
    );
	end component;

	component controller
	port (
		inst			: in std_logic_vector(15 downto 0);
		branch			: out std_logic;
		jump			: out std_logic;
		alu_src_a		: out std_logic_vector(1 downto 0);
		alu_src_b		: out std_logic_vector(1 downto 0);
		alu_opcode		: out std_logic_vector(2 downto 0);
		mem_to_reg		: out std_logic;
		read_mem		: out std_logic;
		write_mem		: out std_logic;
		write_reg		: out std_logic;
		rd          	: out std_logic_vector(2 downto 0);
		immd			: out std_logic_vector(15 downto 0)
	);
	end component;

	component mem_controller
	port (
		--from/to upper
		i_clk			: in std_logic;
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
	end component;

begin
	--clock
	clock: clock
	port map(
		i_clk => clk,
		q_clk => sys_clk
	);

	--data
	--if
	inst_mem: mem_controller
	port map(

	);

	--if/id
	if_id_reg: if_id_reg 
	port map(
		i_clk => sys_clk, 
		i_intr => if_inst,
		q_intr => id_inst
	);

	--id
	--control
	controller: controller
	port map(
		i_inst => id_inst,
		
		q_branch => id_branch,
		q_jump => id_jump,
		q_alu_src_a => id_alu_src_a,
		q_alu_src_b => id_alu_src_b,
		q_alu_opcode => id_alu_opcode,
		q_mem_to_reg => id_mem_to_reg,
		q_read_mem => id_read_mem,
		q_write_mem => id_write_mem,		
		q_write_reg => id_write_reg,
		q_write_ext => id_write_ext,
		q_rd => id_rd,
		q_immd => id_immd
	);

	reg_file: reg_file 
	port map(
		i_clk => sys_clk,
		write_reg => wb_write_reg,
		i_addr => wb_rd,
		i_data => wb_mux_res, 
		i_rx => id_inst(10 downto 8), 
		i_ry => id_inst(7 downto 5),
		q_rx => id_rx,
		q_ry => id_ry
	);
	
	--id/ex
	id_ex_reg: id_ex_reg
	port map(
		i_clk => sys_clk,
		--data
		i_rx => id_rx,
		i_ry =>	id_ry,
		--control id
		i_branch => id_branch,
		i_jump => id_jump,
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
		q_branch => ex_branch,
		q_jump => ex_jump,
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
	alu: alu
	port map(
		i_alu_a => ex_alu_a,
		i_alu_b => ex_alu_b,
		i_alu_opcode => ex_alu_opcode,
		q_alu_res => ex_alu_res,
		q_alu_flag => ex_flag
	);

	process(alu_src_a)
	begin
		case alu_src_a is

		end case;
	end process;

	process(alu_src_b)
	begin
		case alu_src_b is

		end case;
	end process;

	--ex/me
	ex_me_reg: ex_me_reg
	port map(
		i_clk => sys_clk,
		--data
		i_me_addr => ex_alu_res,
		i_me_data => ex_alu_res,--todo select rx and ry 
		--control
		i_mem_to_reg => ex_mem_to_reg,
		i_read_mem => ex_read_mem,
		i_write_mem => ex_write_mem,
		i_write_reg => ex_write_reg,
		i_write_ext => ex_write_ext,
		i_rd => id_rd,
		
		q_me_addr => me_addr;
		q_me_data => me_data;
		q_mem_to_reg => me_mem_to_reg,
		q_read_mem => me_read_mem,
		q_write_mem => me_write_mem,
		q_write_reg => me_write_reg,
		q_write_ext => me_write_ext,
		q_rd => me_rd
	);

	--me
	data_mem: mem_controller
	port map(
		--from/to upper
		i_clk => clk,		
		i_addr => me_addr,
		i_data => me_data,
		q_data => me_mem_res,
		write_mem => me_write_mem,	
		read_mem => me_read_mem,
		--from/to mem --??? to do
		mem_data => mem_data,
		mem_addr => mem_addr,
		mem_oe => mem_oe,
		mem_we => mem_we,
		mem_en => mem_en
    );

	--me/wb
	me_wb_reg: me_wb_reg
	port map(
		i_clk => sys_clk,
		--data
		i_mem_res => me_mem_res,
		i_alu_res => me_alu_res,
		--control
		i_mem_to_reg => me_mem_to_reg,
		i_write_reg => me_write_reg,
		i_write_ext => me_write_ext,
		i_rd => me_rd,
		
		q_mem_res => wb_mem_res,
		q_alu_res => wb_alu_res,
		q_mem_to_reg => wb_mem_to_reg,
		q_write_reg => wb_write_reg,
		q_write_ext => wb_write_ext,
		q_rd => wb_rd
	);

	process(wb_mem_to_reg)
	begin
		case wb_mem_to_reg is
			when '0' =>
				wb_mux_res <= wb_alu_res;
			when '1' =>
				wb_mux_res <= wb_mem_res;
			when others =>	
				wb_mux_res <= wb_alu_res;
		end case;
	end process;

	--IO


end architecture ; -- arch
