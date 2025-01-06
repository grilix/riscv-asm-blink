PROJECT := led

PREFIX := riscv64-unknown-elf

all: build_dir build/$(PROJECT).o build/$(PROJECT).bin
build_dir: build/

.PHONY: all build_dir

AS := $(PREFIX)-as
LD := $(PREFIX)-ld

OBJECTS := build/$(PROJECT).o build/gpio.o build/startup.o
ASFLAGS := -march=rv32ec_zicsr -mabi=ilp32e
LDFLAGS := -T link.ld -nostdlib -m elf32lriscv --print-memory-usage --gc-sections

build/%.o: src/%.s
	$(AS) $(ASFLAGS) -o $@ $<

#build/%.bin: build/%.o
#	$(PREFIX)-objcopy -O binary $< $@

build/%.bin: build/%.elf
	$(PREFIX)-objcopy -O binary $< $@

build/$(PROJECT).elf: $(OBJECTS)
	$(LD) $(LDFLAGS) -m elf32lriscv -o $@ $^
	#$(PREFIX)-ld -m elf32lriscv -o $@ $<

disa: build/$(PROJECT).elf
	$(PREFIX)-objdump -d --disassemble-zeroes $<

build/:
	mkdir -p build

flash: all
	minichlink -w build/$(PROJECT).bin flash -b
