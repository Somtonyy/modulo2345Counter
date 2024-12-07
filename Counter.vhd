library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity definition for Base11Counter
entity Base11Counter is
    Port (
        Clk, En, Cl, UD, Load  : in STD_LOGIC;  -- Inputs: Clock, Enable, Clear, Up/Down, Load control
        Preset_Value : in STD_LOGIC_VECTOR(12 downto 0); -- Input for preset value, a 13-bit vector
        Q : out STD_LOGIC_VECTOR(12 downto 0)  -- Output, 13-bit vector representing the counter value
    );
end Base11Counter;

-- Architecture definition
architecture logic of Base11Counter is
    -- Signals to represent individual digits of the Base 11 counter, ranging from 0 to 10
    signal digit0, digit1, digit2, digit3 : INTEGER range 0 to 10;
    
    -- Combined counter value, used for calculations (up to 32767 for 4 digits in base 11)
    signal combined_count : INTEGER range 0 to 32767;
begin

    -- Main process block triggered by changes in Clk, Cl (clear), combined_count, digit signals, Load, En, UD
    process(Clk, Cl, combined_count, digit0, digit1, digit2, digit3, Load, En, UD)
    begin
        -- If Clear signal (Cl) is low, reset all digits to 0
        if Cl = '0' then
            digit0 <= 0;
            digit1 <= 0;
            digit2 <= 0;
            digit3 <= 0;
        
        -- If a rising edge of the Clock occurs
        elsif rising_edge(Clk) then
            
            -- If Load signal is low, load the preset values into the counter digits
            if Load = '0' then
                digit0 <= to_integer(unsigned(Preset_Value(3 downto 0)));   -- Load the lower 4 bits to digit0
                digit1 <= to_integer(unsigned(Preset_Value(7 downto 4)));   -- Load bits 4-7 to digit1
                digit2 <= to_integer(unsigned(Preset_Value(11 downto 8)));  -- Load bits 8-11 to digit2
                digit3 <= to_integer(unsigned(Preset_Value(12 downto 12))); -- Load bit 12 to digit3
                
            -- If Enable signal is high, perform counting
            elsif En = '1' then
                
                -- If Up/Down (UD) signal is low, count up
                if UD = '0' then
                    -- Logic for counting up
                    if digit0 = 10 then  -- If digit0 reaches the base (11), reset it to 0
                        digit0 <= 0;
                        
                        -- Move to next digit if current one is full (digit1 = 10 means it reached base)
                        if digit1 = 10 then
                            digit1 <= 0;
                            
                            if digit2 = 10 then
                                digit2 <= 0;
                                
                                -- If the highest digit (digit3) reaches the base, reset it to 0
                                if digit3 = 10 then
                                    digit3 <= 0;
                                else
                                    digit3 <= digit3 + 1;  -- Increment the highest digit
                                end if;
                            else
                                digit2 <= digit2 + 1;  -- Increment digit2
                            end if;
                        else
                            digit1 <= digit1 + 1;  -- Increment digit1
                        end if;
                    else
                        digit0 <= digit0 + 1;  -- Increment digit0
                    end if;
                
                -- If Up/Down (UD) signal is high, count down
                else
                    -- Logic for counting down
                    if digit0 = 0 then  -- If digit0 reaches 0, reset it to 10 (base - 1)
                        digit0 <= 10;
                        
                        if digit1 = 0 then
                            digit1 <= 10;
                            
                            if digit2 = 0 then
                                digit2 <= 10;
                                
                                if digit3 = 0 then
                                    digit3 <= 10;  -- Reset digit3 to 10 if it's 0
                                else
                                    digit3 <= digit3 - 1;  -- Decrement digit3
                                end if;
                            else
                                digit2 <= digit2 - 1;  -- Decrement digit2
                            end if;
                        else
                            digit1 <= digit1 - 1;  -- Decrement digit1
                        end if;
                    else
                        digit0 <= digit0 - 1;  -- Decrement digit0
                    end if;
                end if;
            end if;
        end if;

        -- Special condition: If the counter reaches "0299" , reset the counter
        if digit3 = 0 and digit2 = 2 and digit1 = 9 and digit0 = 9 then
            digit0 <= 0;
            digit1 <= 0;
            digit2 <= 0;
            digit3 <= 0;
        end if;

        -- Special condition: If combined_count reaches 0, and UD is '1' (counting up), reset to max (digit3=2, digit2=9, digit1=9, digit0=8)
        if combined_count = 0000 and UD = '1' and rising_edge(Clk) and En = '1' then
            digit0 <= 8;
            digit1 <= 9;
            digit2 <= 2;
            digit3 <= 0;
        end if;
    end process;

    -- Calculate combined counter value based on the individual digits (Base 11 system):
    -- Each digit is weighted by its place value in Base 11 (digit3 * 11^3, digit2 * 11^2, digit1 * 11^1, digit0 * 11^0)
    combined_count <= digit3 * 1331 + digit2 * 121 + digit1 * 11 + digit0;

    -- Output the combined count as a 13-bit STD_LOGIC_VECTOR
    Q <= std_logic_vector(to_unsigned(combined_count, 13));

end logic;
