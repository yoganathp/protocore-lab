# 🚀 ProtoCore-Lab: The Bare-Metal to RTOS Challenge

Welcome to **ProtoCore-Lab**! This is my "Learn in Public" journey where I am building a professional-grade firmware ecosystem from the ground up, targeting multiple platforms and architectures.

No high-level libraries. No manufacturer HALs. Just a datasheet, a compiler, and the raw silicon.

## 🎯 Current Goal: QEMU UART Bring-up

The first milestone is to initialize the virtual STM32F4 UART peripheral. This allows us to:

1. Verify the **Vector Table** and **Startup** logic.  
2. Establish a communication channel for **Serial Logs** (printf-style debugging).

## 📖 Why I'm Doing This

In modern embedded development, we often rely on vendor-supplied "Black Box" libraries that hide the true complexity of the silicon. **ProtoCore-Lab** is my mission to peel back those layers and master the **Full-Stack Firmware Lifecycle**—from the first instruction to a multitasking kernel.

## 🛠️ Environment Setup (Ubuntu 24.04)

### 1. Toolchain & Libraries

```bash
sudo apt update
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
```

- **gcc-arm-none-eabi**: The cross-compiler (v13.2.1) targeting ARM EABI  
- **binutils-arm-none-eabi**: Essential binary tools (`ld`, `as`, `objcopy`, `size`)  
- **libnewlib-arm-none-eabi**: The Newlib C library providing headers like `stdint.h` and math functions optimized for bare-metal  

### 2. Debugger (GDB) & Emulator

```bash
sudo apt install gdb-multiarch qemu-system-arm
```

- **gdb-multiarch**: Universal debugger supporting ARM, RISC-V, and more  
- **qemu-system-arm**: Emulates the STM32F4 (Cortex-M4) hardware environment  

## 🏗️ Project Structure

The project uses a Platform Abstraction model. Hardware-specific files (linker scripts, startup assembly) are isolated from the application logic.

```
.
├── Makefile                # Master build script
├── platforms
│   └── qemu_stm32f4        # Specific target for QEMU emulation
│       ├── linker.ld       # Maps code to QEMU's virtual Flash/RAM
│       └── startup.s       # Assembly entry point and Vector Table
└── README.md               # Project documentation
```

## 📚 Reference & Documentation

### 🛠️ Toolchain & GCC
- **Official Arm Toolchain Guide:** [Installing the Arm GNU Toolchain](https://learn.arm.com/install-guides/gcc/arm-gnu/)
- **GCC Option Summary:** [GNU Compiler Collection Manual](https://gcc.gnu.org/onlinedocs/gcc-15.2.0/gcc/Option-Summary.html)

### ✍️ Assembly (GAS) Reference
- **GNU Assembler Manual:** [Symbols & Expressions](https://ftp.gnu.org/old-gnu/Manuals/gas/html_chapter/as_7.html)
- **ARM-Specific Directives:** [Sourceware Binutils Documentation](https://sourceware.org/binutils/docs/as/ARM-Directives.html)

### 📑 STM32F407VG Hardware
* **QEMU STM32 Official Docs:** [STM32 Family Emulation](https://www.qemu.org/docs/master/system/arm/stm32.html)
- **Reference Manual (RM0090):** [STM32F405/415, STM32F407/417, STM32F427/437 and STM32F429/439 advanced Arm®-based 32-bit MCUs](https://www.st.com/resource/en/reference_manual/dm00031020-stm32f405-415-stm32f407-417-stm32f427-437-and-stm32f429-439-advanced-arm-based-32-bit-mcus-stmicroelectronics.pdf)
- **Datasheet:** [STM32F405xx STM32F407xx](https://www.st.com/resource/en/datasheet/dm00037051.pdf)

### 🔍 Debugging & Visualization
* **GDB Dashboard:** [Modular Visual Interface for GDB](https://github.com/cyrus-and/gdb-dashboard)