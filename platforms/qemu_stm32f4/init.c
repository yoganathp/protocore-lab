#include "init.h"

/* Symbols defined in the Linker Script (.ld) */
extern uint32_t _stext, _sdata, _edata, _sidata, _sbss, _ebss;

/**
 * @brief Hardware and Memory System Initialization
 * Performs the essential transition from Assembly Reset to C Environment.
 */
void init(void) {
    // 1. Core Processor Configuration ------------------------------------------------------------
    // 1.1 Set the CPU vector table pointer to the start of Flash memory
    SCB_VTOR = (uint32_t)&_stext;

    // 1.2 TODO: Enable the FPU for floating-point operations

    // 2. Runtime Environment Setup ---------------------------------------------------------------
    // 2.1 Initialize the .data section (Copy initial values from FLASH to SRAM)
    uint32_t *dsc = &_sdata;
    uint32_t *src = &_sidata;
    while (dsc < &_edata) {
        *dsc++ = *src++;
    }

    // 2.2 Initialize the .bss section (Zero out uninitialized globals in SRAM)
    dsc = &_sbss;
    while (dsc < &_ebss) {
        *dsc++ = 0;
    }

    // 3. System Clock and Power Configuration (168MHz Setup) -------------------------------------
    // 3.1 Enable Power Control Clock and Set Voltage Scale 1 (Required for > 144MHz)
    RCC->RCC_APB1ENR = PWR_EN;
    PWR->PWR_CR = VOS_SCALE1; 

    // 3.2 Configure Flash Wait State (5 Latency cycles required for 168MHz @ 3.3V)
    FLASH->FLASH_ACR = (DCEN | ICEN | PRFTEN | LATENCY_WAIT_5);

    // 3.3 Configure the RCC => Internal High Speed (HSI) Oscillator
    RCC->RCC_CR = (HSION | HSITRIM_DEF);
    while(!(IS_HSIRDY(RCC->RCC_CR)));
    
    // 3.4 Configure the Main PLL parameters
    // fVCO_IN = 2MHz, fVCO_OUT = 336MHz, fPLL_P (Sys) = 168MHz, fPLL_Q (USB) = 48MHz
    RCC->RCC_PLLCFGR = PLLCFG_CONFIG(RCC->RCC_PLLCFGR, RCC_PLLSRC_HSI, 8, 168, RCC_PLLP_DIV2, 7);

    // 3.5 Enable the PLL and wait for lock
    RCC->RCC_CR |= PLLON;
    while(!(ISPLLRDY(RCC->RCC_CR))); 

    // 3.6 Configure Bus Prescalers (AHB=1, APB2=2, APB1=4) & Switch System Clock
    RCC->RCC_CFGR = RCC_CFGR_CONFIG(0, APB_DIV2, APB_DIV4, AHB_DIV1, RCC_SW_PLL);
    
    // Wait until the PLL is successfully used as the system clock source
    while(GET_SWS(RCC->RCC_CFGR) != RCC_SW_PLL);

    // 4. Branch to the main application ----------------------------------------------------------
    // main(); 
    
    // 5. Trap loop if main() returns or is not implemented ---------------------------------------
    while(1);
}

/**
 * @brief Hard Fault Exception Handler
 * Overrides the weak alias in startup.s. Called on illegal memory access 
 * or undefined instructions.
 */
void HardFault_Handler(void) {
    while(1);
}