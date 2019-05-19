-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 single cycle
-- Module: TopLevel

library ieee;
use ieee.std_logic_1164.all;


entity TopLevel is
GENERIC (n : integer := 32);

port( CLK, reset_neg : in std_logic );

end TopLevel;

architecture Behavioral of TopLevel is

component ControlUnit is
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
end component;

component DataPath is
port( -- inputs
CLK, reset_neg    : in std_logic;
instruction       : in std_logic_vector(31 downto 0);
-- control signals
RegDst            : in std_logic;
Jump              : in std_logic;
Branch            : in std_logic;
MemRead           : in std_logic;
MemToReg          : in std_logic;
ALUOp             : in std_logic_vector(3 downto 0);
MemWrite          : in std_logic;
ALUSrc            : in std_logic;
RegWrite          : in std_logic;

-- outputs
next_instruction  : out std_logic_vector(31 downto 0);
ZeroCarry         : out std_logic );
end component;

component InstructionMemory is
port( -- input
register_addr : in  std_logic_vector(31 downto 0);

-- output
instruction   : out std_logic_vector(31 downto 0) );
end component;

signal RegDst_TL, Jump_TL, Branch_TL, MemRead_TL, MemToReg_TL : std_logic;
signal MemWrite_TL, ALUSrc_TL, RegWrite_TL , ZeroCarry_TL : std_logic;
signal ALUOp_TL : std_logic_vector(3 downto 0);
signal NextInstruction, instr : std_logic_vector(31 downto 0);

begin
CU : ControlUnit  port map( instr,
ZeroCarry_TL,
RegDst_TL,
Jump_TL,
Branch_TL,
MemRead_TL,
MemToReg_TL,
ALUOp_TL,
MemWrite_TL,
ALUSrc_TL,
RegWrite_TL );

DP : DataPath     port map( CLK,
reset_neg,
instr,
RegDst_TL,
Jump_TL,
Branch_TL,
MemRead_TL,
MemToReg_TL,
ALUOp_TL,
MemWrite_TL,
ALUSrc_TL,
RegWrite_TL,
NextInstruction,
ZeroCarry_TL );


I  : InstructionMemory  port map( NextInstruction, instr );
end Behavioral;
