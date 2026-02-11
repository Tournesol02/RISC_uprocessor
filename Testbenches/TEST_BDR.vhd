----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Katten min
-- 
-- Create Date: 16.10.2025 20:32:30
-- Design Name: 
-- Module Name: test_BDR - Behavioral
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

entity test_BDR is
-- Testbench has no ports
end TEST_BDR;

architecture Behavioral of TEST_BDR is

    -- Component declaration
    component BANC_REGISTRE
      Port ( ADDR_A : in STD_LOGIC_VECTOR (3 downto 0);
           ADDR_B : in STD_LOGIC_VECTOR (3 downto 0);
           ADDR_W : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0)
           );
    end component;
    
    --for all : BANC_REGISTRE use entity work.BANC_REGISTRE(BANC_REGISTRE);

    -- Signals to connect to DUT
    signal ADDR_A, ADDR_B, ADDR_W : STD_LOGIC_VECTOR(3 downto 0);
    signal W                      : STD_LOGIC := '0';
    signal DATA                   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal RST, CLK               : STD_LOGIC := '0';
    signal QA, QB                 : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate DUT
    DUT: BANC_REGISTRE
        Port map (
            ADDR_A => ADDR_A,
            ADDR_B => ADDR_B,
            ADDR_W => ADDR_W,
            W      => W,
            DATA   => DATA,
            RST    => RST,
            CLK    => CLK,
            QA     => QA,
            QB     => QB
        );


--Clock
CLK_process : process
begin
    while true loop
        CLK <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
    end loop;
end process;
-- Stimulus process
    stim_proc : process
    begin
        -- Reset
        RST <= '0';
        wait for 20 ns;
        RST <= '1';
        wait for 10 ns;

        -- Write to registers
        ADDR_W <= "0101"; DATA <= x"45"; W <= '1';
        wait for 10 ns; W <= '0';
        ADDR_W <= "1001"; DATA <= x"11"; W <= '1';
        wait for 10 ns; W <= '0';
        ADDR_W <= "1111"; DATA <= X"55"; W<='1';

        -- Read addresses
        ADDR_A <= "1001"; ADDR_B <= "0101"; 
        wait for 20 ns;
        ADDR_A <= "1111";
        wait for 20 ns;
        ADDR_W <= "0111"; DATA <= x"45"; W <= '1'; ADDR_A <= "0111";
        
        -- Finnish simulation perkele
        wait;
    end process;
end Behavioral;
