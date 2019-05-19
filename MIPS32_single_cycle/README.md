# 32-bit single-cycle MIPS processor

This is a 32-bit implementation of a single-cycle MIPS processor in VHDL.
In particular, the present version of the processor includes the control unit and every functional unit of the datapath (PC, register file, ALU, instruction memory, data memory, adders, MUXs, shifters, sign-extender) as well as the test bench used to check the functional correctness of the DUT.

<p align="center"><img src="./MIPS32_single-cycle_diagram.png" width="700px"></img><p>

In a single-cycle implementation, a clock cycle must have the same length for every instruction and therefore it is determined by the longest possible path (load word).
This is an issue that can be sidestepped using a multi-cycle implementation (see [32-bit multi-cycle MIPS processor](https://github.com/david-palma//MIPS-32bit/MIPS32_multi_cycle) repository).

## Executable instructions

The processor is able to execute the following subset of the original MIPS instruction set:

* register arithmetic-logical instructions (**add**, **sub**, **and**, **or**, **nor**, and **xor**),
* immediate arithmetic-logical instructions (**addi**, **andi**, and **ori**),
* shift instructions (**sll** and **srl**),
* set instructions (**slt** and **slti**),
* branch and jump instructions (**beq**, **bne**, and **j**),
* memory instructions (**lw** and **sw**).

### Note

The instruction memory module contains some initial values representing a test program, though it is possible to define your own program instructions (see the [MIPS32 instruction encoder](https://github.com/david-palma//MIPS-32bit/MIPS32_encoder) repository).

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/david-palma/MIPS-32bit/LICENSE) file for details.
