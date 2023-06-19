# CS34021

## A repo for CSU34021 Computer Architecture II as taught by Andrea Patane in 2023.

### [Assignment 1](https://github.com/ni-sauvage/CS34021/tree/main/Assignment1)
Assignment 1 was an introduction to x86 programming using the [masm32sdk](https://www.masm32.com/download.htm). The first problem consisted of writing an efficient algorithm to [compute the sum of N integers, up to a certain N](https://en.wikipedia.org/wiki/1_%2B_2_%2B_3_%2B_4_%2B_%E2%8B%AF).

The second problem required us to write an x86 algorithm to convert an integer into it's [ASCII representation](https://en.wikipedia.org/wiki/ASCII) as a string. 

The third section involved theoretical questions about terminology relating to computer architecture.

[My solution to the first problem](https://github.com/ni-sauvage/CS34021/blob/main/Assignment1/Assign1_ex1.asm).

[My solution to the second problem](https://github.com/ni-sauvage/CS34021/blob/main/Assignment1/Assign1_ex2.asm). 

[My solution to the third problem](https://github.com/ni-sauvage/CS34021/blob/main/Assignment1/Assign1_ex3.txt).

### [Assignment 2](https://github.com/ni-sauvage/CS34021/tree/main/Assignment2)
Assignment 2 was all about recursion and the stack. Exercise 1 involved writing an algorithm for computing the factorial of an integer recursively and drawing the stack at N=6. 

Exercise 2 was the first foray into x64 and all that comes with it, involving shadow space and stack alignment. We were merely meant to translate a C function into x64 which would sum N, N-1, N-2 and N-3 where N was a natural number (skipping if it was negative) and repeat recursively. However, it was also necessary to write a function which could convert this value into a string for printing. 

![N=6 stack frames](https://github.com/ni-sauvage/CS34021/blob/main/Assignment2/Assign2_ex01_stack.png) ![Recursive stack frame Diagram x64](https://github.com/ni-sauvage/CS34021/blob/main/Assignment2/Assign2_ex02_stack.png)

[My solution to the first problem](https://github.com/ni-sauvage/CS34021/blob/main/Assignment2/Assign2_ex1.asm). 
[My solution to the second problem](https://github.com/ni-sauvage/CS34021/blob/main/Assignment2/Assign2_ex2.asm). 

### [Assignment 3](https://github.com/ni-sauvage/CS34021/tree/main/Assignment3)
This assignment saw us dive into [RISC](https://en.wikipedia.org/wiki/Reduced_instruction_set_computer) and everything that entails. Our first exercise was to write some RISC code loosely modeled on RISC-I. Moreover, we had to then optimise our code to account for some pipelining - RISC will execute one more instruction while it is calculating its jump in a jump instruction, so a NOP `XOR R0, R0, R0` is often used. However, in the optimised version, I used this to my advantage to speed up the programme. 

Second, we simulated the [Ackermann function](https://en.wikipedia.org/wiki/Ackermann_function) running on RISC architecture using C. This involved calculating how many underflows and overflows were caused by this function as RISC has 8 register banks which correspond to 8 levels of recursion/context switching. If we exceed this, we push them to the stack, if our register banks are empty, we pop from the stack. 

[My solution to the first problem, unoptimised](https://github.com/ni-sauvage/CS34021/blob/main/Assignment3/Assign3_ex1_unop.asm).

[My solution to the first problem, unoptimised](https://github.com/ni-sauvage/CS34021/blob/main/Assignment3/Assign3_ex1_op.asm). 

[My solution to the second problem](https://github.com/ni-sauvage/CS34021/blob/main/Assignment3/Assign3_ex2.c). 

### [Assignment 4](https://github.com/ni-sauvage/CS34021/tree/main/Assignment4)
Assignment 4 dealt with the MIPS pipeline under certain conditions (two-phase enabled/disabled, forwarding enabled/disabled) and [mapping memory to page tables](https://en.wikipedia.org/wiki/Virtual_memory).

#### MIPS Pipeline (Part 1)
##### A MIPS pipeline operating with forwarding
![A MIPS pipeline operating with forwarding](https://github.com/ni-sauvage/CS34021/blob/main/Assignment4/Assign4_Part1_Ex1.png)

##### A MIPS pipeline operating with forwarding and instruction interchange
![A MIPS pipeline operating with forwarding and instruction interchange](https://github.com/ni-sauvage/CS34021/blob/main/Assignment4/Assign4_Part1_Ex2.png)

##### A MIPS pipeline operating with forwarding disabled
![A MIPS pipeline operating with forwarding disabled](https://github.com/ni-sauvage/CS34021/blob/main/Assignment4/Assign4_Part1_Ex3.png)

##### A MIPS pipeline erroneously not stalling for hazards and the consequences
![A MIPS pipeline erroneously not stalling for hazards and the consequences](https://github.com/ni-sauvage/CS34021/blob/main/Assignment4/Assign4_Part1_Ex4.png)

#### Virtual Memory (Part 2)
![First Virtual Memory exercise](https://github.com/ni-sauvage/CS34021/blob/main/Assignment4/Assign4_Part2_Ex3.png)

![Second Virtual Memory exercise](https://github.com/ni-sauvage/CS34021/blob/main/Assignment4/Assign4_Part2_Ex4.png)
