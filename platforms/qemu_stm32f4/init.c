#include <stdint.h>

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

    // 3. Branch to the application
    // main(); 
    
    // Safety loop if main is not yet implemented
    while(1);
}