-- Utiliza apenas as bibliotecas padrão e obrigatórias.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- ----------------------------------------------------------------
-- Definição do Componente Base: Flip-Flop JK
-- ----------------------------------------------------------------
ENTITY FF_JK IS
    PORT (
        J, K : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        clr  : IN STD_LOGIC;
        pre  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC
    );
END ENTITY FF_JK;

ARCHITECTURE mem OF FF_JK IS
    SIGNAL qs : STD_LOGIC;
BEGIN
    PROCESS (clk, clr, pre)
    BEGIN
        IF pre = '0' THEN
            qs <= '1';
        ELSIF clr = '0' THEN
            qs <= '0';
        ELSIF clk'EVENT AND clk = '1' THEN
            IF J = '1' AND K = '0' THEN
                qs <= '1';
            ELSIF J = '0' AND K = '1' THEN
                qs <= '0';
            ELSIF J = '1' AND K = '1' THEN
                qs <= NOT qs;
            END IF;
        END IF;
    END PROCESS;

    Q <= qs;
END ARCHITECTURE mem;


-- ----------------------------------------------------------------
-- Definição da Entidade Principal: Contador Módulo 5
-- ----------------------------------------------------------------
ENTITY ContadorMod5 IS
    PORT (
        CLOCK   : IN STD_LOGIC;
        CLEAR_N : IN STD_LOGIC;
        Q_OUT   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY ContadorMod5;

ARCHITECTURE Structural OF ContadorMod5 IS

    -- Declaração do componente a ser utilizado
    COMPONENT FF_JK IS
        PORT (
            J, K : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            clr  : IN STD_LOGIC;
            pre  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Sinais internos para conectar os componentes
    SIGNAL q_A, q_B, q_C       : STD_LOGIC;
    SIGNAL q_C_n               : STD_LOGIC;
    SIGNAL j_A, k_A, j_B, k_B, j_C, k_C : STD_LOGIC;

BEGIN

    -- Lógica combinacional para as entradas dos Flip-Flops
    q_C_n <= NOT q_C;
    
    j_A <= q_B AND q_C;
    k_A <= q_A;
    
    j_B <= q_C_n;
    k_B <= q_B;
    
    j_C <= '1';
    k_C <= q_A AND q_B;

    -- Instanciação dos três Flip-Flops
    FFA: FF_JK PORT MAP (
        J => j_A, K => k_A, clk => CLOCK, clr => CLEAR_N, pre => '1', Q => q_A
    );

    FFB: FF_JK PORT MAP (
        J => j_B, K => k_B, clk => CLOCK, clr => CLEAR_N, pre => '1', Q => q_B
    );

    FFC: FF_JK PORT MAP (
        J => j_C, K => k_C, clk => CLOCK, clr => CLEAR_N, pre => '1', Q => q_C
    );

    -- Conexão das saídas internas para a porta de saída do módulo
    Q_OUT(2) <= q_C;
    Q_OUT(1) <= q_B;
    Q_OUT(0) <= q_A;

END ARCHITECTURE Structural;