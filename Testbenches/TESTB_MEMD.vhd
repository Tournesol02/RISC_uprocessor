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


entity TESTB_MEMD is
-- Testbench has no ports
end TESTB_MEMD;


architecture Behavioral of TESTB_MEMD is
    -- Component declaration
    component MEMOIRE_DONNEES
        Port ( ADDR     : in STD_LOGIC_VECTOR (7 downto 0);
            ENTREE      : in STD_LOGIC_VECTOR (7 downto 0);
            RW          : in STD_LOGIC;
            RST         : in STD_LOGIC;
            CLK         : in STD_LOGIC;
            SORTIE      : out STD_LOGIC_VECTOR (7 downto 0));
     end component;

    -- Signals to connect to DUT
    signal TADDR, TSORTIE   : STD_LOGIC_VECTOR(7 downto 0);
    signal TENTREE          : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal TRW, TRST, TCLK  : STD_LOGIC := '0';

    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- INIT DUT
    DUT: MEMOIRE_DONNEES
        Port map (
            ADDR    => TADDR,
            ENTREE  => TENTREE,
            RW      => TRW,
            RST     => TRST,
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
        -- Reset
        TRST <= '1';
        wait for 20 ns;
        TRST <= '0';
        wait for 10 ns;
    
        TRW <= '0'; TADDR <= x"3F"; TENTREE <= x"69";
        wait for 10 ns;
        TRW <= '0'; TADDR <= x"00"; TENTREE <= x"45";
        wait for 10 ns;
        TRW <= '1'; TADDR <= x"3F";
        wait for 10 ns;
        TRW <= '1'; TADDR <= x"00";
    
        -- Finnish simulation perkele
        wait;
    end process;
end Behavioral;
