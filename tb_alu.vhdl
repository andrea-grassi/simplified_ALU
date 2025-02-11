library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu is
end tb_alu;

architecture testbench of tb_alu is
    -- Constant fixed values
    constant WIDTH     : integer := 16;
    constant SIG_WIDTH : integer := 4;
    constant DELAY     : time := 10 ns; -- delay between operations

    -- Component declaration for the Unit Under Test (UUT)
    component calculator
        Port(
            in1      : in  STD_LOGIC_VECTOR(WIDTH - 1     downto 0);
            in2      : in  STD_LOGIC_VECTOR(WIDTH - 1     downto 0);
            sig      : in  STD_LOGIC_VECTOR(SIG_WIDTH - 1 downto 0);
            result   : out STD_LOGIC_VECTOR(WIDTH - 1     downto 0);
            overflow : out STD_LOGIC
        );
    end component;

    -- Internal tb signals to connect to the UUT
    signal in1_tb      : STD_LOGIC_VECTOR(WIDTH - 1     downto 0);
    signal in2_tb      : STD_LOGIC_VECTOR(WIDTH - 1     downto 0);
    signal sig_tb      : STD_LOGIC_VECTOR(SIG_WIDTH - 1 downto 0);
    signal result_tb   : STD_LOGIC_VECTOR(WIDTH - 1     downto 0);
    signal overflow_tb : STD_LOGIC;

begin

    -- Unit Under Test (UUT)
    uut: calculator
        Port map (
            in1      => in1_tb,
            in2      => in2_tb,
            sig      => sig_tb,
            result   => result_tb,
            overflow => overflow_tb
        );

    -- Stimulus process
    stim_proc: process
    begin

        -- Addition, zero problemi result = 5
        in1_tb <= std_logic_vector(to_signed(2, 16));
        in2_tb <= std_logic_vector(to_signed(3, 16));
        sig_tb <= "0000"; -- "+"
        wait for DELAY;

        -- Addition with in2 negative number and negative result = -1
        in1_tb <= std_logic_vector(to_signed(4, 16));
        in2_tb <= std_logic_vector(to_signed(-5, 16));
        sig_tb <= "0000"; -- "+"
        wait for DELAY;

        -- Subtraction in1 negative and in2 positive, overflow and result = 0
        in1_tb <= std_logic_vector(to_signed(-32500, 16));
        in2_tb <= std_logic_vector(to_signed(1403, 16));
        sig_tb <= "0001"; -- "-"
        wait for DELAY;
        
        -- Addition with in1 negative number and in2 positive, negative result = -2
        in1_tb <= std_logic_vector(to_signed(-22, 16));
        in2_tb <= std_logic_vector(to_signed(20, 16));
        sig_tb <= "0000"; -- "+"
        wait for DELAY;

        -- Subtraction with in2 negative number and in1 positive, negative result = -4
        in1_tb <= std_logic_vector(to_signed(8, 16));
        in2_tb <= std_logic_vector(to_signed(-12, 16));
        sig_tb <= "0001"; -- "-"
        wait for DELAY;

        -- Subtraction positive numbers and result = 2538
        in1_tb <= std_logic_vector(to_signed(5643, 16));
        in2_tb <= std_logic_vector(to_signed(3105, 16));
        sig_tb <= "0001"; -- "-"
        wait for DELAY;

        -- Addition positive numbers, overflow and result = 0
        in1_tb <= std_logic_vector(to_signed(32000, 16));
        in2_tb <= std_logic_vector(to_signed(1000, 16));
        sig_tb <= "0000"; -- "-"
        wait for DELAY;

        -- AND operation with result = 12
        in1_tb <= std_logic_vector(to_signed(28, 16));
        in2_tb <= std_logic_vector(to_signed(13, 16));
        sig_tb <= "0010"; -- "AND"
        wait for DELAY;

        -- OR operation with result = 9
        in1_tb <= std_logic_vector(to_signed(25, 16));
        in2_tb <= std_logic_vector(to_signed(13, 16));
        sig_tb <= "0011"; -- "OR"
        wait for DELAY;

        -- NOT operation on in1, result is inverse of 25 --> -26
        in1_tb <= std_logic_vector(to_signed(25, 16));
        sig_tb <= "0100"; -- "NOT"
        wait for DELAY;

        -- NOT operation on in2, result is inverse of -14 --> -13
        in2_tb <= std_logic_vector(to_signed(-14, 16));
        sig_tb <= "0100"; -- "NOT"
        wait for DELAY;

        -- XOR operation with result = 17
        in1_tb <= std_logic_vector(to_signed(28, 16));
        in2_tb <= std_logic_vector(to_signed(13, 16));
        sig_tb <= "0101"; -- "XOR"
        wait for DELAY;

        -- AND with all bits set with result = - 1
        in1_tb <= std_logic_vector(to_signed(-1, 16));
        in2_tb <= std_logic_vector(to_signed(-1, 16));
        sig_tb <= "0010"; -- "AND"
        wait for DELAY;

        -- OR with alternating bits
        in1_tb <= std_logic_vector(to_signed(21845, 16));
        in2_tb <= std_logic_vector(to_signed(-21846, 16));
        sig_tb <= "0011"; -- "OR"
        wait for DELAY;
        
        wait;
    end process;

end testbench;