#PURISC
Pipelined/Purist Ultimate Reduced Instruction Set Computer - a single 
instruction 8 core coprocessor system.

##Intro
This project consists of a system centered around several single instruction
CPUs. It includes many components other than the one instruction CPU, such as
memory management and ethernet IO. For more information about the design,
please refer to the wiki.

##Hardware
This project was designed for the Altera DE2-115 development board, and is not
guaranteed to work with other systems. It makes use of the Cyclone IV embedded
M9K RAM, the gigabit ethernet phy, and Altera's IP cores. Altera code has not
been added to the repo (the RAM modules have been removed).

##Simulation
PURISC is written in SystemVerilog, Verilog, and VHDL. A program that supports
muli-language simulation must be used to simulate it. 
