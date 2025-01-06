# vim:syntax=asm
# WIP. Version: 0.2025-01-05

.option push
.nolist
.equ STACK_START,              0x20000800
.equ RCC_ADDR,                 0x40021000

.equ TIM2_BASE,            0x40000000

# Timer 2
.equ TIM2_CTLR1,           0x00 # TIM2 control register 1
.equ TIM2_CTLR2,           0x04 # TIM2 control register 2
.equ TIM2_SMCFGR,          0x08 # TIM2 Slave mode control register
.equ TIM2_DMAINTENR,       0x0c # TIM2 DMA/Int enable register
.equ TIM2_INTFR,           0x10 # TIM2 int status register
.equ TIM2_SWEVGR,          0x14 # TIM2 event generation register
.equ TIM2_CHCTLR1,         0x18 # TIM2 comp/capture control register 1
.equ TIM2_CHCTLR2,         0x1c # TIM2 comp/capture control register 2
.equ TIM2_CCER,            0x20 # TIM2 comp/capture enable register
.equ TIM2_CNT,             0x24 # TIM2 counter
.equ TIM2_PSC,             0x28 # TIM2 count clock prescaler
.equ TIM2_ATRLR,           0x2c # TIM2 auto-reload register
.equ TIM2_CH1CVR,          0x34 # TIM2 comp/capture register 1
.equ TIM2_CH2CVR,          0x38 # TIM2 comp/capture register 2
.equ TIM2_CH3CVR,          0x3c # TIM2 comp/capture register 3
.equ TIM2_CH4CVR,          0x40 # TIM2 comp/capture register 4
.equ TIM2_DMACFGR,         0x48 # TIM2 DMA control register
.equ TIM2_DMAADR,          0x4c # TIM2 DMA address register in continuous mode

.equ GPIO_BASE,            0x40010000

.equ GPIO_CFGLR,               0x00
.equ GPIO_OUTDR,               0x0c

# GPIO CNF
# Input mode
.equ GPIO_CNF_ANALOG_IN,       0b0000
.equ GPIO_CNF_FLOATING_IN,     0b0100
.equ GPIO_CNF_P_UP_P_DOWN_IN,  0b1000
# Output mode
.equ GPIO_CNF_PUSH_PULL_OUT,   0b0000
.equ GPIO_CNF_OPEN_DRAIN_OUT,  0b0100
.equ GPIO_CNF_MULTI_PP_OUT,    0b1000
.equ GPIO_CNF_MULTI_OD_OUT,    0b1100
# GPIO MODE
.equ GPIO_MODE_INPUT,          0b00
.equ GPIO_MODE_OUT_10MHZ,      0b01
.equ GPIO_MODE_OUT_2MHZ,       0b10
.equ GPIO_MODE_OUT_50MHZ,      0b11

.equ GPIOA_ADDR,               GPIO_BASE + 0x0800
.equ GPIOC_ADDR,               GPIO_BASE + 0x1000
.equ GPIOD_ADDR,               GPIO_BASE + 0x1400

.equ RCC_INTR,                 0x04
.equ RCC_APB2PCENR,            0x18 # +24
.equ RCC_APB2PCENR_MASK,       0xffffa5ca # reserved bits, keep them

.equ RCC_APB2PCENR_AFIO,       (1<<0)
.equ RCC_APB2PCENR_IOPA,       (1<<2)
.equ RCC_APB2PCENR_IOPC,       (1<<4)
.equ RCC_APB2PCENR_IOPD,       (1<<5)
.equ RCC_APB2PCENR_ADC1,       (1<<9)
.equ RCC_APB2PCENR_TIM1,       (1<<11)
.equ RCC_APB2PCENR_SPI1,       (1<<12)
.equ RCC_APB2PCENR_USART1,     (1<<12)

.equ RCC_APB1PCENR,            0x1C
.option pop
