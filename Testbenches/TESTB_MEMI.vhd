----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2025 10:44:52 AM
-- Design Name: 
-- Module Name: test_MEMD - Behavioral
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


entity TESTB_MEMI is
-- Testbench has no ports
end TESB_MEMI;


architecture Behavioral of TESTB_MEMI is
    -- Component declaration
    component MEMOIRE_INSTRUCTIONS
        Port ( ADDR     : in STD_LOGIC_VECTOR (7 downto 0);
            CLK         : in STD_LOGIC;
            SORTIE      : out STD_LOGIC_VECTOR (31 downto 0));
     end component;

    -- Signals to connect to DUT
    signal TADDR    : STD_LOGIC_VECTOR(7 downto 0);
    signal TSORTIE  : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal TCLK     : STD_LOGIC := '0';

    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- INIT DUT
    DUT: MEMOIRE_INSTRUCTIONS
        Port map (
            ADDR    => TADDR,
            CLK     => TCLK,
            SORTIE  => TSORTIE
        );

    --Clock
    CLK_process : process
    begin
        while true loop
            TCLK <= '1';
            wait for 5 ns;
            TCLK <= '0';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin    
        TADDR <= x"3F"; 
        wait for 10 ns;
        TADDR <= x"3E"; 
        wait for 10 ns;
        TADDR <= x"3D"; 
        wait for 10 ns;
        TADDR <= x"3C"; 
        wait for 10 ns;
        TADDR <= x"3B"; 
        wait for 10 ns;
        TADDR <= x"3A"; 
        wait for 10 ns;
        TADDR <= x"39"; 
        wait for 10 ns;
        TADDR <= x"38"; 
        wait for 10 ns;
     
         
        
    
        -- Finnish simulation perkele
        wait;
    end process;
end Behavioral;
