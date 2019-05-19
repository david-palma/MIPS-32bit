# 32-bit MIPS processors

This repository is meant to provide:

* [a 32-bit implementation of a single-cycle MIPS processor in VHDL](https://github.com/david-palma/MIPS-32bit/MIPS32_single_cycle);
* [a 32-bit implementation of a multi-cycle MIPS processor in VHDL](https://github.com/david-palma/MIPS-32bit/MIPS32_multi_cycle);
* [a C implementation of a 32-bit assembly instruction encoder for MIPS processors](https://github.com/david-palma/MIPS-32bit/MIPS32_encoder).

## Executable instructions

Both the implementations are able to execute the following subset of the original MIPS instruction set:

* register arithmetic-logical instructions (**add**, **sub**, **and**, **or**, **nor**, and **xor**),
* immediate arithmetic-logical instructions (**addi**, **andi**, and **ori**),
* shift instructions (**sll** and **srl**),
* set instructions (**slt** and **slti**),
* branch and jump instructions (**beq**, **bne**, and **j**),
* memory instructions (**lw** and **sw**).

### Note

The memory modules in both the implementations contain some initial values representing a test program, though it is possible to define your own program instructions (see the [MIPS32 instruction encoder](https://github.com/david-palma/MIPS-32bit/MIPS32_encoder)).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
