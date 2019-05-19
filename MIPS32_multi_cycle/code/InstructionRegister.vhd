-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module:  Instruction register

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionRegister is
  GENERIC(n : integer := 32);
  port( -- input
        CLK             : in std_logic;
        reset_neg       : in std_logic;
        IRWrite         : in std_logic;
        in_instruction  : in std_logic_vector(31 downto 0);

        -- output
        out_instruction : out std_logic_vector(31 downto 0) );
end InstructionRegister;

architecture Behavioral of InstructionRegister is
  type instr_reg_type is array (0 to 0) of std_logic_vector(31 downto 0);
  signal instr_reg : instr_reg_type := ((others => (others => '0')));

begin
  process(CLK)
  begin
    if reset_neg = '0' then -- reset
      instr_reg(0) <= (others => '0');
    else if rising_edge(CLK) and IRWrite = '1' then
      instr_reg(0) <= in_instruction;
    end if;
    end if;
  end process;

  out_instruction <= instr_reg(0);  -- instruction

end Behavioral;
