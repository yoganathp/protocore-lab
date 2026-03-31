# Toolchain Setup
CC      = arm-none-eabi-gcc
AS      = arm-none-eabi-as
LD      = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy

# Project Paths
SRC     = platforms/qemu_stm32f4/startup.s
LNK     = platforms/qemu_stm32f4/linker.ld
BUILD   = build
ELF     = $(BUILD)/protocore.elf
BIN     = $(BUILD)/protocore.bin
MAP     = $(BUILD)/protocore.map

# Flags
ASFLAGS = -mcpu=cortex-m4 -mthumb -g
LDFLAGS = -T $(LNK) -Map $(MAP)

# --- Rules ---

all: $(BIN)

# 1. Assemble .s to .o
$(BUILD)/startup.o: $(SRC)
	@mkdir -p $(BUILD)
	$(AS) $(ASFLAGS) $(SRC) -o $@

# 2. Link .o to .elf (and generate .map)
$(ELF): $(BUILD)/startup.o
	$(LD) $(LDFLAGS) $< -o $@

# 3. Create raw binary for hardware/QEMU
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
	@echo "Build Successful: $(ELF)"

clean:
	rm -rf $(BUILD)