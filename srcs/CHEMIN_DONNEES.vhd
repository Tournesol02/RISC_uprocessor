----------------------------------------------------------------------------------
-- Company: Johnsen & Taban Electronics
-- Engineer: Taban, Aleksander & Johnsen, Brage
-- 
-- Create Date: 10/23/2025 11:07:37 AM
-- Design Name: 
-- Module Name: CHEMIN_DONNEES - Behavioral
-- Project Name: RISC Microprocesseur
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CHEMIN_DONNEES is
Port( 
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    QA : out STD_LOGIC_VECTOR(7 downto 0);
    QB : out STD_LOGIC_VECTOR(7 downto 0));
end CHEMIN_DONNEES;

architecture Behavioral of CHEMIN_DONNEES is

    -- MEMOIRE D'INSTRUCTIONS
    signal MEMI_ADDR    : STD_LOGIC_VECTOR (7 downto 0);
    signal MEMI_S       : STD_LOGIC_VECTOR (31 downto 0);
    signal MEMI_CLK     : STD_LOGIC;

    -- BANC DE REGISTRE
    signal REG_ADDR_A   : STD_LOGIC_VECTOR (3 downto 0);
    signal REG_ADDR_B   : STD_LOGIC_VECTOR (3 downto 0);
    signal REG_ADDR_W   : STD_LOGIC_VECTOR (3 downto 0);
    signal REG_W        : STD_LOGIC;
    signal REG_RST      : STD_LOGIC;
    signal REG_CLK      : STD_LOGIC;
    signal REG_DATA     : STD_LOGIC_VECTOR (7 downto 0);
    signal REG_QA       : STD_LOGIC_VECTOR (7 downto 0);
    signal REG_QB       : STD_LOGIC_VECTOR (7 downto 0);
    
    -- UAL
    signal UAL_A            : STD_LOGIC_VECTOR(7 downto 0);
    signal UAL_B            : STD_LOGIC_VECTOR(7 downto 0);
    signal UAL_OPCODE       : STD_LOGIC_VECTOR(7 downto 0);
    signal UAL_S            : STD_LOGIC_VECTOR(7 downto 0);
    signal UAL_CARRY        : std_logic;
    signal UAL_NEGATIF      : std_logic;
    signal UAL_DEPASSEMENT  : std_logic;
    
    -- MEMOIRE DE DONNÉES
    signal MEMD_ADDR    :  STD_LOGIC_VECTOR (7 downto 0);
    signal MEMD_ENTREE  :  STD_LOGIC_VECTOR (7 downto 0);
    signal MEMD_S       :  STD_LOGIC_VECTOR (7 downto 0);
    signal MEMD_RW      :  STD_LOGIC;
    signal MEMD_RST     :  STD_LOGIC;
    signal MEMD_CLK     :  STD_LOGIC;
    
    -- CHEMIN DE DONNEES
    signal PC   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- Compteur d'instructions
   
    -- LES VALEURS POUR NOS DIFFERENTS ETAGES
    signal OP1, OP2, OP3, OP4           : STD_LOGIC_VECTOR(7 downto 0);
    signal A1,  A2,  A3,  A4            : STD_LOGIC_VECTOR(7 downto 0);
    signal B1,  B2,  B3,  B4            : STD_LOGIC_VECTOR(7 downto 0);
    signal C1,  C2                      : STD_LOGIC_VECTOR(7 downto 0);
    signal MUX_DI, MUX_EX, MUX_2_MEM    : STD_LOGIC_VECTOR(7 downto 0);
    
    -- NOS OPCODES POUR NOTRE MICROPROCESSEUR RISC
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
    
begin
    MEMI: entity work.MEMOIRE_INSTRUCTIONS
        Port map (
            ADDR    => MEMI_ADDR,
            CLK     => MEMI_CLK,
            SORTIE  => MEMI_S
            );
            
    BANCREG: entity work.BANC_REGISTRE
        Port map (
            ADDR_A => REG_ADDR_A,
            ADDR_B => REG_ADDR_B,
            ADDR_W => REG_ADDR_W,
            W      => REG_W,
            DATA   => REG_DATA,
            RST    => REG_RST,
            CLK    => REG_CLK,
            QA     => REG_QA,
            QB     => REG_QB
            );
         
    UAL: entity work.ALU_8bits
        Port map (
            A           => UAL_A,
            B           => UAL_B,
            OPCODE      => UAL_OPCODE,
            S           => UAL_S,
            CARRY       => UAL_CARRY,
            NEGATIF     => UAL_NEGATIF,
            DEPASSEMENT => UAL_DEPASSEMENT
            );
            
    MEMOIRE_DONNEES: entity work.MEMOIRE_DONNEES
           Port map (
            ADDR    => MEMD_ADDR,
            ENTREE  => MEMD_ENTREE,
            RW      => MEMD_RW,
            RST     => MEMD_RST,
            CLK     => MEMD_CLK,
            SORTIE  => MEMD_S
            );


    -----------------------------------------------
    -- Partie asynchrone --------------------------
    -----------------------------------------------

    --Synchronisation des sorties
    QA <= A4;
    QB <= B4;
    
    --Synchronisation des réinitialisations
    MEMD_RST <= RST;
    REG_RST <= RST;
    
    --Synchronisation des horloges
    REG_CLK <= CLK;
    MEMD_CLK <= CLK;
    MEMI_CLK <= CLK;

    --Etage 2 : DI / Decodage d'instructions
    MUX_DI <= B1 when (OP1 = AFC) OR (OP1 = CRD) ELSE REG_QA;
    REG_ADDR_A <= B1(3 downto 0);
    REG_ADDR_B <= C1(3 downto 0);
    
    --Etage 3 : EX / Execution d'instructions
    MUX_EX <= UAL_S when (OP2 = AJ) OR (OP2 = MUL) OR (OP2 = SOU) OR (OP2 = ET) OR (OP2 = OU )OR (OP2 = OUX) OR (OP2 = NON) else B2;
    UAL_OPCODE <= OP2;
    UAL_A <= B2;
    UAL_B <= C2;
    
    --Etage 4 : MEM / Stockage ou chargement de la memoire
    MEMD_ENTREE <= B3;
    MEMD_ADDR <= A3 when (OP3 = SRD) else B3; -- MUX_1_MEM
    MUX_2_MEM <= B3; 
    MEMD_RW <= '0' when (OP3 = SRD) else '1'; -- LC MEM. On recupère les données de la memoire de données.
  
    -----------------------------------------------
    -- Partie synchrone ---------------------------
    -----------------------------------------------
    
    main : process(CLK)
    begin
        if rising_edge(CLK) then
            
            -- ETAGE 1 - LI
            -- Gestion des aléas
            if (
                (MEMI_S(31 downto 24) = AJ)  OR
                (MEMI_S(31 downto 24) = MUL) OR
                (MEMI_S(31 downto 24) = SOU) OR
                (MEMI_S(31 downto 24) = ET)  OR
                (MEMI_S(31 downto 24) = OU)  OR
                (MEMI_S(31 downto 24) = OUX) OR
                (MEMI_S(31 downto 24) = NON) OR
                (MEMI_S(31 downto 24) = COP)
                ) then
                if (((OP1 = AJ)  OR
                    (OP1 = MUL)  OR
                    (OP1 = SOU)  OR
                    (OP1 = ET)   OR
                    (OP1 = OU)   OR
                    (OP1 = OUX)  OR
                    (OP1 = AFC)  OR                     
                    (OP1 = COP)  OR             
                    (OP1 = NON)) AND 
                    (A1 = MEMI_S(15 downto 8) OR A1 = MEMI_S(7  downto 0)))-- Si A = B ou A = C
                    then  -- S'il y a d'aléa, alors on met le programme en halte.
                        OP1 <= x"00";
                        A1 <= x"00";
                        B1 <= x"00";
                        C1 <= x"00";  
                elsif (((OP2 = AJ) OR
                    (OP2 = MUL)  OR
                    (OP2 = SOU)  OR
                    (OP2 = ET)   OR
                    (OP2 = OU)   OR
                    (OP2 = OUX)  OR
                    (OP2 = AFC)  OR
                    (OP2 = COP)  OR
                    (OP2 = NON)) AND 
                    (A2 = MEMI_S(15 downto 8) OR A2 = MEMI_S(7 downto 0))) 
                    then --Cas où un aléa se fait dans le deuxième etage
                        OP1 <= x"00";
                        A1 <= x"00";
                        B1 <= x"00";
                        C1 <= x"00";
                elsif (((OP3 = AJ) OR
                    (OP3 = MUL)  OR
                    (OP3 = SOU)  OR
                    (OP3 = ET)   OR
                    (OP3 = OU)   OR
                    (OP3 = OUX)  OR
                    (OP3 = AFC)  OR
                    (OP3 = COP)  OR
                    (OP3 = NON)) AND
                    (A3 = MEMI_S(15 downto 8) OR A3 = MEMI_S(7 downto 0)))
                    then --Cas où un aléa se fait dans le troisième etage
                        OP1 <= x"00";
                        A1 <= x"00";
                        B1 <= x"00";
                        C1 <= x"00";
                elsif (((OP4 = AJ) OR
                    (OP4 = MUL)  OR
                    (OP4 = SOU)  OR
                    (OP4 = ET)   OR
                    (OP4 = OU)   OR
                    (OP4 = OUX)  OR
                    (OP4 = AFC)  OR
                    (OP4 = COP)  OR
                    (OP4 = NON)) AND 
                    ( A4 = MEMI_S(15 downto 8) OR A4 = MEMI_S(7 downto 0))) -- Si A = B ou A = C
                    then --Cas où un aléa se fait dans le quatrième etage
                        OP1 <= x"00";
                        A1 <= x"00";
                        B1 <= x"00";
                        C1 <= x"00";
                else
                    A1 <= MEMI_S(23 downto 16);
                    OP1 <= MEMI_S(31 downto 24);
                    B1 <= MEMI_S(15 downto 8);
                    C1 <= MEMI_S(7 downto 0);
                    
                    MEMI_ADDR <= PC; -- S'il n'y a pas d'aléa alors nous mettons PC comme adresse dans la memoire d'instruction.
                    if (UNSIGNED(PC) < 63) then
                        PC <= STD_LOGIC_VECTOR(UNSIGNED(PC) + 1); -- On increment PC comme maintenant il va prendre la prochaine @ de la memoire d'inst.
                    else 
                        PC <= (others => '0');
                    end if;
                end if;
            else
                    A1 <= MEMI_S(23 downto 16);
                    OP1 <= MEMI_S(31 downto 24);
                    B1 <= MEMI_S(15 downto 8);
                    C1 <= MEMI_S(7 downto 0);
                    
                    MEMI_ADDR <= PC; 
                    if (UNSIGNED(PC) < 63) then
                        PC <= STD_LOGIC_VECTOR(UNSIGNED(PC) + 1); 
                    else 
                        PC <= (others => '0');
                    end if;
            end if;
        
            -- Etage 2: DI / Decodage d'instructions
            A2 <= A1;
            OP2 <= OP1;
            C2 <= REG_QB;
            B2 <= MUX_DI;
            
            -- ETAGE 3 - EX / Execution d'instructions
            A3 <= A2;
            OP3 <= OP2;
            B3 <= MUX_EX;
            
            -- ETAGE 4 - MEM / Stockage ou chargement de la memoire
            A4 <= A3;
            OP4 <= OP3;
            if (OP3 = CRD) then
                B4 <= MEMD_S;
            else
                B4 <= MUX_2_MEM;
            end if;
            
            -- ETAGE 5 - RE / Re-écriture
            if ((OP4 = AJ) OR (OP4 = MUL) OR (OP4 = SOU) OR (OP4 = ET) OR (OP4 = OU) OR (OP4 = OUX) OR (OP4 = NON) OR (OP4 = COP) OR (OP4 = AFC) OR (OP4 = CRD)) then
                REG_W <= '1';
            else 
                REG_W <= '0';
            end if;
            REG_DATA <= B4;
            REG_ADDR_W <= A4(3 downto 0);
        end if;
        
    end process; 
end Behavioral;


