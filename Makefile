# --- Toolchain ---
TOOL_PATH = arm-none-eabi-
CC      = $(TOOL_PATH)gcc
AS      = $(TOOL_PATH)as
LD      = $(TOOL_PATH)ld
OBJCOPY = $(TOOL_PATH)objcopy

# Legacy xPack QEMU for active peripheral simulation
QEMU    = $(HOME)/opt/xpack-qemu-arm-2.8.0-12/bin/qemu-system-gnuarmeclipse

GDB     = gdb-multiarch

# --- Project Paths ---
BUILD_DIR = build
SRC_DIR   = platforms/qemu_stm32f4

SRCS      = $(SRC_DIR)/startup.s $(SRC_DIR)/init.c
OBJS      = $(BUILD_DIR)/startup.o $(BUILD_DIR)/init.o

ELF       = $(BUILD_DIR)/protocore.elf
BIN       = $(BUILD_DIR)/protocore.bin
MAP       = $(BUILD_DIR)/protocore.map
LNK       = $(SRC_DIR)/linker.ld
INC       = -I$(SRC_DIR)/include/

# --- Flags ---
MCU_FLAGS = -mcpu=cortex-m4 -mthumb -g
CFLAGS    = $(MCU_FLAGS) $(INC) -O0 -Wall
ASFLAGS   = $(MCU_FLAGS)
LDFLAGS   = -T $(LNK) -Map $(MAP)

# --- Rules ---
.PHONY: all clean qemu gdb

all: $(BIN)

# Directory creation
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Compile/Assemble
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s | $(BUILD_DIR)
	@echo "Assembling $<..."
	@$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -c $< -o $@

# Link
$(ELF): $(OBJS)
	@echo "Linking $@..."
	@$(LD) $(LDFLAGS) $^ -o $@

# Binary extraction
$(BIN): $(ELF)
	@$(OBJCOPY) -O binary $< $@
	@echo "---------------------------------------"
	@echo "Build Successful: $@"
	@echo "---------------------------------------"

# --- Emulation & Debugging ---
qemu: $(ELF)
	@echo "Starting QEMU in stop-mode, waiting for GDB..."
	@$(QEMU) \
		--board STM32F4-Discovery \
		--mcu STM32F407VG \
		-d unimp,guest_errors \
		--image $(ELF) \
		--semihosting-config enable=on \
		-nographic -S -gdb tcp::1234

gdb: $(ELF)
	@$(GDB) $(ELF) \
		-ex "set architecture armv7e-m" \
		-ex "target remote localhost:1234"

clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleaned."