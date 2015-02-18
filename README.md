#PURISC
Pipelined Ultimate Reduced Instruction Set Computer

##Intro
The Pipelined Ultimate Reduced Instruction Set Computer (PURISC) is a processor which uses one instruction for all of its computation. The instruction we chose is SUBLEQ (SUBtract and Branch if Less than or EQual to zero). This radically minimalist design does not have an ALU, and does not use any special function registers outside of memory mapped IO. Due to the simplicity of the hardware, many CPUs can be placed on one FPGA or die to execute programs concurrently. Data transfer and concurrency are managed by our OpenCL implementation (compiler and driver).

##SUBLEQ
SUBLEQ instructions are comprised of three 32 bit addresses. Take the following instruction, for example:
```
a b c
```
The CPU will subtract the value at location `a` from the value at location `b`, place the result at location `b`, and if the result was less than or equal to zero, it will branch to the address `c`. Typical RISC instructions, such as ADD or MOV can be easily broken down into SUBLEQ, whereas more sophisticated instructions, such as floating point operations, compile to longer and more complicated sequences. Any instructions which require pointer manipulation, including array indexing, require self modifying SUBLEQ. As a result, the PURISC makes no distinction between program and data memory.

##Memory Hierarchy
SUBLEQ, without special function registers, does not support load/store operations. As a result, the entire memory hierarchy must appear to the CPU as an extremely large set of registers. In reality, the memory is arranged in a hierarchy which is automatically managed, nicknamed MAGIC. Unlike a typical set of CPU registers, MAGIC has the ability to stall the CPU in the event of a cache miss. 

##IO Protocol
coming soon

##OpenCL Restrictions
coming soon
