library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
	
end entity;

architecture a1 of testbench is
	--signals
	signal clk, reset_n  : std_logic := '0';
	signal state 			: integer := 0;
	--signal data_iterator : integer := 0; 
	--signal data_length 	: integer := 12;
	--type memory is array(0 to 2) of std_logic_vector(31 downto 0);
	--signal mem : memory := ("00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000010" );
	--signals - interconnects
	signal data_output, data_input, o_w_addr, o_w_data : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal w_override : std_logic;
	--components
	component urisc
		port(
			clk, reset_n : in std_logic;
			--memory mapped IO
			data_output : out std_logic_vector(31 downto 0);
			data_input	: in std_logic_vector(31 downto 0);
			--for loading memory
			w_override	: in std_logic;
			o_w_addr		: in std_logic_vector(31 downto 0);
			o_w_data		: in std_logic_vector(31 downto 0)
		);
	end component;
begin
	u : urisc port map(
		clk, reset_n,
		data_output,data_input,
		w_override, o_w_addr, o_w_data
	);
	process (clk)
	begin
		if(rising_edge(clk)) then	
			--init state (not seen on scope)
			if(state = 0) then
				w_override <= '1';
				reset_n <= '0';
				state <= 1;
			elsif (state = 1) then 
				reset_n <= '1';
				state <= 2;
			--inst0
elsif(state = 2) then
	o_w_addr	<=	"00000000000000000000000000000000"; --location:	0
	o_w_data	<=	"00000000000000000000000001010001"; --value:		81
	state <= 3;
elsif(state = 3) then
	o_w_addr	<=	"00000000000000000000000000000001"; --location:	1
	o_w_data	<=	"00000000000000000000000001010001"; --value:		81
	state <= 4;
elsif(state = 4) then
	o_w_addr	<=	"00000000000000000000000000000010"; --location:	2
	o_w_data	<=	"00000000000000000000000000000011"; --value:		3
	state <= 5;
elsif(state = 5) then
	o_w_addr	<=	"00000000000000000000000000000011"; --location:	3
	o_w_data	<=	"00000000000000000000000001000000"; --value:		64
	state <= 6;
elsif(state = 6) then
	o_w_addr	<=	"00000000000000000000000000000100"; --location:	4
	o_w_data	<=	"00000000000000000000000001000000"; --value:		64
	state <= 7;
elsif(state = 7) then
	o_w_addr	<=	"00000000000000000000000000000101"; --location:	5
	o_w_data	<=	"00000000000000000000000000000110"; --value:		6
	state <= 8;
elsif(state = 8) then
	o_w_addr	<=	"00000000000000000000000000000110"; --location:	6
	o_w_data	<=	"00000000000000000000000001000000"; --value:		64
	state <= 9;
elsif(state = 9) then
	o_w_addr	<=	"00000000000000000000000000000111"; --location:	7
	o_w_data	<=	"00000000000000000000000001000010"; --value:		66
	state <= 10;
elsif(state = 10) then
	o_w_addr	<=	"00000000000000000000000000001000"; --location:	8
	o_w_data	<=	"00000000000000000000000000001001"; --value:		9
	state <= 11;
elsif(state = 11) then
	o_w_addr	<=	"00000000000000000000000000001001"; --location:	9
	o_w_data	<=	"00000000000000000000000000000111"; --value:		7
	state <= 12;
elsif(state = 12) then
	o_w_addr	<=	"00000000000000000000000000001010"; --location:	10
	o_w_data	<=	"00000000000000000000000001010000"; --value:		80
	state <= 13;
elsif(state = 13) then
	o_w_addr	<=	"00000000000000000000000000001011"; --location:	11
	o_w_data	<=	"00000000000000000000000000001100"; --value:		12
	state <= 14;
elsif(state = 14) then
	o_w_addr	<=	"00000000000000000000000000001100"; --location:	12
	o_w_data	<=	"00000000000000000000000001000001"; --value:		65
	state <= 15;
elsif(state = 15) then
	o_w_addr	<=	"00000000000000000000000000001101"; --location:	13
	o_w_data	<=	"00000000000000000000000001010000"; --value:		80
	state <= 16;
elsif(state = 16) then
	o_w_addr	<=	"00000000000000000000000000001110"; --location:	14
	o_w_data	<=	"00000000000000000000000000001111"; --value:		15
	state <= 17;
elsif(state = 17) then
	o_w_addr	<=	"00000000000000000000000000001111"; --location:	15
	o_w_data	<=	"00000000000000000000000000000111"; --value:		7
	state <= 18;
elsif(state = 18) then
	o_w_addr	<=	"00000000000000000000000000010000"; --location:	16
	o_w_data	<=	"00000000000000000000000000000111"; --value:		7
	state <= 19;
elsif(state = 19) then
	o_w_addr	<=	"00000000000000000000000000010001"; --location:	17
	o_w_data	<=	"00000000000000000000000000010010"; --value:		18
	state <= 20;
elsif(state = 20) then
	o_w_addr	<=	"00000000000000000000000000010010"; --location:	18
	o_w_data	<=	"00000000000000000000000001010000"; --value:		80
	state <= 21;
elsif(state = 21) then
	o_w_addr	<=	"00000000000000000000000000010011"; --location:	19
	o_w_data	<=	"00000000000000000000000000000111"; --value:		7
	state <= 22;
elsif(state = 22) then
	o_w_addr	<=	"00000000000000000000000000010100"; --location:	20
	o_w_data	<=	"00000000000000000000000000010101"; --value:		21
	state <= 23;
elsif(state = 23) then
	o_w_addr	<=	"00000000000000000000000000010101"; --location:	21
	o_w_data	<=	"00000000000000000000000001010000"; --value:		80
	state <= 24;
elsif(state = 24) then
	o_w_addr	<=	"00000000000000000000000000010110"; --location:	22
	o_w_data	<=	"00000000000000000000000001010000"; --value:		80
	state <= 25;
elsif(state = 25) then
	o_w_addr	<=	"00000000000000000000000000010111"; --location:	23
	o_w_data	<=	"00000000000000000000000000000011"; --value:		3
	state <= 26;
elsif(state = 26) then
	o_w_addr	<=	"00000000000000000000000000011000"; --location:	24
	o_w_data	<=	"00000000000000000000000001010001"; --value:		81
	state <= 27;
elsif(state = 27) then
	o_w_addr	<=	"00000000000000000000000000011001"; --location:	25
	o_w_data	<=	"00000000000000000000000001010001"; --value:		81
	state <= 28;
elsif(state = 28) then
	o_w_addr	<=	"00000000000000000000000000011010"; --location:	26
	o_w_data	<=	"00000000000000000000000000000011"; --value:		3
	state <= 29;
elsif(state = 29) then
	o_w_addr	<=	"00000000000000000000000000011011"; --location:	27
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 30;
elsif(state = 30) then
	o_w_addr	<=	"00000000000000000000000000011100"; --location:	28
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 31;
elsif(state = 31) then
	o_w_addr	<=	"00000000000000000000000000011101"; --location:	29
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 32;
elsif(state = 32) then
	o_w_addr	<=	"00000000000000000000000000011110"; --location:	30
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 33;
elsif(state = 33) then
	o_w_addr	<=	"00000000000000000000000000011111"; --location:	31
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 34;
elsif(state = 34) then
	o_w_addr	<=	"00000000000000000000000000100000"; --location:	32
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 35;
elsif(state = 35) then
	o_w_addr	<=	"00000000000000000000000000100001"; --location:	33
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 36;
elsif(state = 36) then
	o_w_addr	<=	"00000000000000000000000000100010"; --location:	34
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 37;
elsif(state = 37) then
	o_w_addr	<=	"00000000000000000000000000100011"; --location:	35
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 38;
elsif(state = 38) then
	o_w_addr	<=	"00000000000000000000000000100100"; --location:	36
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 39;
elsif(state = 39) then
	o_w_addr	<=	"00000000000000000000000000100101"; --location:	37
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 40;
elsif(state = 40) then
	o_w_addr	<=	"00000000000000000000000000100110"; --location:	38
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 41;
elsif(state = 41) then
	o_w_addr	<=	"00000000000000000000000000100111"; --location:	39
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 42;
elsif(state = 42) then
	o_w_addr	<=	"00000000000000000000000000101000"; --location:	40
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 43;
elsif(state = 43) then
	o_w_addr	<=	"00000000000000000000000000101001"; --location:	41
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 44;
elsif(state = 44) then
	o_w_addr	<=	"00000000000000000000000000101010"; --location:	42
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 45;
elsif(state = 45) then
	o_w_addr	<=	"00000000000000000000000000101011"; --location:	43
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 46;
elsif(state = 46) then
	o_w_addr	<=	"00000000000000000000000000101100"; --location:	44
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 47;
elsif(state = 47) then
	o_w_addr	<=	"00000000000000000000000000101101"; --location:	45
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 48;
elsif(state = 48) then
	o_w_addr	<=	"00000000000000000000000000101110"; --location:	46
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 49;
elsif(state = 49) then
	o_w_addr	<=	"00000000000000000000000000101111"; --location:	47
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 50;
elsif(state = 50) then
	o_w_addr	<=	"00000000000000000000000000110000"; --location:	48
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 51;
elsif(state = 51) then
	o_w_addr	<=	"00000000000000000000000000110001"; --location:	49
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 52;
elsif(state = 52) then
	o_w_addr	<=	"00000000000000000000000000110010"; --location:	50
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 53;
elsif(state = 53) then
	o_w_addr	<=	"00000000000000000000000000110011"; --location:	51
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 54;
elsif(state = 54) then
	o_w_addr	<=	"00000000000000000000000000110100"; --location:	52
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 55;
elsif(state = 55) then
	o_w_addr	<=	"00000000000000000000000000110101"; --location:	53
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 56;
elsif(state = 56) then
	o_w_addr	<=	"00000000000000000000000000110110"; --location:	54
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 57;
elsif(state = 57) then
	o_w_addr	<=	"00000000000000000000000000110111"; --location:	55
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 58;
elsif(state = 58) then
	o_w_addr	<=	"00000000000000000000000000111000"; --location:	56
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 59;
elsif(state = 59) then
	o_w_addr	<=	"00000000000000000000000000111001"; --location:	57
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 60;
elsif(state = 60) then
	o_w_addr	<=	"00000000000000000000000000111010"; --location:	58
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 61;
elsif(state = 61) then
	o_w_addr	<=	"00000000000000000000000000111011"; --location:	59
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 62;
elsif(state = 62) then
	o_w_addr	<=	"00000000000000000000000000111100"; --location:	60
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 63;
elsif(state = 63) then
	o_w_addr	<=	"00000000000000000000000000111101"; --location:	61
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 64;
elsif(state = 64) then
	o_w_addr	<=	"00000000000000000000000000111110"; --location:	62
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 65;
elsif(state = 65) then
	o_w_addr	<=	"00000000000000000000000000111111"; --location:	63
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 66;
elsif(state = 66) then
	o_w_addr	<=	"00000000000000000000000001000000"; --location:	64
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 67;
elsif(state = 67) then
	o_w_addr	<=	"00000000000000000000000001000001"; --location:	65
	o_w_data	<=	"00000000000000000000000000000001"; --value:		1
	state <= 68;
elsif(state = 68) then
	o_w_addr	<=	"00000000000000000000000001000010"; --location:	66
	o_w_data	<=	"11111111111111111111111110101010"; --value:		-86
	state <= 69;
elsif(state = 69) then
	o_w_addr	<=	"00000000000000000000000001000011"; --location:	67
	o_w_data	<=	"11111111111111111111111110011111"; --value:		-97
	state <= 70;
elsif(state = 70) then
	o_w_addr	<=	"00000000000000000000000001000100"; --location:	68
	o_w_data	<=	"11111111111111111111111110011001"; --value:		-103
	state <= 71;
elsif(state = 71) then
	o_w_addr	<=	"00000000000000000000000001000101"; --location:	69
	o_w_data	<=	"11111111111111111111111110010111"; --value:		-105
	state <= 72;
elsif(state = 72) then
	o_w_addr	<=	"00000000000000000000000001000110"; --location:	70
	o_w_data	<=	"11111111111111111111111110010010"; --value:		-110
	state <= 73;
elsif(state = 73) then
	o_w_addr	<=	"00000000000000000000000001000111"; --location:	71
	o_w_data	<=	"11111111111111111111111110011111"; --value:		-97
	state <= 74;
elsif(state = 74) then
	o_w_addr	<=	"00000000000000000000000001001000"; --location:	72
	o_w_data	<=	"11111111111111111111111111011111"; --value:		-33
	state <= 75;
elsif(state = 75) then
	o_w_addr	<=	"00000000000000000000000001001001"; --location:	73
	o_w_data	<=	"11111111111111111111111110101010"; --value:		-86
	state <= 76;
elsif(state = 76) then
	o_w_addr	<=	"00000000000000000000000001001010"; --location:	74
	o_w_data	<=	"11111111111111111111111110011111"; --value:		-97
	state <= 77;
elsif(state = 77) then
	o_w_addr	<=	"00000000000000000000000001001011"; --location:	75
	o_w_data	<=	"11111111111111111111111110011001"; --value:		-103
	state <= 78;
elsif(state = 78) then
	o_w_addr	<=	"00000000000000000000000001001100"; --location:	76
	o_w_data	<=	"11111111111111111111111110010111"; --value:		-105
	state <= 79;
elsif(state = 79) then
	o_w_addr	<=	"00000000000000000000000001001101"; --location:	77
	o_w_data	<=	"11111111111111111111111110010010"; --value:		-110
	state <= 80;
elsif(state = 80) then
	o_w_addr	<=	"00000000000000000000000001001110"; --location:	78
	o_w_data	<=	"11111111111111111111111110011111"; --value:		-97
	state <= 81;
elsif(state = 81) then
	o_w_addr	<=	"00000000000000000000000001001111"; --location:	79
	o_w_data	<=	"11111111111111111111111111011111"; --value:		-33
	state <= 82;
elsif(state = 82) then
	o_w_addr	<=	"00000000000000000000000001010000"; --location:	80
	o_w_data	<=	"00000000000000000000000000000000"; --value:		0
	state <= 83;
elsif(state = 83) then
	o_w_addr	<=	"00000000000000000000000001010001"; --location:	81
	o_w_data	<=	"00000000000000000000000000000101"; --value:		5
	state <= 84;
			else
				w_override <= '0';
			end if;
		end if;
	end process;
	--clock generator
	process
	begin
		clk <= not clk;
		wait for 20ns;
	end process;
end architecture;
