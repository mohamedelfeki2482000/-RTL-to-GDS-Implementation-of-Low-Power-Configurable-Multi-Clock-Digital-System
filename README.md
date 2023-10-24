# RTL to GDS Implementation of Low Power Configurable Multi Clock Digital System

## Introduction

The Low Power Configurable Multi Clock Digital System is designed to receive commands through a UART receiver. It performs various system functions such as register file reading/writing and processing using the ALU block. The results are sent using up to a 4-byte frame through the UART transmitter communication protocol.

## Overview

The system receives a UART Frame from the UART RX block. The first frame determines the required command, and the system supports four different operations:

- **Register File Write Command**
- **Register File Read Command**
- **ALU Operation Command with Operand**
- **ALU Operation Command with No Operand**

## Block Diagram


## System Specifications

- **Reference Clock (REF_CLK):** 50 MHz
- **UART Clock (UART_CLK):** 3.6864 MHz
- **Clock Divider:** Always enabled (clock divider enable = 1)



## Contributors

- Mohamed Elfeki

