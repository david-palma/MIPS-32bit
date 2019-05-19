-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 single cycle
-- Module: Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
  GENERIC(n : integer := 32);
  port( -- input
        operand_1 : in  std_logic_vector(n - 1 downto 0);
        operand_2 : in  std_logic_vector(n - 1 downto 0);

        -- output
        result    : out std_logic_vector(n - 1 downto 0) );
end Adder;

architecture Behavioral of Adder is
begin

  result <= std_logic_vector(unsigned(operand_1) + unsigned(operand_2));

end Behavioral;
