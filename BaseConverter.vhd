library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity declaration of BaseConverter
entity BaseConverter is
    Port (
        binaryInput : in STD_LOGIC_VECTOR(12 downto 0);  -- 13-bit binary input
        base_switch : in STD_LOGIC;                       -- Switch to select radix
        digits : out STD_LOGIC_VECTOR(15 downto 0)        -- Output for converted digits in 4-bit format
    );
end BaseConverter;

-- Architecture definition
architecture logic of BaseConverter is
begin
    -- Process to convert binary input to desired base
    process(binaryInput, base_switch)
        -- Internal variables for storing decimal value and digits in the selected base
        variable decimal : INTEGER; 
        variable radix : INTEGER;  -- Selected base (11 or 5)
        variable digit0, digit1, digit2, digit3, digit4 : INTEGER;  -- Converted digits
    begin
        -- Convert binary input to decimal
        decimal := to_integer(unsigned(binaryInput));

        -- Set radix based on the value of base_switch
        case base_switch is
            when '0' =>
                radix := 11;  -- Set radix to 11 when base_switch is '0'
            when others =>
                radix := 5;   -- Set radix to 5 for any other value of base_switch
        end case;

        -- Perform division and modulus operations to break the decimal number into base-specific digits
        digit0 := decimal mod radix;  -- Least significant digit
        decimal := decimal / radix;   -- Update decimal value for next digit

        digit1 := decimal mod radix;
        decimal := decimal / radix;

        digit2 := decimal mod radix;
        decimal := decimal / radix;

        digit3 := decimal mod radix;
        
        -- Assign the digits to the output in 4-bit format for each position
        digits(3 downto 0) <= std_logic_vector(to_unsigned(digit0, 4));
        digits(7 downto 4) <= std_logic_vector(to_unsigned(digit1, 4));
        digits(11 downto 8) <= std_logic_vector(to_unsigned(digit2, 4));
        digits(15 downto 12) <= std_logic_vector(to_unsigned(digit3, 4));
    end process;
end logic;
