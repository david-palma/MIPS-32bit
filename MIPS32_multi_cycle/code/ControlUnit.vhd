-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module:  Control unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
  port( -- input
        CLK         : in std_logic;
        Reset       : in std_logic;
        Op          : in std_logic_vector(5 downto 0);

        -- output (control signals)
        PCWriteCond : out std_logic;
        PCWrite     : out std_logic;
        IorD        : out std_logic;
        MemRead     : out std_logic;
        MemWrite    : out std_logic;
        MemToReg    : out std_logic;
        IRWrite     : out std_logic;
        PCSource    : out std_logic_vector(1 downto 0);
        ALUOp       : out std_logic_vector(1 downto 0);
        ALUSrcB     : out std_logic_vector(1 downto 0);
        ALUSrcA     : out std_logic;
        RegWrite    : out std_logic;
        RegDst      : out std_logic );
end ControlUnit;

architecture Behavioral of ControlUnit is

  type state is( InstructionFetch,
                 InstructionDecode,
                 MemoryAddressComp,
                 Execution,
                 Execution_I,
                 BranchCompletion,
                 JumpCompletion,
                 MemoryAccessLoad,
                 MemoryAccessStore,
                 RTypeCompletion,
                 RTypeCompletion_I,
                 MemoryReadCompletionStep );

  signal current_state, next_state : state;
  signal ctrl_state : std_logic_vector(15 downto 0) := (others => '0');

begin

  process(CLK, Reset, Op)
  begin
    if Reset = '0' then
      current_state <= InstructionFetch;
    elsif rising_edge(CLK) then
      current_state <= next_state;
    end if;

    case current_state is

      when InstructionFetch  => next_state <= InstructionDecode;

      when InstructionDecode => if Op = "100011" then -- lw
                                  next_state <= MemoryAddressComp;
                                elsif Op = "101011" then -- sw
                                  next_state <= MemoryAddressComp;
                                elsif Op = "000000" then -- R-type
                                  next_state <= Execution;
                                elsif Op = "001000" then -- immediate
                                  next_state <= Execution_I;
                                elsif Op = "000100" then -- BEQ
                                  next_state <= BranchCompletion;
                                elsif Op = "000010" then -- Jump
                                  next_state <= JumpCompletion;
                                end if;

      when MemoryAddressComp => if Op = "100011" then -- lw
                                  next_state <= MemoryAccessLoad;
                                else  -- sw
                                  next_state <= MemoryAccessStore;
                                end if;

      when Execution         => next_state <= RTypeCompletion;

      when Execution_I       => next_state <= RTypeCompletion_I;

      when MemoryAccessLoad  => next_state <= MemoryReadCompletionStep;

      when MemoryAccessStore => next_state <= InstructionFetch;

      when BranchCompletion  => next_state <= InstructionFetch;

      when JumpCompletion    => next_state <= InstructionFetch;

      when RTypeCompletion   => next_state <= InstructionFetch;

      when others            => next_state <= InstructionFetch;

    end case;
  end process;

  with current_state select
    ctrl_state <= "1001001000001000" when InstructionFetch,
                  "0000000000011000" when InstructionDecode,
                  "0000000000010100" when MemoryAddressComp,
                  "0000000001000100" when Execution,
                  "0000000000010100" when Execution_I,
                  "0100000010100100" when BranchCompletion,
                  "1000000100000000" when JumpCompletion,
                  "0011000000000000" when MemoryAccessLoad,
                  "0010100000000000" when MemoryAccessStore,
                  "0000000000000011" when RTypeCompletion,
                  "0000000000000010" when RTypeCompletion_I,
                  "0000010000000010" when MemoryReadCompletionStep,
                  "0000000000000000" when others;

  PCWrite     <= ctrl_state(15);
  PCWriteCond <= ctrl_state(14);
  IorD        <= ctrl_state(13);
  MemRead     <= ctrl_state(12);
  MemWrite    <= ctrl_state(11);
  MemToReg    <= ctrl_state(10);
  IRWrite     <= ctrl_state(9);
  PCSource    <= ctrl_state(8 downto 7);
  ALUOp       <= ctrl_state(6 downto 5);
  ALUSrcB     <= ctrl_state(4 downto 3);
  ALUSrcA     <= ctrl_state(2);
  RegWrite    <= ctrl_state(1);
  RegDst      <= ctrl_state(0);

end Behavioral;
