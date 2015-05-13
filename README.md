#PURISC
Pipelined/Purist Ultimate Reduced Instruction Set Computer - a single 
instruction 8 core coprocessor system.

This project consists of a system-on-chip prototype intended to demonstrate an
8 core implementation of a pipelined one-instruction machine. The system
includes, in addition to the 8 CPUs, hardware for controlling memory access and
ethernet IO. Other git repos by the purisc group provide host-side software for
compiling one-instruction programs, communicating with the board, and other
scripts useful for development

For more details on the design and the role of each component, please refer to
the documentation at
https://github.com/purisc-group/purisc/wiki

##Hardware
This project was designed for the Altera DE2-115 development board, and is not
guaranteed to work with other systems. It makes use of the Cyclone IV embedded
M9K RAM, the gigabit ethernet phy, and Altera's IP cores. Altera code has not
been added to the repo (the RAM modules have been removed).

##Simulation
PURISC is written in SystemVerilog, Verilog, and VHDL. A program that supports
muli-language simulation must be used to simulate it. Components have their own
testbenches, but to test the entire project, use the testbench in the project
root directory.
