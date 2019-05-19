# 32-bit multi-cycle MIPS processor
This repository contains the 32-bit implementation of a multi-cycle MIPS processor in VHDL.
In particular, the present version of the processor includes the control unit and every functional unit of the datapath (PC, register file, ALU, instruction memory, data memory, adders, MUXs, shifters, sign-extender) as well as the test bench used to check the functional correctness of the DUT.

<p align="center"><img src="./MIPS32_multi-cycle_diagram.png" width="700px"></img><p>

The multi-cycle implementation allows a functional unit to be used more than once in a instruction, so that the number of functional units can be reduced.
This is a better implementation of the previous single-cycle version (see [32-bit single-cycle MIPS processor](https://github.com/david-palma/MIPS32_single_cycle) repository).

## Executable instructions
The processor is able to execute the following subset of the original MIPS instruction set:
* register arithmetic-logical instructions (**add**, **sub**, **and**, **or**, **nor**, and **xor**),
* immediate arithmetic-logical instructions (**addi**, **andi**, and **ori**),
* shift instructions (**sll** and **srl**),
* set instructions (**slt** and **slti**),
* branch and jump instructions (**beq**, **bne**, and **j**),
* memory instructions (**lw** and **sw**).

### Note
The memory module contains some initial values representing a test program, though it is possible to define your own program instructions (see the [MIPS32 instruction encoder](https://github.com/david-palma/MIPS32_encoder) repository).

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
