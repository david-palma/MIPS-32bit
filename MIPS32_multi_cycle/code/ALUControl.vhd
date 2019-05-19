-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module:  ALU control

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUControl is
  port( -- input
        ALUOp   : in std_logic_vector(1 downto 0);
        instr   : in std_logic_vector(5 downto 0);

        -- output
        result      : out std_logic_vector(3 downto 0) );
end ALUControl;

architecture Behavioral of ALUControl is
  signal temp, operation : std_logic_vector(3 downto 0) := "1111";

begin

  with ALUOp select
    temp <= "0000"    when "00",    -- addi for LW
            "0110"    when "01",    -- subi for Branch
            operation when "10",    -- R-type
            "1111"    when others;  -- in other cases

  with instr select
    operation <= "0000" when "100000", -- add
                 "0001" when "100010", -- subtract
                 "0010" when "100100", -- AND
                 "0011" when "100101", -- OR
                 "0100" when "100111", -- NOR
                 "0101" when "100110", -- XOR
                 "0110" when "000000", -- shift left logical
                 "0111" when "000010", -- shift right logical
                 "1000" when "101010", -- set on less than
                 "1001" when "001000", -- add immediate
                 "1010" when "001100", -- AND immediate
                 "1011" when "001101", -- OR immediate
                 "1111" when others;

  result <= temp;

end Behavioral;
