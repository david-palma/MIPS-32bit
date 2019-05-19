-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module:  Mux 3 inputs 32 bit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux3 is
  port( -- input
        input_1    : in std_logic_vector(31 downto 0);
        input_2    : in std_logic_vector(31 downto 0);
        input_3    : in std_logic_vector(31 downto 0);
        mux_select : in std_logic_vector(1 downto 0);

        -- output
        output     : out std_logic_vector(31 downto 0) );
end Mux3;

architecture Behavioral of Mux3 is

  signal mux_out : std_logic_vector(31 downto 0);
begin
  with mux_select select
    mux_out <= input_1 when "00",
               input_2 when "01",
               input_3 when "10",
               "00000000000000000000000000000000" when others;
  output <= mux_out;
end Behavioral;
