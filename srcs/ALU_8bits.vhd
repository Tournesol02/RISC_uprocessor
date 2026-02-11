----------------------------------------------------------------------------------
-- Company: INSA TOULOUSE, 4AE SE
-- Engineer: Brage Johnsen et Aleksander Taban
-- 
-- Create Date: 25.09.2025 17:22:28
-- Design Name: MON_ALU
-- Module Name: ALU_8bits - Behavioral
-- Project Name: RISC Microprocesseur
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


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
    -- OPCODE, en suivant le code d'operation donné. Notre OPCODE necessite 2 hex, alors 8bits alloués.
    constant AJ         : STD_LOGIC_VECTOR (7 downto 0) := X"01"; 
    constant MUL        : STD_LOGIC_VECTOR (7 downto 0) := X"02";
    constant SOU        : STD_LOGIC_VECTOR (7 downto 0) := X"03";
    constant ET         : STD_LOGIC_VECTOR (7 downto 0) := X"14";
    constant OU         : STD_LOGIC_VECTOR (7 downto 0) := X"15";
    constant OUX        : STD_LOGIC_VECTOR (7 downto 0) := X"16";
    constant NON        : STD_LOGIC_VECTOR (7 downto 0) := X"17";
    constant COP        : STD_LOGIC_VECTOR (7 downto 0) := X"05";
    constant AFC        : STD_LOGIC_VECTOR (7 downto 0) := X"06";
    constant CRD        : STD_LOGIC_VECTOR (7 downto 0) := X"07";
    constant SRD        : STD_LOGIC_VECTOR (7 downto 0) := X"08";

    -- Notre signal auxiliaire est utilisé pour gérér les fanions: Carry, Depassement. 
    signal aux : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
    
begin
    CARRY <= aux(8); -- Le chiffre le plus grand possible en ajoutant deux chiffres 8bits est de 9bits, alors le bit nr. 8 sera à '1'.
    NEGATIF <= '1' when (A < B and OPCODE = SOU) else '0'; -- 
    DEPASSEMENT <= '1' when (aux(15 downto 8) /= "00000000" and OPCODE = MUL) else '0'; -- Depassement dès qu'on aura au moins un '1' dans les bits 8->15
    process(A,B,OPCODE)
        begin
        case OPCODE is         
            when AJ => -- Sommateur
                aux <= "0000000" & (('0' & A) + ('0' & B));
            when MUL => -- Multiplicateur
                aux <= (A * B);
            when SOU => -- Soustraction
                aux <= X"00" & (A - B);
            when ET => -- ET
                aux <= X"00" & (A AND B);
            when OU => -- OU
                aux <= X"00" & (A OR B);
            when OUX => -- OUX
                aux <= X"00" & (A XOR B);               
            when NON => -- NON
                aux <= X"00" & NOT(A);
            when others =>
        end case;
    end process;
 S <= aux(7 downto 0); -- Recuperation en sortie
end Behavioral;






