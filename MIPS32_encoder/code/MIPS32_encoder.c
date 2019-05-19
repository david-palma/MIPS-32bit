/**
 * Copyright (c) 2019 David Palma licensed under the MIT license
 * Title: MIPS-32bit instruction encoder
 * Author:  David Palma
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUMBIT 16

void Registers(char reg[NUMBIT]);
void DecToBin(int bin[NUMBIT], int dec, int n);

int main(int argc, char *argv[])
{
    char code[NUMBIT],
         rs[NUMBIT],
         rt[NUMBIT],
         rd[NUMBIT];
    int b[NUMBIT], dec, i, j, cnt = 0;
    FILE *fpin, *fpout;

    if (argc != 3)
    {
        printf("USAGE: MIPS32_encoder <input_file.ext> <output_file.ext>\n");
        exit(EXIT_FAILURE);
    }
    if ((fpin = fopen(argv[1], "r")) == NULL)
    {
        printf("Error opening input file\n");
        exit(EXIT_FAILURE);
    }
    if ((fpout = fopen(argv[2], "w")) == NULL)
    {
        printf("Error opening output file\n");
        exit(EXIT_FAILURE);
    }

    fprintf(fpout, "-- auto generated\r\n");

    while (fscanf(fpin, "%s", code) != EOF)
    {
        if (!strcmp(code, "add")) // add $R1 $R2 $R3
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);

            fprintf(fpout, "-- add %s,%s,%s\r\n", rd, rs, rt);

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n"
                           "%d => \"%s000\",\r\n"
                           "%d => \"00100000\",\r\n\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt, cnt + 2, rd, cnt + 3);
            cnt += 4;
        }
        else if (!strcmp(code, "sub")) // sub $R1 $R2 $R3
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);

            fprintf(fpout, "-- sub %s,%s,%s\r\n", rd, rs, rt);

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n"
                           "%d => \"%s000\",\r\n"
                           "%d => \"00100010\",\r\n\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt, cnt + 2, rd, cnt + 3);
            cnt += 4;
        }
        else if (!strcmp(code, "addi")) // addi $R1 $R2 50
        {
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- addi %s,%s,%d\r\n", rt, rs, dec);

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fprintf(fpout, "%d => \"001000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);
            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "lw")) // lw $R1 50 $R2
        {
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%d", &dec);
            fscanf(fpin, "%s", rs);

            fprintf(fpout, "-- lw %s,%d(%s)\r\n", rt, dec, rs);

            Registers(rt);
            DecToBin(b, dec, NUMBIT);
            Registers(rs);

            fprintf(fpout, "%d => \"100011%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);

            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "sw")) // sw $R1 50 $R2
        {
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%d", &dec);
            fscanf(fpin, "%s", rs);

            fprintf(fpout, "-- sw %s,%d(%s)\r\n", rt, dec, rs);

            Registers(rt);
            DecToBin(b, dec, NUMBIT);
            Registers(rs);

            fprintf(fpout, "%d => \"101011%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);

            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "and")) // and $R1 $R2 $R3
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);

            fprintf(fpout, "-- and %s,%s,%s\r\n", rd, rs, rt);

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n"
                           "%d => \"%s000\",\r\n"
                           "%d => \"00100100\",\r\n\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt, cnt + 2, rd, cnt + 3);

            cnt += 4;
        }
        else if (!strcmp(code, "or")) // or $R1 $R2 $R3
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);

            fprintf(fpout, "-- or %s,%s,%s\r\n", rd, rs, rt);

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n"
                           "%d => \"%s000\",\r\n"
                           "%d => \"00100101\",\r\n\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt, cnt + 2, rd, cnt + 3);

            cnt += 4;
        }
        else if (!strcmp(code, "nor")) // nor $R1 $R2 $R3
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);

            fprintf(fpout, "-- nor %s,%s,%s\r\n", rd, rs, rt);

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n"
                           "%d => \"%s000\",\r\n"
                           "%d => \"00100111\",\r\n\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt, cnt + 2, rd, cnt + 3);

            cnt += 4;
        }
        else if (!strcmp(code, "andi")) // andi $R1 $R2 50
        {
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- andi %s,%s,%d\r\n", rt, rs, dec);

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fprintf(fpout, "%d => \"001100%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);

            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "ori")) // ori $R1 $R2 50
        {
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- ori %s,%s,%d\r\n", rt, rs, dec);

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fprintf(fpout, "%d => \"001101%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);

            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "xor")) // xor $R1 $R2 $R3
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);

            fprintf(fpout, "-- xor %s,%s,%s\r\n", rd, rs, rt);

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n"
                           "%d => \"%s000\",\r\n"
                           "%d => \"00100110\",\r\n\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt, cnt + 2, rd, cnt + 3);

            cnt += 4;
        }
        else if (!strcmp(code, "sll")) // sll $R1 $R2 10
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- sll %s,%s,%d\r\n", rd, rt, dec);

            Registers(rd);
            Registers(rt);
            DecToBin(b, dec, NUMBIT); // 5 bit

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c00000\",\r\n"
                           "%d => \"%s%d%d%d\",\r\n"
                           "%d => \"%d%d000000\",\r\n\r\n",
                    cnt, rt[0], rt[1], cnt + 1, rt[2], rt[3], rt[4], cnt + 2, rd, b[11], b[12], b[13], cnt + 3, b[14], b[15]);

            cnt += 4;
        }
        else if (!strcmp(code, "srl")) // srl $R1 $R2 10
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- srl %s,%s,%d\r\n", rd, rt, dec);

            Registers(rd);
            Registers(rt);
            DecToBin(b, dec, NUMBIT); // 5 bit

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c00000\",\r\n"
                           "%d => \"%s%d%d%d\",\r\n"
                           "%d => \"%d%d000010\",\r\n\r\n",
                    cnt, rt[0], rt[1], cnt + 1, rt[2], rt[3], rt[4], cnt + 2, rd, b[11], b[12], b[13], cnt + 3, b[14], b[15]);

            cnt += 4;
        }
        else if (!strcmp(code, "beq")) // beq $R1 $R2 25
        {
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- beq %s,%s,%d\r\n", rs, rt, dec);

            Registers(rs);
            Registers(rt);
            DecToBin(b, dec, NUMBIT);

            fprintf(fpout, "%d => \"000100%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);

            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "bne")) // bne $R1 $R2 25
        {
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- bne %s,%s,%d\r\n", rs, rt, dec);

            Registers(rs);
            Registers(rt);
            DecToBin(b, dec, NUMBIT);

            fprintf(fpout, "%d => \"000101%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);

            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "slt")) // slt $R1 $R2 $R3
        {
            fscanf(fpin, "%s", rd);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%s", rt);

            fprintf(fpout, "-- slt %s,%s,%s\r\n", rd, rs, rt);

            Registers(rd);
            Registers(rs);
            Registers(rt);

            fprintf(fpout, "%d => \"000000%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n"
                           "%d => \"%s000\",\r\n"
                           "%d => \"00101010\",\r\n\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt, cnt + 2, rd, cnt + 3);

            cnt += 4;
        }
        else if (!strcmp(code, "slti")) // slti $R1 $R2 50
        {
            fscanf(fpin, "%s", rt);
            fscanf(fpin, "%s", rs);
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- slti %s,%s,%d\r\n", rt, rs, dec);

            Registers(rt);
            Registers(rs);
            DecToBin(b, dec, NUMBIT);

            fprintf(fpout, "%d => \"001010%c%c\",\r\n"
                           "%d => \"%c%c%c%s\",\r\n",
                    cnt, rs[0], rs[1], cnt + 1, rs[2], rs[3], rs[4], rt);

            cnt += 2;

            for (j = 0; j < 2; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;
                for (i = 0 + (j * NUMBIT / 2); i < NUMBIT / 2 + (j * NUMBIT / 2); i++)
                    fprintf(fpout, "%d", b[i]);
                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else if (!strcmp(code, "j")) // j 2500
        {
            fscanf(fpin, "%d", &dec);

            fprintf(fpout, "-- j %d\r\n", dec);

            DecToBin(b, dec, 26); // bit jump

            fprintf(fpout, "%d => \"000010%d%d\",\r\n", cnt, b[0], b[1]);

            cnt++;

            for (j = 0; j < 3; j++)
            {
                fprintf(fpout, "%d => \"", cnt);
                cnt++;

                for (i = 2 + (j * 8); i < 10 + (j * 8); i++)
                    fprintf(fpout, "%d", b[i]);

                fprintf(fpout, "\",\r\n");
            }

            fprintf(fpout, "\r\n");
        }
        else
        {
            printf("Instruction error!\n");
            exit(EXIT_FAILURE);
        }
    }

    fclose(fpin);
    fclose(fpout);

    return EXIT_SUCCESS;
}

void Registers(char reg[NUMBIT])
{
    if (!strcmp(reg, "$R0"))
        strcpy(reg, "00000");
    else if (!strcmp(reg, "$R1"))
        strcpy(reg, "00001");
    else if (!strcmp(reg, "$R2"))
        strcpy(reg, "00010");
    else if (!strcmp(reg, "$R3"))
        strcpy(reg, "00011");
    else if (!strcmp(reg, "$R4"))
        strcpy(reg, "00100");
    else if (!strcmp(reg, "$R5"))
        strcpy(reg, "00101");
    else if (!strcmp(reg, "$R6"))
        strcpy(reg, "00110");
    else if (!strcmp(reg, "$R7"))
        strcpy(reg, "00111");
    else if (!strcmp(reg, "$R8"))
        strcpy(reg, "01000");
    else if (!strcmp(reg, "$R9"))
        strcpy(reg, "01001");
    else if (!strcmp(reg, "$R10"))
        strcpy(reg, "01010");
    else if (!strcmp(reg, "$R11"))
        strcpy(reg, "01011");
    else if (!strcmp(reg, "$R12"))
        strcpy(reg, "01100");
    else if (!strcmp(reg, "$R13"))
        strcpy(reg, "01101");
    else if (!strcmp(reg, "$R14"))
        strcpy(reg, "01110");
    else if (!strcmp(reg, "$R15"))
        strcpy(reg, "01111");
    else if (!strcmp(reg, "$R16"))
        strcpy(reg, "10000");
    else if (!strcmp(reg, "$R17"))
        strcpy(reg, "10001");
    else if (!strcmp(reg, "$R18"))
        strcpy(reg, "10010");
    else if (!strcmp(reg, "$R19"))
        strcpy(reg, "10011");
    else if (!strcmp(reg, "$R20"))
        strcpy(reg, "10100");
    else if (!strcmp(reg, "$R21"))
        strcpy(reg, "10101");
    else if (!strcmp(reg, "$R22"))
        strcpy(reg, "10110");
    else if (!strcmp(reg, "$R23"))
        strcpy(reg, "10111");
    else if (!strcmp(reg, "$R24"))
        strcpy(reg, "11000");
    else if (!strcmp(reg, "$R25"))
        strcpy(reg, "11001");
    else if (!strcmp(reg, "$R26"))
        strcpy(reg, "11010");
    else if (!strcmp(reg, "$R27"))
        strcpy(reg, "11011");
    else if (!strcmp(reg, "$R28"))
        strcpy(reg, "11100");
    else if (!strcmp(reg, "$R29"))
        strcpy(reg, "11101");
    else if (!strcmp(reg, "$R30"))
        strcpy(reg, "11110");
    else if (!strcmp(reg, "$R31"))
        strcpy(reg, "11111");
    else
    {
        printf("Error: register can be Ri, with i=0,1,...,31\n");
        exit(EXIT_FAILURE);
    }

    return;
}

/* Base-10 to base-2 conversion */
void DecToBin(int bin[NUMBIT], int dec, int n)
{
    int i, k, j = n - 1;

    for (i = 0; i < n; i++)
    {
        if (dec % 2 == 0)
            bin[i] = 0;
        else
            bin[i] = 1;

        dec /= 2;
    }

    for (i = 0; i < n / 2; i++)
    {
        k = bin[i];
        bin[i] = bin[j];
        bin[j] = k;
        j--;
    }

    return;
}
