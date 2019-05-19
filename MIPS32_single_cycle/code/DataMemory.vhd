-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 single cycle
-- Module: DataMemory

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
  GENERIC(n : integer := 32);
  port( -- inputs
        CLK            : in std_logic;
        reset_neg      : in std_logic;
        memory_address : in std_logic_vector(n - 1 downto 0);
        MemWrite       : in std_logic;
        MemRead        : in std_logic;
        data_in        : in std_logic_vector(n - 1 downto 0);

        -- output
        data_out       : out std_logic_vector(n - 1 downto 0) );
end DataMemory;

architecture Behavioral of DataMemory is
  type mem_type is array  (127 downto 0) of std_logic_vector(n - 1 downto 0); -- should be 2^30 words
  signal mem: mem_type;

begin

  process(CLK, reset_neg)
  begin
  if reset_neg = '0' then
    mem <= (others => (others=>'0'));
  elsif rising_edge(CLK) and MemWrite = '1' then
    mem(to_integer(unsigned(memory_address))) <= data_in;
  end if;
  end process;

    data_out <= (mem(to_integer(unsigned(memory_address)))) when MemRead = '1' else (others => '0');

end Behavioral;
