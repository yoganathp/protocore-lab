# 🚀 ProtoCore-Lab: The Bare-Metal to RTOS Challenge

Welcome to **ProtoCore-Lab**! This is my "Learn in Public" journey where I am challenging myself to build a professional-grade firmware ecosystem from the absolute ground up. 

No high-level libraries. No manufacturer HALs. Just a datasheet, a compiler, and the raw silicon.

## Current Goal: QEMU UART Bring-up
The first milestone is to initialize the virtual STM32F4 UART peripheral. This allows us to:
1. Verify the **Vector Table** and **Startup** logic.
2. Establish a communication channel for **Serial Logs** (like printf-style debugging).

## Environment Setup

### 1. Toolchain & Libraries
```bash
sudo apt update
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
```
* `gcc-arm-none-eabi`: The cross-compiler (v13.2.1) targeting ARM EABI.
* `binutils-arm-none-eabi`: Essential binary tools (ld, as, objcopy, size).
* `libnewlib-arm-none-eabi`: The "Newlib" C library. Provides stdint.h and math functions optimized for bare-metal systems with no OS.

### 2. Debugger (GDB)
``` bash
sudo apt install gdb-multiarch
```
* `gdb-multiarch`: A universal debugger supporting ARM, RISC-V, and more. It is used to "peak" into QEMU's memory and registers during execution.

## Current Project Structure
The project uses a Platform Abstraction model. All hardware-specific files (Linker scripts, Startup assembly) are isolated in the platforms/ directory.

``` Plaintext
.
├── Makefile                # Master build script
├── platforms
│   └── qemu_stm32f4        # Specific target for QEMU emulation
│       ├── linker.ld       # Maps code to QEMU's virtual Flash/RAM
│       └── startup.s       # Assembly entry point and Vector Table
└── README.md               # Project documentation
```

> ## Why I'm Doing This
> In modern embedded development, we often rely on vendor-supplied "Black Box" libraries that hide the true complexity of the silicon. **ProtoCore-Lab** is my mission to peel back those layers and master the **Full-Stack Firmware Lifecycle.**