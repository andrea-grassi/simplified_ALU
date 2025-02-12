-- File: alu.vhdl

-- Grassi Andrea
-- Simplified ALU project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calculator is
-- Constant fixed values
generic (
    WIDTH     : integer := 16; -- Width for vectors
    SIG_WIDTH : integer := 4 -- Width for signals
);
-- Definition signals of the entity
Port (
    in1      : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    in2      : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    result   : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    sig      : in STD_LOGIC_VECTOR(SIG_WIDTH - 1 downto 0);
    overflow : out STD_LOGIC
);
end calculator;

architecture behavioral of calculator is
-- Temp var for result of operations
signal temp_result: signed(WIDTH downto 0);
-- Additional signal for multiplication to handle wider result
signal mult_result: signed((2 * WIDTH) - 1 downto 0) := (others => '0');

begin
-- Sensitivity check list
process(sig, in1, in2, temp_result, mult_result)
begin
-- Default value for overflow to 0
    overflow <= '0';
-- Case to chose the right operation to do
case to_integer(unsigned(sig)) is
    when 0 => -- Case "+"
        temp_result <= signed('0' & in1) + signed('0' & in2);
        -- Control overflow for addition
        if (in1(WIDTH - 1) = in2(WIDTH - 1)) and -- Same sign operands
            (in1(WIDTH - 1) /= temp_result(WIDTH - 1)) then -- Different result sign from result MSB
            overflow <= '1';
            result <= (others => '0'); -- With an overflow, by choice, result = 0
        else
            result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
        end if;
    
    when 1 => -- Case "-"
        temp_result <= signed('0' & in1) - signed('0' & in2);
        -- Control overflow for subtraction
        if (in1(WIDTH - 1) /= in2(WIDTH - 1)) and ( -- Different sign operands
            (in1(WIDTH - 1) /= temp_result(WIDTH - 1)) or (
            in2(WIDTH - 1) /= temp_result(WIDTH - 1))) then -- Result sign MSB differs from operand
            overflow <= '1';
            result <= (others => '0');
        else
            result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
        end if;
    
    when 2 => -- Case AND
        temp_result <= signed('0' & (in1 and in2));
        result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
    
    when 3 => -- Case OR
        temp_result <= signed('0' & (in1 or in2)); -- Fixed the OR operation
        result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
    
    when 4 => -- Case NOT in1
        temp_result <= signed('0' & (not in1));
        result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
    
    when 5 => -- Case NOT in2
        temp_result <= signed('0' & (not in2));
        result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
    
    when 6 => -- Case XOR
        temp_result <= signed('0' & (in1 xor in2));
        result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
    
    when 7 => -- Case Right Shift (dx)
        temp_result <= signed('0' & std_logic_vector(shift_right(unsigned(in1), to_integer(unsigned(in2)))));
        result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
    
    when 8 => -- Case Left Shift (sx)
        temp_result <= signed('0' & std_logic_vector(shift_left(unsigned(in1), to_integer(unsigned(in2)))));
        result <= std_logic_vector(temp_result(WIDTH - 1 downto 0));
    
    when 9 => -- Case Multiplication
        mult_result <= signed(in1) * signed(in2);
        -- Check for overflow (if result doesn't fit in WIDTH bits)
        if (mult_result > (2**(WIDTH-1) - 1)) or (mult_result < -(2**(WIDTH-1))) then
            overflow <= '1';
            result <= (others => '0');
        else
            result <= std_logic_vector(mult_result(WIDTH-1 downto 0));
        end if;
        
    when others => -- Default case, by choice, sets result = 0
        temp_result <= (others => '0');
        result <= (others => '0');

end case;
end process;
end behavioral;