-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module:  Temporary registers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TempRegisters is
  port( -- input
        CLK         : in std_logic;
        reset_neg   : in std_logic;
        in_reg_A    : in std_logic_vector (31 downto 0);
        in_reg_B    : in std_logic_vector (31 downto 0);
        in_ALU_out  : in std_logic_vector (31 downto 0);

        -- output
        out_reg_A   : out std_logic_vector(31 downto 0);
        out_reg_B   : out std_logic_vector(31 downto 0);
        out_ALU_out : out std_logic_vector(31 downto 0) );
end TempRegisters;

architecture Behavioral of TempRegisters is
  type registers is array (0 to 2) of std_logic_vector(31 downto 0);
  signal data : registers := ((others => (others => '0')));

begin
  process(CLK)
  begin
    if reset_neg = '0' then -- reset
      data <= ((others => (others => '0')));
    else if rising_edge(CLK) then
      data(0) <= in_reg_A;
      data(1) <= in_reg_B;
      data(2) <= in_ALU_out;
    end if;
    end if;
  end process;

  out_reg_A   <= data(0);
  out_reg_B   <= data(1);
  out_ALU_out <= data(2);

end  Behavioral;
