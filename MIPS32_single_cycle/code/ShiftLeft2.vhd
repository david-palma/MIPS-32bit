-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 single cycle
-- Module: ShiftLeft2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft2 is
  port( -- input
        input  : in std_logic_vector(31 downto 0);

        -- output
        output : out std_logic_vector(31 downto 0) );
end ShiftLeft2;

architecture Behavioral of ShiftLeft2 is
begin

  output <= std_logic_vector(unsigned(input) sll 2);

end Behavioral;
