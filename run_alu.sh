#!/bin/bash

# File: run_alu.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting compilation and simulation of the ALU project${NC}"

# Clean up previous files
echo "Cleaning up temporary files..."
rm -f *.o *.cf *.vcd

# Analyzing VHDL files
echo "Analyzing alu.vhdl file..."
if ghdl -a alu.vhdl; then
    echo -e "${GREEN}alu.vhdl analysis completed successfully${NC}"
else
    echo -e "${RED}Error during analysis of alu.vhdl${NC}"
    exit 1
fi

echo "Analyzing tb_alu.vhdl file..."
if ghdl -a tb_alu.vhdl; then
    echo -e "${GREEN}tb_alu.vhdl analysis completed successfully${NC}"
else
    echo -e "${RED}Error during analysis of tb_alu.vhdl${NC}"
    exit 1
fi

# Processing the testbench
echo "Processing the testbench..."
if ghdl -e tb_alu; then
    echo -e "${GREEN}Processing completed successfully${NC}"
else
    echo -e "${RED}Error during processing${NC}"
    exit 1
fi

# Running the simulation
echo "Running the simulation..."
if ghdl -r tb_alu --vcd=simulation.vcd; then
    echo -e "${GREEN}Simulation completed successfully${NC}"
else
    echo -e "${RED}Error during simulation${NC}"
    exit 1
fi

# Starting GTKWave
echo "Starting GTKWave..."
if command -v gtkwave &> /dev/null; then
    gtkwave simulation.vcd &
    echo -e "${GREEN}GTKWave started successfully${NC}"
else
    echo -e "${RED}GTKWave not found. Make sure it is installed${NC}"
    exit 1
fi

echo -e "${GREEN}Script completed successfully!${NC}"