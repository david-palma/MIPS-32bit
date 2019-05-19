-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 single cycle
-- Module: Mux

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux is
  GENERIC(n : integer := 32);
  port( -- input
        input_1    : in std_logic_vector(n - 1 downto 0);
        input_2    : in std_logic_vector(n - 1 downto 0);
        mux_select : in std_logic;

        -- output
        output     : out std_logic_vector(n - 1 downto 0) );
end Mux;

architecture Behavioral of Mux is
begin
with mux_select select
  output <= input_1 when '0', input_2 when others;

end Behavioral;
