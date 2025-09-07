# 4Mb MRAM IP Digital Circuit

**Design Unit:** Southeast University  
**Responsible:** Hou Yaoru  
**Date:** June 23, 2022  

## Project Description
This project implements a **4Mb MRAM IP digital circuit**, including:  
- MRAM array behavioral model with fault injection  
- MBIST (Memory Built-In Self-Test) circuit  
- MRAM peripheral control circuit  
- ECC (Error Correction Code) circuit  

---

## Code Structure
```
├── model
│   └── MRAM_BANK.v          # 256x416 MRAM array behavioral model with fault injection
│
├── RTL
│   ├── src
│   │   ├── MRAM_IP.v        # Top-level MRAM IP module
│   │   ├── mbistctrl_1_con.v # Instantiate and connect MBIST submodules
│   │   ├── mbistctrl_1.v    # Main MBIST logic: diagnosis, control, etc.
│   │   ├── MRAM_4MB.v       # Instantiate 130 MRAM BANKs and peripheral circuits
│   │
│   └── sim
│       └── mbistctrl_1_tb.v # Testbench: BIST mode, memory read/write, clock, ECC
```

---

## Test Modes

### 1. BIST Mode
- In `./RTL/sim/mbistctrl_1_tb.v`:  
  - Keep `BIST_MODE` macro definition  
  - Comment out `MEM_MODE` macro definition  

### 2. Memory Read/Write Mode
- In `./RTL/sim/mbistctrl_1_tb.v`:  
  - Comment out `BIST_MODE` macro definition  
  - Keep `MEM_MODE` macro definition  

### 3. Clock Frequency Selection
- Defined in `./RTL/sim/mbistctrl_1_tb.v`:  
  - `CLK_35`: 35ns clock period  
  - `CLK_20`: 20ns clock period  
- **Important:** Only one of these macros must be active at a time.  

### 4. ECC Enable/Disable
- Defined in `./RTL/sim/mbistctrl_1_tb.v`:  
  - `ECC_ON`: Enable ECC function  
  - `ECC_OFF`: Disable ECC function  
- With ECC enabled, **1-bit error per 8-bit data can be corrected**.  
- **Important:** Only one macro must be active.  

### 5. Fault Injection Model
- In `./RTL/src/MRAM_BANK.v`:  
  - Keep `INJ_FAULT` macro to enable fault model  
  - Comment out to disable fault model  

When enabled, each BANK inserts the following faults:  

| Address | Data Bit | Fault Type                 |
|---------|----------|----------------------------|
| 11'd0   | data[0]  | Stuck-at-0                 |
| 11'd1   | data[11] | Stuck-at-1                 |
| 11'd2   | data[28] | 01 Transition fault (1→0) |
| 11'd3   | data[21] | 10 Transition fault (0→1) |
| 11'd4   | data[28] | Up-coupling fault          |
| 11'd5   | data[7]  | Down-coupling fault        |
| 11'd6   | data[18] | Left-coupling fault        |
| 11'd7   | data[25] | Right-coupling fault       |


要不要我再帮你加一个 **Usage & Simulation Example** 部分，展示 `iverilog` 或 `vcs` 的仿真命令？
