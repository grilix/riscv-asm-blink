# RISC-V ASM blink

This is a minimal blink implementation for the CH32V003, a RISC-V based microcontroller.

It is intended to document the process of writing applications for this chip in assembly.

# WIP Status

This code is still WIP, but already works. It includes handling interrupts and multiple
definitions for the registers and their options.

The definitions are based on the datasheet names and values, but
many are missing; I'll be reworking them and adding more as I see fit.

The linker script was partially generated by the GCC (or something) but seems to work fine,
 I'm not too familiar with that part, so I'm not touching that too much now.

# Makefile

`make flash` to build and flash.
