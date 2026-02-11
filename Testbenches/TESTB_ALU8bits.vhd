----------------------------------------------------------------------------------
-- Company: INSA TOULOUSE, 4AE SE
-- Engineer: Brage Johnsen & Aleksander Taban 
-- 
-- Create Date: 09/26/2025 10:56:21 AM
-- Design Name: 
-- Module Name: test_ALU - Behavioral
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


entity TESTB_ALU8bits is
-- Testbench n'a pas des portes
end TESTB_ALU8bits;

architecture Simulation_ALU of TESTB_ALU8bits is

component ALU_8bits is
    Port ( 
           A            : in STD_LOGIC_VECTOR(7 downto 0);
           B            : in STD_LOGIC_VECTOR(7 downto 0);
           S            : out STD_LOGIC_VECTOR(7 downto 0);
           OPCODE       : in STD_LOGIC_VECTOR(7 downto 0);
           CARRY        : out STD_LOGIC;
           NEGATIF      : out STD_LOGIC;
           DEPASSEMENT  : out STD_LOGIC);
end component;
    signal TOPCODE,TS,TA, TB                          : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal TCARRY, TNEGATIF, TDEPASSEMENT             : STD_LOGIC;
    
begin
    DUT: ALU_8bits
        port map(
            A => TA,
            B => TB,
            OPCODE => TOPCODE,
            S => TS,
            CARRY => TCARRY,
            NEGATIF => TNEGATIF,
            DEPASSEMENT => TDEPASSEMENT
        );
    
    -- Processus de test
    proc_test : process
    begin
        -- TEST DE ADD
        
        TOPCODE <= X"01"; 
        TA <= std_logic_vector(to_unsigned(22, 8)); --22 est le nombre entier, 8 est le nombre de bits
        TB <= std_logic_vector(to_unsigned(3, 8));
        wait for 20 ns;
        -- TEST DE FANION CARRY
        TA <= std_logic_vector(to_unsigned(250, 8)); 
        TB <= std_logic_vector(to_unsigned(6, 8)); -- A + B = 257 9 bits
        wait for 20 ns; 
        
        -- TEST DE MULTIPLICATION
        TOPCODE <= X"02";
        TA <= std_logic_vector(to_unsigned(22, 8));
        TB <= std_logic_vector(to_unsigned(3, 8));
        wait for 20 ns; 
        --TEST DE FANION DEPASSEMENT 
        TA <= std_logic_vector(to_unsigned(100, 8)); --22 est le nombre entier, 8 est le nombre de bits
        TB <= std_logic_vector(to_unsigned(3, 8));
        wait for 20 ns; 
        
        -- TEST DE SUB
        TOPCODE <= X"03";
        TA <= std_logic_vector(to_unsigned(22, 8)); --22 est le nombre entier, 8 est le nombre de bits
        TB <= std_logic_vector(to_unsigned(3, 8));
        wait for 20 ns;
        -- TEST DE FANION NEGATIF
        TA <= std_logic_vector(to_unsigned(3, 8)); --22 est le nombre entier, 8 est le nombre de bits
        TB <= std_logic_vector(to_unsigned(22, 8));
        wait for 20 ns; 
    
        -- TESTS LOGIQUES
        -- ET
        TOPCODE <= X"14";
        TA <= std_logic_vector(to_unsigned(3, 8));
        wait for 20 ns; 
        -- OU
        TOPCODE <= X"15";
        TA <= std_logic_vector(to_unsigned(3, 8));
        wait for 20 ns; 
        -- OUX
        TOPCODE <= X"16";
        TA <= std_logic_vector(to_unsigned(3, 8));
        wait for 20 ns;
        -- NON
        TOPCODE <= X"17";
        TA <= std_logic_vector(to_unsigned(3, 8));
        wait;
    end process;
end Simulation_ALU;
