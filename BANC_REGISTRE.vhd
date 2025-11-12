----------------------------------------------------------------------------------
-- Company: INSA TOULOUSE, 4AE SE
-- Engineers: Brage Johnsen & Aleksander Taban
-- 
-- Create Date: 10/01/2025 10:42:30 AM
-- Design Name: 
-- Module Name: BANC_REGISTRE - Behavioral
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

entity BANC_REGISTRE is
    Port ( ADDR_A   : in STD_LOGIC_VECTOR (3 downto 0);
           ADDR_B   : in STD_LOGIC_VECTOR (3 downto 0);
           ADDR_W   : in STD_LOGIC_VECTOR (3 downto 0);
           W        : in STD_LOGIC;
           DATA     : in STD_LOGIC_VECTOR (7 downto 0);
           RST      : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           QA       : out STD_LOGIC_VECTOR (7 downto 0);
           QB       : out STD_LOGIC_VECTOR (7 downto 0)
           );
end BANC_REGISTRE;

architecture Behavioral of BANC_REGISTRE is
    type registre is array(0 to 15) of std_logic_vector(7 downto 0);
    signal reg_array : registre := (others => X"00");
begin
    --Partie synchrone
    process (CLK, RST)
    begin
        if rising_edge(CLK) then
            if rst = '0' then -- Le signal reset est actif à 0, 
                reg_array <= (others => X"00"); --Cas où rst = '0', on met tous les 16 registres à 0x00 = 0b00000000
            elsif w = '1' then
                reg_array(to_integer(unsigned(addr_w))) <= DATA;                     
            end if;
            QA <= reg_array(to_integer(unsigned(addr_a)));
            QB <= reg_array(to_integer(unsigned(addr_b)));
        end if;
        
   end process;
    
    
    -- Partie asynchrone
    -- Cas où le registre d`où on veut ecrire est la même comme celle qu'on veut lire
    -- On prend alors le DATA qui est en train d`être ecrit dans le registre de l'@ A, et alors on n'a pas le besoin d'ecrire dans cette registre ni lire
    -- car on lit directement le DATA dans la sortie QA
    QA <= DATA when (w = '1' and addr_w = addr_a) else
        reg_array(to_integer(unsigned(addr_a))); -- Sinon QA <= reg(addresse_de_A)
                    
    QB <= DATA when (w = '1' and addr_w = addr_b) else
        reg_array(to_integer(unsigned(addr_b))); -- Sinon QB <= reg(addresse_de_B)
end Behavioral;
