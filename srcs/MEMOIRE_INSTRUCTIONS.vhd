----------------------------------------------------------------------------------
-- Company: INSA TOULOUSE, 4AE SE
-- Engineers: Brage Johnsen & Aleksander Taban
-- 
-- Create Date: 10/17/2025 10:16:24 AM
-- Design Name: 
-- Module Name: MEMOIRE_INSTRUCTIONS - Behavioral
-- Project Name: RISC Microprocesseur
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEMOIRE_INSTRUCTIONS is
    Port ( ADDR     : in STD_LOGIC_VECTOR (7 downto 0);
           CLK      : in STD_LOGIC;
           SORTIE   : out STD_LOGIC_VECTOR (31 downto 0));
end MEMOIRE_INSTRUCTIONS;

architecture Behavioral of MEMOIRE_INSTRUCTIONS is
    type memI is array(0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
    signal memI_array : memI := (
    x"0602AA00", -- R2 <- AA
    --TEST DES ALEAS, Valeurs déjà: R1 = AA, R2 = BB
    x"06020300", -- AFC 3 dans R2
    x"05010200", -- COP R1 R2 => R1 <- R2 <=> R1 <- 3, ce qu'on veut.
    x"06000500", -- AFC 5 dans R0
    x"06010600", -- AFC 6 dans R1
    x"01020001", -- ADD R2 R0 R1
    x"02030001", -- MUL R3 R0 R1 
    x"03040100", -- SOU R4 R1 R0
    x"05050000", -- COP R5 R0
    x"14060001", -- ET R6 R0 R1
    x"15070001", -- OU R7 R0 R1
    x"16080001", -- OUX R8 R0 R1
    x"17090000", -- NON R9 R0
    x"08000400", -- SRD @0 R4
    x"08010000", -- SRD @1 R0
    x"08020300", -- SRD @2 R3
    x"070A0000", -- LRD R10 @0
    x"070B0101", -- LRD R11 @1
    x"070C0202", -- LRD R12 @2
    x"070D0000", -- LRD R13 @0
    x"070E0100", -- LRD R14 @1
    x"070F0200", -- LRD R15 @2
    x"06010500", -- AFC 6 dans R1
    x"06010600", -- AFC 6 dans R1
    x"06010700", -- AFC 6 dans R1
    x"06010800", -- AFC 6 dans R1
    x"01010101", -- ADD R1 R1 dans R1
    x"0601BB00", -- Affectation pour les aléas. R1 <- BB
    x"0602AA00", -- R2 <- AA
    --TEST DES ALEAS, Valeurs déjà: R1 = AA, R2 = BB
    x"06020300", -- AFC 3 dans R2
    x"05010200", -- COP R1 R2 => R1 <- R2, R1 <- 3, ce qu'on veut.
    x"010C0A0B", -- ADD R12 R10 R11
    x"020D0A0B", -- MUL R13 R10 R11
    others => x"00000000");
begin
    process(CLK)
    begin
        if rising_edge(CLK) then 
            SORTIE <= memI_array(to_integer(unsigned(ADDR)));
        end if;
    end process;

end Behavioral;
