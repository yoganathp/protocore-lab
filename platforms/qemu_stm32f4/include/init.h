#ifndef INIT_H
#define INIT_H
#include "stdint.h"

typedef struct {
    volatile uint32_t RCC_CR;           //0x00
    volatile uint32_t RCC_PLLCFGR;      //0x04
    volatile uint32_t RCC_CFGR;         //0x08
    volatile uint32_t RCC_CIR;          //0x0C

    volatile uint32_t RCC_AHB1RSTR;     //0x10
    volatile uint32_t RCC_AHB2RSTR;     //0x14
    volatile uint32_t RCC_AHB3RSTR;     //0x18

    volatile uint32_t RESERVED1;        //0x1C

    volatile uint32_t RCC_APB1RSTR;     //0x20
    volatile uint32_t RCC_APB2RSTR;     //0x24

    volatile uint32_t RESERVED2[2];     //0x28

    volatile uint32_t RCC_AHB1ENR;      //0x30
    volatile uint32_t RCC_AHB2ENR;      //0x34
    volatile uint32_t RCC_AHB3ENR;      //0x38

    volatile uint32_t RESERVED3;        //0x3C

    volatile uint32_t RCC_APB1ENR;      //0x40
    volatile uint32_t RCC_APB2ENR;      //0x44

    volatile uint32_t RESERVED4[2];     //0x48

    volatile uint32_t RCC_AHB1LPENR;    //0x50
    volatile uint32_t RCC_AHB2LPENR;    //0x54
    volatile uint32_t RCC_AHB3LPENR;    //0x58

    volatile uint32_t RESERVED5;        //0x5C
    
    volatile uint32_t RCC_APB1LPENR;    //0x60
    volatile uint32_t RCC_APB2LPENR;    //0x64

    volatile uint32_t RESERVED6[2];     //0x68

    volatile uint32_t RCC_BDCR;         //0x70
    volatile uint32_t RCC_CSR;          //0x74

    volatile uint32_t RESERVED7[2];     //0x78

    volatile uint32_t RCC_SSCGR;        //0x80
    volatile uint32_t RCC_PLLI2SCFGR;   //0x84
} RCC_MMIO;
#define HSION               (0x1U)
#define HSITRIM_DEF         (0x10U << 3)
#define IS_HSIRDY(REG)      ((REG & 0x2U) >> 1)

#define PLLON               (0x1U << 24)

#define PLLCFG_CLR_MASK  (0x0F43FFFFUL)

#define RCC_PLLSRC_HSI   0x0U
#define RCC_PLLSRC_HSE   0x1U

#define RCC_PLLP_DIV2    0x0U
#define RCC_PLLP_DIV4    0x1U
#define RCC_PLLP_DIV6    0x2U
#define RCC_PLLP_DIV8    0x3U

#define PLLCFG_CONFIG(CURRENT_VAL, PLLSR, PLLM, PLLN, PLLP, PLLQ) \
    (( ((uint32_t)(CURRENT_VAL)) & ~PLLCFG_CLR_MASK) | \
     (((uint32_t)(PLLQ)  & 0x0FU) << 24) | \
     (((uint32_t)(PLLSR) & 0x01U) << 22) | \
     (((uint32_t)(PLLP)  & 0x03U) << 16) | \
     (((uint32_t)(PLLN)  & 0x1FFU) << 6) | \
     (((uint32_t)(PLLM)  & 0x3FU) << 0))

#define RCC_SW_HSI          0x0U
#define RCC_SW_HSE          0x1U
#define RCC_SW_PLL          0x2U

#define AHB_DIV1            0x0U
#define AHB_DIV2            0x8U
#define AHB_DIV4            0x9U
#define AHB_DIV8            0xAU
#define AHB_DIV16           0xBU
#define AHB_DIV64           0xCU
#define AHB_DIV128          0xDU
#define AHB_DIV256          0xEU
#define AHB_DIV512          0xFU

#define APB_DIV1            0x0U
#define APB_DIV2            0x4U
#define APB_DIV4            0x5U
#define APB_DIV8            0x6U
#define APB_DIV16           0x7U

#define RCC_CFGR_CONFIG(RTCPRE, PPRE2, PPRE1, HPRE, SW) \
    ((((uint32_t)(RTCPRE) & 0x1FU) << 16) | \
     (((uint32_t)(PPRE2)  & 0x07U) << 13) | \
     (((uint32_t)(PPRE1)  & 0x07U) << 10) | \
     (((uint32_t)(HPRE)   & 0x0FU) <<  4) | \
     (((uint32_t)(SW)     & 0x03U) <<  0))

#define GET_SWS(REG)      (((uint32_t)(REG) & 0x0CU) >> 2)


#define AHB1_BASE           (0x40020000UL)
#define RCC_OFFSET          (0x00003800UL)

#define RCC                 ((RCC_MMIO*)(AHB1_BASE + RCC_OFFSET))

#endif