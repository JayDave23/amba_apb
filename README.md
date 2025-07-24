# AMBA APB Protocol Simulation in Verilog

This repository contains a Verilog-based simulation of the **AMBA APB (Advanced Peripheral Bus)** protocol, including:

 An APB-compliant slave module 
 A multi-slave APB interconnect (`top`) 
 A master testbench simulating write/read operations 
 Support for wait states and multiple 32-bit registers per slave 
 Designed for simulation using Vivado 
  
# Folder Structure
Sources

|-> Design Sources
    |-> top.v
    |-> slave.v

|-> Simulation Sources
    |-> tb_top.v
