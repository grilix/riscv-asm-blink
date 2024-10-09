# vim:syntax=asm
# WIP. Version: 0.2024-10-10

.equ STACK_START,              0x20000000
.equ RCC_ADDR,                 0x40021000

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
