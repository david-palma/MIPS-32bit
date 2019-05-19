-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module: Shift left from 26 to 28 bit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft2 is
  port( -- input
        input  : in std_logic_vector(25 downto 0);

        -- output
        output : out std_logic_vector(27 downto 0) );
end ShiftLeft2;

architecture Behavioral of ShiftLeft2 is
begin

  output <= input & "00";

end Behavioral;
