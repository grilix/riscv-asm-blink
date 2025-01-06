.include "inc/ch32v003.inc"

.option push
.nolist
.equ INTSYSCR, 0x804
.option pop

.section .init
.align 4

.global _start

_start:
.option push
.option norvc
  j reset_handler

.word   0
.word   0               # NMI Handler
.word   0         # Hard Fault Handler
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0           # SysTick Handler
.word   0
.word   0                # SW Handler
.word   0
# External Interrupts
.word   0           # Window Watchdog
.word   0            # PVD through EXTI Line detect
.word   0          # Flash
.word   0            # RCC
.word   0        # EXTI Line 7..0
.word   0            # AWU
.word   0  # DMA1 Channel 1
.word   0  # DMA1 Channel 2
.word   0  # DMA1 Channel 3
.word   0  # DMA1 Channel 4
.word   0  # DMA1 Channel 5
.word   0  # DMA1 Channel 6
.word   0  # DMA1 Channel 7
.word   0           # ADC1
.word   0        # I2C1 Event
.word   0        # I2C1 Error
.word   0         # USART1
.word   0           # SPI1
.word   0       # TIM1 Break
.word   0        # TIM1 Update
.word   0   # TIM1 Trigger and Commutation
.word   0        # TIM1 Capture Compare
.word   TIM2_IRQHandler           # TIM2

.option pop

.text
.align 2

reset_handler:
  la    sp, _eusrstack # STACK_START

  li    t0, 0x80
  csrw  mstatus, t0

  li    t0, 0x2 # 0b11
  csrw  INTSYSCR, t0                   # Enable nesting, not HPE

  la    t0, _start
  ori   t0, t0, 0b11
  csrw  mtvec, t0

  la    t0, start                      # Jump to app
  csrw  mepc, t0
  mret
