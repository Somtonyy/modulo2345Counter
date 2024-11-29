library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_FF is
    Port (
        T, clk, cl, load, Pr : in STD_LOGIC;
        Q : out STD_LOGIC  
    );
end T_FF;

architecture behavior of T_FF is
    signal Qt : STD_LOGIC;
begin
    process (clk, cl, T, Load, Pr)
    begin
        if cl = '0' then
            Qt <= '0';
			elsif Load = '0' then
            Qt <= Pr;
			elsif rising_edge(clk) then
            if T = '1' then
                Qt <= not Qt;
            end if;
        end if;
    end process;
    Q <= Qt;
end behavior;