-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module: Top level

library ieee;
use ieee.std_logic_1164.all;

entity TopLevel is
  port( CLK, reset_neg : in std_logic );
end TopLevel;

architecture Behavioral of TopLevel is

component ALU is
  port( -- input
        operand_1   : in std_logic_vector(31 downto 0);
        operand_2   : in std_logic_vector(31 downto 0);
        ALU_control : in std_logic_vector(3 downto 0);  -- 12 operations

        -- output
        result      : out std_logic_vector(31 downto 0);
        zero        : out std_logic );
end component;

component ALUControl is
  port( -- input
        ALUOp  : in std_logic_vector(1 downto 0);
        instr  : in std_logic_vector(5 downto 0);

        -- output
        result : out std_logic_vector(3 downto 0) );
end component;

component ControlUnit is
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
end component;

component InstructionRegister is
  port( -- input
        CLK             : in std_logic;
        reset_neg       : in std_logic;
        IRWrite         : in std_logic;
        in_instruction  : in std_logic_vector(31 downto 0);

        -- output
        out_instruction : out std_logic_vector(31 downto 0) );
end component;

component Memory is
  port( -- inputs
        CLK       : in std_logic;
        reset_neg : in std_logic;
        address   : in std_logic_vector(31 downto 0);
        MemWrite  : in std_logic;
        MemRead   : in std_logic;
        WriteData : in std_logic_vector(31 downto 0);

        -- output
        MemData   : out std_logic_vector(31 downto 0) );
end component;

component MemoryDataRegister is
  port( -- inputs
        CLK       : in std_logic;
        reset_neg : in std_logic;
        input     : in std_logic_vector(31 downto 0);    -- from MemDataOut

        -- output
        output    : out std_logic_vector(31 downto 0) ); -- to mux
end component;

component Mux2 is
  port( -- input
        input_1     : in std_logic_vector(31 downto 0);
        input_2     : in std_logic_vector(31 downto 0);
        mux_select  : in std_logic;

        -- output
        output      : out std_logic_vector(31 downto 0) );
end component;

component Mux2_5 is
  port( -- input
        input_1     : in std_logic_vector(4 downto 0);
        input_2     : in std_logic_vector(4 downto 0);
        mux_select  : in std_logic;

        -- output
        output      : out std_logic_vector(4 downto 0) );
end component;

component Mux3 is
  port( -- input
        input_1     : in std_logic_vector(31 downto 0);
        input_2     : in std_logic_vector(31 downto 0);
        input_3     : in std_logic_vector(31 downto 0);
        mux_select  : in std_logic_vector(1 downto 0);

        -- output
        output      : out std_logic_vector(31 downto 0) );
end component;

component Mux4 is
  port( -- input
        input_1     : in std_logic_vector(31 downto 0);
        input_2     : in std_logic_vector(31 downto 0);
        input_3     : in std_logic_vector(31 downto 0);
        input_4     : in std_logic_vector(31 downto 0);
        mux_select  : in std_logic_vector(1 downto 0);

        -- output
        output      : out std_logic_vector(31 downto 0) );
end component;

component ProgramCounter is
  port( -- input
        CLK       : in  std_logic;
        reset_neg : in  std_logic;
        input     : in  std_logic_vector(31 downto 0);
        PCcontrol : in  std_logic;

        -- output
        output    : out std_logic_vector(31 downto 0) );
end component;

component Registers is
  port( -- input
        CLK          : in std_logic;
        reset_neg    : in std_logic;
        address_in_1 : in std_logic_vector(4 downto 0);
        address_in_2 : in std_logic_vector(4 downto 0);
        write_reg    : in std_logic_vector(4 downto 0);

        write_data   : in std_logic_vector(31 downto 0);
        RegWrite     : in std_logic;  -- signal control

        -- output
        register_1   : out std_logic_vector(31 downto 0);
        register_2   : out std_logic_vector(31 downto 0) );
end component;

component ShiftLeft is
  port( -- input
        input  : in std_logic_vector(31 downto 0);

        -- output
        output : out std_logic_vector(31 downto 0) );
end component;

component ShiftLeft2 is
  port( -- input
        input  : in std_logic_vector(25 downto 0);

        -- output
        output : out std_logic_vector(27 downto 0) );
end component;

component SignExtend is
  port( -- input
        input  : in std_logic_vector(15 downto 0);

        -- output
        output : out std_logic_vector(31 downto 0) );
end component;

component TempRegisters is
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
end component;

  constant PC_increment : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";

-- signals
  signal PC_out, MuxToAddress, MemDataOut, MemoryDataRegOut, InstructionRegOut, MuxToWriteData, ReadData1ToA, ReadData2ToB, RegAToMux, RegBOut, SignExtendOut, ShiftLeft1ToMux4, MuxToAlu, Mux4ToAlu, AluResultOut, AluOutToMux, JumpAddress, MuxToPC : std_logic_vector(31 downto 0);
  signal ZeroCarry_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL, PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, ANDtoOR, ORtoPC : std_logic;
  signal MuxToWriteRegister : std_logic_vector(4 downto 0);
  signal ALUControltoALU : std_logic_vector(3 downto 0);
  signal PCsource_TL, ALUSrcB_TL, ALUOp_TL : std_logic_vector(1 downto 0);

begin

  ANDtoOR <= ZeroCarry_TL and PCWriteCond_TL;
  ORtoPC <= ANDtoOR or PCWrite_TL;
  JumpAddress(31 downto 28) <= PC_out(31 downto 28);

  A_Logic_Unit : ALU                 port map(MuxToAlu, Mux4ToALU, ALUControltoALU, AluResultOut, ZeroCarry_TL);
  ALU_CONTROL  : ALUControl          port map(ALUOp_TL, InstructionRegOut(5 downto 0), ALUControltoALU);
  CTRL_UNIT    : ControlUnit         port map(CLK, reset_neg, InstructionRegOut(31 downto 26), PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, PCsource_TL, ALUOp_TL, ALUSrcB_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL);
  INSTR_REG    : InstructionRegister port map(CLK, reset_neg, IRWrite_TL, MemDataOut, InstructionRegOut);
  MEM          : Memory              port map(CLK, reset_neg, MuxToAddress, MemWrite_TL, MemRead_TL, RegBOut, MemDataOut);
  MEM_DATA_REG : MemoryDataRegister  port map(CLK, reset_neg, MemDataOut, MemoryDataRegOut);
  MUX_1        : Mux2                port map(PC_out, AluOutToMux, IorD_TL, MuxToAddress);
  MUX_2        : Mux2_5              port map(InstructionRegOut(20 downto 16), InstructionRegOut(15 downto 11), RegDst_TL, MuxToWriteRegister);
  MUX_3        : Mux2                port map(AluOutToMux, MemoryDataRegOut, MemToReg_TL, MuxToWriteData);
  MUX_4        : Mux2                port map(PC_out, RegAToMux, ALUSrcA_TL, MuxToAlu);
  MUX_5        : Mux4                port map(RegBOut, PC_increment, SignExtendOut, ShiftLeft1ToMux4, ALUSrcB_TL, Mux4ToAlu);
  MUX_6        : Mux3                port map(AluResultOut, AluOutToMux, JumpAddress, PCsource_TL, MuxToPC);
  PC           : ProgramCounter      port map(CLK, reset_neg, MuxToPC, ORtoPC, PC_out);
  REG          : Registers           port map(CLK, reset_neg, InstructionRegOut(25 downto 21), InstructionRegOut(20 downto 16), MuxToWriteRegister, MuxToWriteData, RegWrite_TL, ReadData1ToA, ReadData2ToB);
  SE           : SignExtend          port map(InstructionRegOut(15 downto 0), SignExtendOut);
  SLL1         : ShiftLeft           port map(SignExtendOut, ShiftLeft1ToMux4);
  SLL2         : ShiftLeft2          port map(InstructionRegOut(25 downto 0), JumpAddress(27 downto 0));
  TEMP_REG     : TempRegisters       port map(CLK, reset_neg, ReadData1ToA, ReadData2ToB, AluResultOut, RegAToMux, RegBOut, AluOutToMux);

end Behavioral;
