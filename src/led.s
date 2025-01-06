#
# Alternates pin 3 and 4 in a loop

.include "inc/ch32v003.inc"

.global TIM2_IRQHandler
.global start

.equ GPIOD_SWIO_MASK,          0xf0 # PD1 is SWIO, keep it
.equ COUNTER_LENGTH,           0x200000

.equ PFIC_BASE,  0xE000E000
.equ PFIC_IENR1, 0x100
.equ PFIC_IENR2, 0x104
.equ PFIC_ISR2, 0x04
.equ PFIC_GISR, 0x4c

.equ LED_IRQ, (1<<3)
.equ LED_CNT, (1<<4)

.equ COUNTER_MAX, 200
.equ COUNTER_MATCH, 130
.equ COUNTER_COUNT, 130

.section .text
.align 2

.macro STACK_HOLD n
  addi  sp, sp, -(4*\n)
.endm

.macro STACK_RELEASE n
  addi  sp, sp, (4*\n)
.endm

TIM2_IRQHandler:
  STACK_HOLD(5)
  sw    ra, 0(sp)
  sw    a1, 4(sp)
  sw    a2, 8(sp)
  sw    a3, 12(sp)
  sw    a4, 16(sp)
  li    a1, TIM2_BASE
  lh    a4, TIM2_INTFR(a1)
  li    a2, (1<<1) # CC1IF
  and   a3, a4, a2                     # Match?
  bne   a3, a2, L_TIM2_over
  not   a2, a2                         # Clear flag
  and   a4, a4, a2
  sh    a4, TIM2_INTFR(a1)
  li    a1, GPIOD_ADDR                 # Toggle LED
  li    a2, LED_IRQ
  jal   toggle_pins

L_TIM2_over:
  lw    a4, 16(sp)
  lw    a3, 12(sp)
  lw    a2, 8(sp)
  lw    a1, 4(sp)
  lw    ra, 0(sp)
  STACK_RELEASE(5)

  mret

setup_peripherals:
  li    a1, RCC_ADDR

  lw    a4, RCC_APB1PCENR(a1)          # Enable TIM2
  ori   a4, a4, (1<<0) # TIM2EN
  sw    a4, RCC_APB1PCENR(a1)

  lw    a5, RCC_APB2PCENR(a1)
  li    a3, RCC_APB2PCENR_MASK         # Reset settings
  and   a5, a5, a3
  ori   a5, a5, RCC_APB2PCENR_IOPD     # Enable PD
  ori   a5, a5, RCC_APB2PCENR_IOPC     # Enable PC
  #ori   a5, a5, RCC_APB2PCENR_AFIO     # Enable AFIO? TODO
  sw    a5, RCC_APB2PCENR(a1)

  ret

setup_ports:
  # Common port configuration: 10Mhz/PP
  li    a2, GPIO_MODE_OUT_10MHZ + GPIO_CNF_PUSH_PULL_OUT

  li    a5, GPIOD_ADDR                 # PD
  lw    a4, GPIO_CFGLR(a5)
  li    a3, GPIOD_SWIO_MASK            # Mask SWIO
  and   a4, a4, a3
  sll   a3, a2, (4*4)                  # Set pin as output
  or    a4, a4, a3
  sll   a3, a2, (4*3)                  # Set pin as output
  or    a4, a4, a3
  sw    a4, GPIO_CFGLR(a5)

  ret

enable_irq:
  # arguments:
  #  a1: IRQn

  # IRQ locations: (Section 6.5.2)
  # R2: 0x108 <-------------------RESERVED------------------>
  # R2: 0x104 <--------RESERVED-------->|38|37|36|35|34|33|32
  # R1: 0x102 31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16
  # R1: 0x100 --|14|--|12|<-------------RESERVED------------>

  srli  a2, a1, 5                      # Register: 0=IENR1|1=IENR2
  slli  a2, a2, 2                      # Address offset (register * 4)

  andi  t2, a1, 0x1f                   # Calculate bit index
  li    t1, 1
  sll   a1, t1, t2
  li    a3, PFIC_BASE
  addi  a3, a3, PFIC_IENR1
  add   a3, a3, a2

  sw    a1, 0(a3)

  ret

setup_timers:
  STACK_HOLD(1)
  sw    ra, 0(sp)

  li   a1, TIM2_BASE                   # TIM2 Setup
  li   a4, 10000                       # Set prescaling
  sh   a4, TIM2_PSC(a1) # 16 bits

  # TODO: this needed?
  #lh   a4, TIM2_CHCTLR1(a1)            # 16 bits record
  #ori   a4, a4, (1<<3) # OC1PE
  ##ori   a4, a4, (1<<7) # ARPE
  #sh   a4, TIM2_CHCTLR1(a1)            # Comparator setup

  # Set channel 1 value
  li   a4, COUNTER_MATCH
  sh   a4, TIM2_CH1CVR(a1)             # 16 bits record
  lh   a4, TIM2_DMAINTENR(a1)          # 16 bits record
  ori  a4, a4, (1<<1) # CC1IE
  sh   a4, TIM2_DMAINTENR(a1)          # Enable interrupts

  lh   a4, TIM2_CCER(a1)               # 16 bits record
                                       # Enable compare channel 1
  ori  a4, a4, (1<<0) # CC1E
  sh   a4, TIM2_CCER(a1)

  lh   a4, TIM2_SWEVGR(a1)
  ori  a4, a4, (1<<0) # UG
  sw   a4, TIM2_SWEVGR(a1)

  li   a4, COUNTER_MAX                 # Counter setup
  sh   a4, TIM2_ATRLR(a1)              # 16 bits record

  lh   a4, TIM2_CTLR1(a1)              # 16 bits record
  li   a2, (1<<4)                      # Count UP
  not   a2, a2                         # Disable bit
  and   a4, a4, a2
                                       # Enable counter
  ori   a4, a4, (1<<0) # CEN
  sh    a4, TIM2_CTLR1(a1)

  li    a1, 38                         # Enable TIM2 interrupts
  jal   enable_irq

  lw    ra, 0(sp)
  STACK_RELEASE(1)

  ret

start:
  jal   setup_peripherals
  jal   setup_ports
  jal   setup_timers

L_loop_start:
  li    a1, TIM2_BASE
  lh    a4, TIM2_CNT(a1)
  li    a3, COUNTER_COUNT
  blt   a4, a3, L_loop_lt              # Check counter
  li    a1, GPIOD_ADDR
  li    a2, LED_CNT
  jal   turn_pins_off

  j     L_loop_start

L_loop_lt:
  li    a1, GPIOD_ADDR
  li    a2, LED_CNT
  jal   turn_pins_on

  j     L_loop_start
