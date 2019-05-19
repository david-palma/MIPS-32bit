# MIPS instruction encoder

This is a C implementation of a 32-bit assembly instruction encoder for MIPS processors.
The program is indeed able to encode in machine code a set of assembly instructions reading the input data from the "input.txt" file and printing the result into the "output.txt" file.

## MIPS instructions

The MIPS instruction subset is described in the following table:

| Instruction | Syntax             | Operation                      | Description                      |
|-------------|:-------------------|:-------------------------------|:---------------------------------|
| add         | add \$R1 \$R2 \$R3 | \$R1 = \$R2 + \$R3             | Addition with overflow           |
| sub         | sub \$R1 \$R2 \$R3 | \$R1 = \$R2 - \$R3             | Subtraction with overflow        |
| and         | and \$R1 \$R2 \$R3 | \$R1 = \$R2 \& \$R3            | Bitwise and                      |
| or          | or  \$R1 \$R2 \$R3 | \$R1 = \$R2 \| \$R3            | Bitwise or                       |
| nor         | nor \$R1 \$R2 \$R3 | \$R1 = ~(\$R2 \| \$R3)         | Bitwise nor                      |
| xor         | xor \$R1 \$R2 \$R3 | \$R1 = \$R2 ^ \$R3             | Bitwise xor                      |
| addi        | addi \$R1 \$R2 i   | \$R1 = \$R2 + SE(i)            | Addition immediate with overflow |
| andi        | andi \$R1 \$R2 i   | \$R1 = \$R2 + ZE(i)            | Bitwise and immediate            |
| ori         | ori \$R1 \$R2 i    | \$R1 = \$R2 + ZE(i)            | Bitwise or immediate             |
| sll         | sll \$R1 \$R2 a    | \$R1 = \$R2 << a               | Shift left logical               |
| srl         | srl \$R1 \$R2 a    | \$R1 = \$R2 >> a               | Shift right logical              |
| slt         | slt \$R1 \$R2 \$R3 | \$R1 = (\$R2 < \$R3)           | Set if less than                 |
| slti        | slti \$R1 \$R2 i   | \$R1 = (\$R2 < SE(i))          | Set if less than immediate       |
| lw          | lw \$R1 i \$R2     | \$R1 = MEM[ \$R2 + i]:4        | Load word                        |
| sw          | sw \$R1 i \$R2     | MEM[ \$R2 + i]:4 = \$R1        | Store word                       |
| j           | j i                | pc += i << 2                   | Jump                             |
| beq         | beq \$R1 \$R2 i    | if (\$R1 == \$R2) pc += i << 2 | Branch equal to                  |
| bne         | bne \$R1 \$R2 i    | if (\$R1 != \$R2) pc += i << 2 | Branch not equal to              |

## Compiling and running the program

The command to compile the C source file with GCC is:

```console
$ gcc -Wall -o <output_binary> MIPS32_encoder.c
```

The compiled executable file will be saved as `<output_binary>` (e.g., MIPS32_encoder) in your current working directory, then you can run the program as follows:

```console
$ MIPS32_encoder <input_file.ext> <output_file.ext>
```

where the `<input_file.ext>` contains a sequence of assembly instructions and the `<output_file.ext>` contains the encoded machine code.

## Example

Below you can find an example of an input file containing a few assembly instructions and the resulting conversion in the output file.

`input.txt`

```nasm
addi $R1 $R0 30
sw $R1 0 $R0
lw $R3 0 $R0
```

`output.txt`

```
-- auto generated
-- addi $R1,$R0,30
0 => "00100000",
1 => "00000001",
2 => "00000000",
3 => "00011110",

-- sw $R1,0($R0)
4 => "10101100",
5 => "00000001",
6 => "00000000",
7 => "00000000",

-- lw $R3,0($R0)
8 => "10001100",
9 => "00000011",
10 => "00000000",
11 => "00000000",
```

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/david-palma//MIPS-32bit/LICENSE) file for details.
