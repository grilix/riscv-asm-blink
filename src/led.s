#
# Alternates pin 3 and 4 in a loop

.include "inc/ch32v003.inc"

.equ GPIOD_SWIO_MASK,          0xf0 # PD1 is SWIO, keep it
.equ COUNTER_LENGTH,           0x200000

.global start
.align 2
.text

j start

setup_peripherals:
  li   a4, RCC_ADDR

  lw    a5, RCC_APB2PCENR(a4)

  # Disable everything
  li    a3, RCC_APB2PCENR_MASK
  and   a5, a5, a3

  # Enable PORTB
  or    a5, a5, RCC_APB2PCENR_IOPD
  sw    a5, RCC_APB2PCENR(a4)

  ret

setup_ports:
  li    a5, GPIOD_ADDR

  lw    a4, GPIO_CFGLR(a5)

  # Keep SWIO, drop everything else
  li    a3, GPIOD_SWIO_MASK
  and   a4, a4, a3

  # Common output configuration
  li    a2, GPIO_MODE_OUT_2MHZ + GPIO_CNF_PUSH_PULL_OUT

  # Pin 4 as Output
  sll   a3, a2, (4*4)
  or    a4, a4, a3

  # Pin 3 as Output
  sll   a3, a2, (4*3)
  or    a4, a4, a3

  sw    a4, GPIO_CFGLR(a5)

  ret

toggle_pins:
  # Arguments:
  #   a1: Port address
  #   a2: Pins to toggle

  sw    a4, GPIO_OUTDR(a1)
  xor   a4, a4, a2
  sw    a4, GPIO_OUTDR(a1)

  ret

start:
  li    sp, STACK_START

  jal   setup_peripherals
  jal   setup_ports

  li    t1, COUNTER_LENGTH

  li    a1, GPIOD_ADDR
  li    a2, (1<<4) # Toggle pin 4 first
  jal   toggle_pins

loop:
  # Do some hard waiting
  addi  t1, t1, -1
  bge   t1, zero, loop

  li    a1, GPIOD_ADDR
  li    a2, (1<<3) + (1<<4) # Toggle pins 3 and 4
  jal   toggle_pins

  li    t1, COUNTER_LENGTH
  j loop
