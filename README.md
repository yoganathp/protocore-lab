# ProtoCore-Lab: The Bare-Metal to RTOS Challenge

Welcome to **ProtoCore-Lab**. This project is a "Learn in Public" journey focused on building a professional-grade firmware ecosystem from the ground up, targeting multiple platforms and architectures.

No high-level libraries. No manufacturer HALs. Just a datasheet, a compiler, and the raw silicon.

## Current Milestone: UART & Standard I/O Redirection

The initial verification of the **Vector Table** and **Startup** logic is complete. The current objective is to map the STM32F4 UART peripheral to the C standard library to enable `printf()` debugging.

## Milestone Status

- **Phase 1**: Completed (Startup, Linker Script, and main entry verified)
- **Phase 2**: Pending (RCC & UART Peripheral Initialization)
- **Phase 3**: Pending (Retargeting `_write` for `printf` support)

## Why I'm Doing This

In modern embedded development, we often rely on vendor-supplied "Black Box" libraries. **ProtoCore-Lab** is a mission to peel back those layers and master the **Full-Stack Firmware Lifecycle**—from the first instruction to a multitasking kernel.

## Environment Setup (Ubuntu 24.04)

### 1. Toolchain & Libraries

```bash
sudo apt update
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
```

- **gcc-arm-none-eabi**: The cross-compiler (v13.2.1) targeting ARM EABI  
- **binutils-arm-none-eabi**: Essential binary tools (`ld`, `as`, `objcopy`, `size`)  
- **libnewlib-arm-none-eabi**: Newlib C library providing optimized headers for bare-metal  

### 2. Emulation & Debugging

While `qemu-system-arm` is available via apt, this project utilizes the **xPack QEMU Arm** fork for its enhanced STM32 peripheral simulation (RCC, UART, etc.).

**Toolchain Path Configuration:**
```makefile
# Legacy xPack QEMU for active peripheral simulation
QEMU = $(HOME)/opt/xpack-qemu-arm-2.8.0-12/bin/qemu-system-gnuarmeclipse
```

- **xPack QEMU**: Specialized fork for GNU Arm Eclipse with improved peripheral modeling.
- **gdb-multiarch**: Universal debugger used to interface with the QEMU GDB server.

## Project Structure

The project uses a Platform Abstraction model. Core initialization and peripheral drivers are isolated within the target platform directory.

```text
.
├── include                 # Application-level headers
│   └── main.h
├── main.c                  # Application entry point
├── Makefile                # Master build script
├── platforms
│   └── qemu_stm32f4        # Target: STM32F407VG (Emulated)
│       ├── include
│       │   └── init.h      # Hardware init abstraction
│       ├── init.c          # System clock & FPU setup
│       ├── linker.ld       # Memory map
│       ├── peripherals
│       │   ├── include
│       │   │   └── uart.h  # Register definitions & Prototypes
│       │   └── uart.c      # UART driver (Baud, CR1, DR logic)
│       └── startup.s       # Vector table & Stack pointer setup
└── README.md
```

## Reference & Documentation

### ARM & STM32F407VG Hardware
- **Cortex-M4 Devices Generic User Guide:** [ARM DUI 0553B](https://developer.arm.com/documentation/dui0553/b/)  
  *Refer to Section 4.3 for System Control Block (SCB) details.*
- **Reference Manual (RM0090):** [STM32F405/415 through STM32F429/439](https://www.st.com/resource/en/reference_manual/dm00031020-stm32f405-415-stm32f407-417-stm32f427-437-and-stm32f429-439-advanced-arm-based-32-bit-mcus-stmicroelectronics.pdf)
- **Datasheet:** [STM32F405xx / STM32F407xx](https://www.st.com/resource/en/datasheet/dm00037051.pdf)
- **xPack QEMU Arm:** [GitHub Repository & Releases](https://github.com/xpack-dev-tools/qemu-arm-xpack)

### Toolchain & Assembly
- **Official Arm Toolchain Guide:** [Installing the Arm GNU Toolchain](https://learn.arm.com/install-guides/gcc/arm-gnu/)
- **GCC Option Summary:** [GNU Compiler Collection Manual](https://gcc.gnu.org/onlinedocs/gcc-15.2.0/gcc/Option-Summary.html)
- **GNU Assembler (GAS):** [Symbols & Expressions](https://ftp.gnu.org/old-gnu/Manuals/gas/html_chapter/as_7.html) | [ARM-Specific Directives](https://sourceware.org/binutils/docs/as/ARM-Directives.html)

### Debugging & Visualization
- **GDB Dashboard:** [Modular Visual Interface for GDB](https://github.com/cyrus-and/gdb-dashboard)