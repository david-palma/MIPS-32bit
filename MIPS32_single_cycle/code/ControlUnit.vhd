-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 single cycle
-- Module: ControlUnit

library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
  port( -- input
        instruction : in std_logic_vector(31 downto 0);
        ZeroCarry   : in std_logic;

        -- output (control signals)
        RegDst      : out std_logic;
        Jump        : out std_logic;
        Branch      : out std_logic;
        MemRead     : out std_logic;
        MemToReg    : out std_logic;
        ALUOp       : out std_logic_vector (3 downto 0);  -- 9 operations
        MemWrite    : out std_logic;
        ALUSrc      : out std_logic;
        RegWrite    : out std_logic );
end ControlUnit;

architecture Behavioral of ControlUnit is
  signal data : std_logic_vector(11 downto 0);  -- used to set the control signals

begin
  -- in according to the standard MIPS32 instruction reference
  -- add
  data <= "100000000001" when (instruction(31 downto 26) = "000000" and
                               instruction(10 downto 0)  = "00000100000") else
  -- subtract
  "100000001001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100010") else
  -- AND
  "100000010001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100100") else
  -- OR
  "100000011001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100101") else
  -- NOR
  "100000100001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100111") else
  -- XOR
  "100000110001" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "100110") else
  -- shift left logical
  "100000111011" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "000000") else
  -- shift right logical
  "100001000011" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "000010") else
  -- set on less than
  "100001001001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000101010") else
  -- add immediate
  "000000000011" when instruction(31 downto 26) = "001000" else
  -- load word
  "000110000011" when instruction(31 downto 26) = "100011" else
  -- store word
  "000000000110" when instruction(31 downto 26) = "101011" else
  -- AND immediate
  "000000010011" when instruction(31 downto 26) = "001100" else
  -- OR immediate
  "000000011011" when instruction(31 downto 26) = "001101" else
  -- branch on equal
  "001000001000" when instruction(31 downto 26) = "000100" else
  -- branch on not equal
  "001000110010" when instruction(31 downto 26) = "000101" else
  -- set less than immediate
  "000001001011" when instruction(31 downto 26) = "001010" else
  -- jump
  "010000000000" when instruction(31 downto 26) = "000010" else
  -- otherwise
  (others =>'0');

  RegDst   <= data(11);
  Jump     <= data(10);
  -- AND port included considering the LSB of beq and bne
  Branch   <= data(9) AND (ZeroCarry XOR instruction(26));
  MemRead  <= data(8);
  MemToReg <= data(7);
  ALUOp    <= data(6 downto 3);  -- 9 operations available
  MemWrite <= data(2);
  ALUSrc   <= data(1);
  RegWrite <= data(0);

end Behavioral;
