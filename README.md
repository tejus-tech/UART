# UART in Verilog

## Project Description
This project implements a Universal Asynchronous Receiver Transmitter (UART) in Verilog HDL. It includes separate modules for UART Transmitter (TX), UART Receiver (RX), and a Top module that integrates both for full-duplex serial communication.

---

## Features in Design

- Parameterizable Design:
  - Clock Frequency and Baud Rate are configurable
- UART Transmitter (TX):
  - 8-bit parallel data input
  - Serial bit-wise output
  - Start, Data, and Stop bit generation
- UART Receiver (RX):
  - Serial bit-wise input
  - 8-bit parallel data output
- Top-Level Module:
  - Instantiates TX and RX modules
  - Designed to support loopback mode for verification

---

## Testbench

- A self-checking testbench is included to verify the complete UART functionality
- It simulates transmission of multiple bytes from TX to RX
- Loopback setup ensures RX receives what TX sends
- Generates a .vcd file for waveform analysis

---

## Tools Used

- EDA Playground
  - Web-based simulation and waveform viewer
- Icarus Verilog + GTKWave
  - Compile: iverilog -o sim.vvp uart.v uart_tb.v
  - Simulate: vvp sim.vvp
  - View waveform: gtkwave dump.vcd

---

## Sample Waveforms

![image](https://github.com/user-attachments/assets/7a444a8b-a0f6-4515-8b84-42524682fa32)

---

## Learning Outcomes

- Gained understanding of asynchronous serial communication
- Implemented FSM-based TX and RX logic
- Simulated and debugged Verilog modules with GTKWave
- Built and verified UART protocol from scratch
- Developed skills in modular digital design and testbench writing

---
