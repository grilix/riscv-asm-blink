PROJECT := led

PREFIX := riscv64-unknown-elf

all: build_dir build/$(PROJECT).bin
build_dir: build/

.PHONY: all build_dir

build/%.o: src/%.s
	$(PREFIX)-as -march=rv32ec -mabi=ilp32e -o $@ $<

build/%.bin: build/%.o
	$(PREFIX)-objcopy -O binary $< $@

build/:
	mkdir -p build

flash: all
	minichlink -w build/$(PROJECT).bin flash -b
