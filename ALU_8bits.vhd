----------------------------------------------------------------------------------
-- Company: INSA TOULOUSE, 4AE SE
-- Engineer: Brage Johnsen et Aleksander Taban
-- 
-- Create Date: 25.09.2025 17:22:28
-- Design Name: MON_ALU
-- Module Name: ALU_8bits - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_8bits is
    Port ( 
           A            : in STD_LOGIC_VECTOR(7 downto 0);
           B            : in STD_LOGIC_VECTOR(7 downto 0);
           OPCODE       : in STD_LOGIC_VECTOR(7 downto 0);
           S            : out STD_LOGIC_VECTOR(7 downto 0);
           CARRY        : out std_logic;
           NEGATIF      : out std_logic;
           DEPASSEMENT  : OUT std_logic
           );
end ALU_8bits;

architecture Behavioral of ALU_8bits is
    -- OPCODE, en suivant le code d'operation donné
    constant ADD        : STD_LOGIC_VECTOR (7 downto 0) := X"01"; -- On est donnè deux hex, donc 8 bits
    constant MUL        : STD_LOGIC_VECTOR (7 downto 0) := X"02";
    constant SUB        : STD_LOGIC_VECTOR (7 downto 0) := X"03";
    constant ET         : STD_LOGIC_VECTOR (7 downto 0) := X"14";
    constant OU         : STD_LOGIC_VECTOR (7 downto 0) := X"15";
    constant OUX        : STD_LOGIC_VECTOR (7 downto 0) := X"16";
    constant NON        : STD_LOGIC_VECTOR (7 downto 0) := X"17";

    -- on met certains de nos valeurs dans un auxilliaire
    signal aux : unsigned(15 downto 0);
begin
    process(A,B,OPCODE)
    variable aux_var : unsigned(15 downto 0);
        begin
        
        -- default values
        CARRY <= '0';
        NEGATIF <= '0';
        DEPASSEMENT <= '0';
        S <= (others => '0');
        
        case OPCODE is 
            when X"01" => --Sommateur
                aux_var := RESIZE(unsigned(A),16) + RESIZE(unsigned(B),16);
                CARRY <= aux_var(8);
                S <= STD_LOGIC_VECTOR(aux_var(7 downto 0));
            when X"02" => -- Multiplicateur
                -- Si le bit de poid le plus fort vaut '1' alors un chiffre negative
                aux_var := unsigned(A) * unsigned(B);
                S <= STD_LOGIC_VECTOR(aux_var(7 downto 0));
                if aux_var(15 downto 8) /= "00000000" then --Regarde si la produit entiere vaut plus que 8bits
                    DEPASSEMENT <= '1';
                else
                    DEPASSEMENT <= '0';
                end if;
            when X"03" => -- Soustraction
                if (A < B) then
                    NEGATIF <= '1';
                    S <= STD_LOGIC_VECTOR(unsigned(B) - unsigned(A));
                else
                    NEGATIF <= '0';
                    S <= STD_LOGIC_VECTOR(unsigned(A) - unsigned(B));
                end if;
            when X"14" => -- ET
                S <= STD_LOGIC_VECTOR(unsigned(A) AND unsigned(B));
            when X"15" => -- OU
                S <= STD_LOGIC_VECTOR(unsigned(A) OR unsigned(B));
            when X"16" => -- OUX
                S <= STD_LOGIC_VECTOR(unsigned(A) XOR unsigned(B));
            when X"17" => -- NON
                S <= NOT(A);
            when others =>
                S           <= (others => '0');
                CARRY       <= '0';
                NEGATIF     <= '0';
                DEPASSEMENT <= '0';
        end case;
    end process;

end Behavioral;






