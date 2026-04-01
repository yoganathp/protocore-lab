# --- Toolchain ---
CC      = arm-none-eabi-gcc
AS      = arm-none-eabi-as
LD      = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
QEMU    = qemu-system-arm
GDB     = gdb-multiarch

# --- Emulation Config ---
MCU         = cortex-m4
TARGET_MACH = netduinoplus2

# --- Project Paths ---
SRC     = platforms/qemu_stm32f4/startup.s
SRC1	= platforms/qemu_stm32f4/init.c
LNK     = platforms/qemu_stm32f4/linker.ld
BUILD   = build
ELF     = $(BUILD)/protocore.elf
BIN     = $(BUILD)/protocore.bin
MAP     = $(BUILD)/protocore.map

# --- Flags ---
FLAGS = -mcpu=$(MCU) -mthumb -g
LDFLAGS = -T $(LNK) -Map $(MAP)

# --- Rules ---

.PHONY: all clean debug qemu gdb

all: $(BIN)
	@

# 1. Assemble startup.s -> startup.o
$(BUILD)/startup.o: $(SRC)
	@mkdir -p $(BUILD)
	$(AS) $(FLAGS) $< -o $@

# 2. Compile init.c -> init.o
$(BUILD)/init.o: $(SRC1)
	@mkdir -p $(BUILD)
	$(CC) $(FLAGS) -c $< -o $@

# 3. Link them together
$(ELF): $(BUILD)/startup.o $(BUILD)/init.o
	$(LD) $(LDFLAGS) $^ -o $@

# 4. Create raw binary
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
	@echo "---------------------------------------"
	@echo "Build Successful: $(ELF)"
	@echo "---------------------------------------"

# --- Qemu with GDB ---
qemu: $(ELF)
	$(QEMU) -machine $(TARGET_MACH) -cpu $(MCU) -kernel $(ELF) -nographic -S -gdb tcp::1234

gdb: $(ELF)
	$(GDB) $(ELF) -ex "target remote localhost:1234"

clean:
	rm -rf $(BUILD)