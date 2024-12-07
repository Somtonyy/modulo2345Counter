library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel is
    port (
        En, Clk,cl,UD, Load : in STD_LOGIC;
        Preset_Value : in STD_LOGIC_VECTOR(12 downto 0);
        Load_LED : out STD_LOGIC_VECTOR(12 downto 0);
        Warning : out STD_LOGIC;
        Switch : in STD_LOGIC;
        SevenSeg0, SevenSeg1, SevenSeg2, SevenSeg3 : out STD_LOGIC_VECTOR(6 downto 0);
        LSB : out STD_LOGIC_VECTOR(3 downto 0)
    );
end TopLevel;

architecture logic of TopLevel is
    signal CounterOutput : STD_LOGIC_VECTOR(12 downto 0);
    signal Digits : STD_LOGIC_VECTOR(15 downto 0);
    signal do_not_load : STD_LOGIC;
    signal clockIn : std_logic;
	 component clk_gen_1_output is
        generic (n : integer := 25000;
                 n1 : integer := 500);
        port (Clock : in std_logic;
              c_out : out std_logic);
    end component;
	 component BaseConverter is
        port (
            binaryInput : in STD_LOGIC_VECTOR(12 downto 0);
            base_switch : in STD_LOGIC;
            digits : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    component Base11Counter is
        port (
        Clk, En, Cl, UD, Load  : in STD_LOGIC;
        Preset_Value : in STD_LOGIC_VECTOR(12 downto 0);
        Q : out STD_LOGIC_VECTOR(12 downto 0)
    );
    end component;

    component sevenSegment is
        port (
            A, B, C, D : in std_logic;
            fa, fb, fc, fd, fe, ff, fg : out std_logic
        );
    end component;

    

begin
    LSB <= Digits(3 downto 0);

    Load_LED <= Preset_Value(12 downto 0);

    process(Preset_Value)
	begin
		 if (unsigned(Preset_Value) > 664) then
			  do_not_load <= '1';  
			  Warning <= '1';      
		 else
			  do_not_load <= Load; 
			  Warning <= '0';      
		 end if;
	end process;

    Clock : clk_gen_1_output
        port map (
            Clock => Clk,
            c_out => clockIn
        );
		  
		-- Base11Counter to count in base-11, using clock and control signals
		count : Base11Counter port map (
            En => En,
            Clk => clockIn,
            Cl => Cl,
            UD => UD,
            Load => do_not_load,
            Preset_Value => Preset_Value,
            Q => CounterOutput
        );
		  
		-- Base conversion component to convert counter output into base-11 or another base
		BaseConverterting : BaseConverter
        port map (
            binaryInput => CounterOutput,
            base_switch => Switch,
            digits => Digits
       );
	 
		  
    -- instantiation of Seven-segment display for the first digit (Digits 0-3)
    sevenSegment0 : sevenSegment
        port map (
				Digits(0), Digits(1), Digits(2), Digits(3), SevenSeg0(0), SevenSeg0(1), SevenSeg0(2), SevenSeg0(3), SevenSeg0(4), SevenSeg0(5), SevenSeg0(6)
        );

    sevenSegment1 : sevenSegment
        port map (
				Digits(4), Digits(5), Digits(6), Digits(7), SevenSeg1(0), SevenSeg1(1), SevenSeg1(2), SevenSeg1(3), SevenSeg1(4), SevenSeg1(5), SevenSeg1(6)
        );

    SevenSegment2 : sevenSegment
        port map ( 
				Digits(8), Digits(9), Digits(10), Digits(11), SevenSeg2(0), SevenSeg2(1), SevenSeg2(2), SevenSeg2(3), SevenSeg2(4), SevenSeg2(5), SevenSeg2(6)
        );

    sevenSegment3 : sevenSegment
        port map (
				Digits(12), Digits(13), Digits(14), Digits(15), SevenSeg3(0), SevenSeg3(1), SevenSeg3(2), SevenSeg3(3), SevenSeg3(4), SevenSeg3(5), SevenSeg3(6)
        );
		  

end logic;