# VHDL 16-bit Calculator

This repository contains a simple 16-bit calculator (simplified ALU) implemented in VHDL, which supports basic arithmetic and logical operations. The calculator can perform operations like addition, subtraction, AND, OR, NOT, and XOR on two 16-bit input values.

## Features

- **Arithmetic Operations**: Addition (`+`), Subtraction (`-`)
- **Logical Operations**: AND, OR, XOR
- **Unary Operations**: NOT for both inputs (`in1` and `in2`)
- **Overflow Detection**: Overflow detection for addition and subtraction operations
- **Zero Detection**: Output signal to indicate if the result is zero

## Entity and Architecture Overview

### Entity `calculator`
The `calculator` entity has the following ports:

- **in1**: 16-bit input vector
- **in2**: 16-bit input vector
- **result**: 16-bit output vector to store the result of the operation
- **sig**: A 4-bit control signal that determines which operation to perform:
  - `0`: Addition (`+`)
  - `1`: Subtraction (`-`)
  - `2`: AND
  - `3`: OR
  - `4`: NOT for `in1`
  - `5`: NOT for `in2`
  - `6`: XOR
- **overflow**: A signal indicating if there was an overflow during an arithmetic operation
- **zero**: A signal that indicates whether the result is zero

### Architecture `behavioral`
The `behavioral` architecture implements the logic for each operation. It uses a `process` to evaluate the operation specified by the `sig` input. The architecture includes overflow detection for addition and subtraction, and logical operations for AND, OR, NOT, and XOR. The result is updated accordingly, and the overflow and zero signals are set based on the computation.

## Operation Logic

1. **Addition (`+`)**:
   - If the signs of the operands are the same and the result has a different sign, an overflow is detected.
   - The result is stored in `result`, or `0` if overflow is detected.

2. **Subtraction (`-`)**:
   - If the signs of the operands are different and the result has a different sign, an overflow is detected.
   - The result is stored in `result`, or `0` if overflow is detected.

3. **AND**:
   - Performs bitwise AND between `in1` and `in2` and stores the result.

4. **OR**:
   - Performs bitwise OR between `in1` and `in2` and stores the result.

5. **NOT**:
   - Performs bitwise NOT on `in1` or `in2` and stores the result.

6. **XOR**:
   - Performs bitwise XOR between `in1` and `in2` and stores the result.

7. **Overflow**:
   - The `overflow` signal is set to `'1'` if an overflow is detected during addition or subtraction. Otherwise, it is `'0'`.

8. **Zero Detection**:
   - The `zero` signal is set to `'1'` if the result is zero, otherwise, it is set to `'0'`.

## Requirements

- **VHDL Simulator**: To test and simulate the code, you can use any standard VHDL simulator like ModelSim, Xilinx Vivado, or GHDL. I use GHDL and GTKWAVE.++
