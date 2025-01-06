.include "inc/ch32v003.inc"

.global toggle_pins
.global turn_pins_on
.global turn_pins_off

.section .text

toggle_pins:
  # Arguments:
  #   a1: Port address
  #   a2: Pins to toggle

  lw    a4, GPIO_OUTDR(a1)
  xor   a4, a4, a2
  sw    a4, GPIO_OUTDR(a1)

  ret

turn_pins_on:
  # Arguments:
  #   a1: Port address
  #   a2: Pins to turn on

  lw    a4, GPIO_OUTDR(a1)
  or   a4, a4, a2
  sw    a4, GPIO_OUTDR(a1)

  ret

turn_pins_off:
  # Arguments:
  #   a1: Port address
  #   a2: Pins to turn off

  lw    a4, GPIO_OUTDR(a1)
  xori  a2, a2, -1
  and   a4, a4, a2
  sw    a4, GPIO_OUTDR(a1)

  ret
