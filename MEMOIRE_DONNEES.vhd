----------------------------------------------------------------------------------
-- Company: INSA TOULOUSE, 4AE SE
-- Engineers: Brage Johnsen & Aleksander Taban
-- 
-- Create Date: 10/17/2025 10:16:24 AM
-- Design Name: 
-- Module Name: MEMOIRE_DONNEES - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MEMOIRE_DONNEES is
    Port ( ADDR : in STD_LOGIC_VECTOR (7 downto 0);
           ENTREE : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           SORTIE : out STD_LOGIC_VECTOR (7 downto 0));
end MEMOIRE_DONNEES;

architecture Behavioral of MEMOIRE_DONNEES is
    type memD is array(0 to 63) of STD_LOGIC_VECTOR(7 downto 0);
    signal memD_array : memD;
begin
    process(RW, CLK, RST)
    begin
        if rising_edge(CLK) then
            if RST = '0' then 
                memD_array <= (others => x"00");
                SORTIE <= x"00";
            elsif RW = '1' then -- Lecture
                SORTIE <= memD_array(to_integer(unsigned(ADDR)));
            elsif RW = '0' then -- Ecriture
                memD_array(to_integer(unsigned(ADDR))) <= ENTREE;
            end if; 
        end if;
    end process;
end Behavioral;
