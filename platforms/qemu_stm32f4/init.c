#include "init.h"

extern uint32_t _sdata, _edata, _sidata, _sbss, _ebss;

void init(void);
void init(void) {
    // 1. Initialize the .data section (Copy from FLASH to SRAM)
    uint32_t *dsc = &_sdata;
    uint32_t *src = &_sidata;
    while (dsc < &_edata) {
        *dsc++ = *src++;
    }

    // 2. Initialize the .bss section (Zero out SRAM)
    dsc = &_sbss;
    while (dsc < &_ebss) {
        *dsc++ = 0;
    }

    // 3. Configure the RCC => HSI
    RCC->RCC_CR = (HSION | HSITRIM_DEF);
    while(!(IS_HSIRDY(RCC->RCC_CR)));

    // TODO: Enable Power Control Clock and Set Voltage Scale
    // TODO: Configure Flash Wait State
    
    // 4 Configure the RCC => PLL => to max system frequency
    // Prepare Input (Range: 1-2MHz):     fVCO_IN  = fHSI / M          = 16MHz / 8   = 2MHz
    // Set Internal (Range: 192-432MHz):  fVCO_OUT = fVCO_IN * N       = 2MHz * 168  = 336MHz
    // SysClock (Max: 168MHz):            fPLL_P   = fVCO_OUT / P      = 336MHz / 2  = 168MHz
    // USB Clock (Target: 48MHz):         fPLL_Q   = fVCO_OUT / Q      = 336MHz / 7  = 48MHz
    RCC->RCC_PLLCFGR = PLLCFG_CONFIG(RCC->RCC_PLLCFGR, RCC_PLLSRC_HSI, 8, 168, RCC_PLLP_DIV2, 7);

    // 5 Configure the RCC => Bus Prescalers & System Clock Switch
    // AHB Bus (Max: 168MHz):             fHCLK    = fSYSCLK / HPRE    = 168MHz / 1  = 168MHz
    // APB2 Bus (Max: 84MHz):             fPCLK2   = fHCLK / PPRE2     = 168MHz / 2  = 84MHz
    // APB1 Bus (Max: 42MHz):             fPCLK1   = fHCLK / PPRE1     = 168MHz / 4  = 42MHz
    // System Clock Switch:               Select PLL as SYSCLK source
    RCC->RCC_CFGR = RCC_CFGR_CONFIG(0, APB_DIV2, APB_DIV4, AHB_DIV1, RCC_SW_PLL);
    RCC->RCC_CR |= PLLON;
    while (GET_SWS(RCC->RCC_CFGR) != RCC_SW_PLL);
    // TODO: Check the PLL and SW sequence 

    // 3. Branch to the application
    // main(); 
    
    // Safety loop if main is not yet implemented
    while(1);
}