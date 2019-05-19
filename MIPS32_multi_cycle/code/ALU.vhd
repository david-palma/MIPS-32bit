-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module: ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  GENERIC(n : integer := 32);
  port( -- input
        operand_1   : in std_logic_vector(31 downto 0);
        operand_2   : in std_logic_vector(31 downto 0);
        ALU_control : in std_logic_vector(3 downto 0);  -- 12 operations

        -- output
        result      : out std_logic_vector(31 downto 0);
        zero        : out std_logic );
end ALU;

architecture Behavioral of ALU is
  signal temp : std_logic_vector(31 downto 0);

begin

  temp <=
    -- add
    std_logic_vector(unsigned(operand_1) + unsigned(operand_2)) when ALU_control = "0000" else
    -- subtract
    std_logic_vector(unsigned(operand_1) + unsigned(operand_2)) when ALU_control = "0001" else
    -- AND
    operand_1 AND  operand_2 when ALU_control = "0010" else
    -- OR
    operand_1 OR   operand_2 when ALU_control = "0011" else
    -- NOR
    operand_1 NOR  operand_2 when ALU_control = "0100" else
    -- NAND
    operand_1 NAND operand_2 when ALU_control = "0101" else
    -- XOR
    operand_1 XOR  operand_2 when ALU_control = "0110" else
    -- shift left logical
    std_logic_vector(shift_left(unsigned(operand_1), to_integer(unsigned(operand_2(10 downto 6))))) when ALU_control = "0111" else
    -- shift right logical
    std_logic_vector(shift_right(unsigned(operand_1), to_integer(unsigned(operand_2(10 downto 6))))) when ALU_control = "1000" else
    -- in other cases
    (others => '0');

  zero <= '1' when temp <= "00000000000000000000000000000000" else '0';
  result <= temp;

end Behavioral;
