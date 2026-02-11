----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2025 19:29:02
-- Design Name: 
-- Module Name: CHEMIN_DONNEES_T - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CHEMIN_DONNEES_T is
--  Port ( );
end CHEMIN_DONNEES_T;

architecture Simulation_Chemin_Donnes of CHEMIN_DONNEES_T is
component CHEMIN_DONNEES is
Port (
        CLK     : in STD_LOGIC;
        RST     : in STD_LOGIC;
        QA  : out STD_LOGIC_VECTOR(7 downto 0);
        QB  : out STD_LOGIC_VECTOR(7 downto 0)
        );
end component;
signal T_CLK : STD_LOGIC := '0'; 
signal T_RST : STD_LOGIC := '1';
signal T_QA, T_QB   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0') ;

begin
DUT : CHEMIN_DONNEES 
        port map(
            CLK => T_CLK,
            RST => T_RST,
            QA => T_QA,
            QB => T_QB
  );
 
 
 clk_gen : process 
 begin
    while true loop
        wait for 10 ns;
        T_CLK <= NOT(T_CLK);
    end loop;
 end process;

end Simulation_Chemin_Donnes;
