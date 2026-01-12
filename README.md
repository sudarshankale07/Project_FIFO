# Project_FIFO
Parameterized Synchronous FIFO (RTL + Verification), instantiated for different use cases without rewriting the logic—critical for IP reuse in ASIC/FPGA projects 

A parameterized FIFO is a reusable, scalable hardware design of a First-In-First-Out (FIFO) buffer in which key characteristics—like data width, depth (number of entries), and sometimes pointer width or memory type—are defined as parameters rather than hard-coded constants.

A parameterized FIFO is:

Configurable via parameters
Reusable across projects
Scalable in width and depth
Industry-standard practice in professional RTL design

implemented a lightweight UVM-based testbench for the synchronous FIFO. 
The testbench uses a UVM test class to generate directed write and read transactions, connected to the DUT via a virtual interface
