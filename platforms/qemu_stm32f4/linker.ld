ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
    SRAM (xrw) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* Define the top of the stack (End of RAM) */
_estack = ORIGIN(SRAM) + LENGTH(SRAM);

SECTIONS
{
    /* 1. The Code and Read-Only Data */
    .text :
    {
        . = ALIGN(512);           /* Align for Cortex-M4 VTOR requirements */
        _stext = .;               /* Symbol for SCB->VTOR in init.c */
        
        KEEP(*(.vector_table))    /* Place the full vector table first */
        
        . = ALIGN(4);
        *(.text.Reset_Handler)    /* Ensure Reset_Handler is prioritized */
        *(.text*)                 /* All other C and Assembly functions */
        *(.rodata*)               /* Read-only constants/strings */
        *(.rodata.*)
        
        . = ALIGN(4);
        _etext = .;               /* End of code in Flash */
    } > FLASH

    /* 2. Initialized Data (Copied from Flash to RAM at startup) */
    .data :
    {
        . = ALIGN(4);
        _sdata = .;               /* RAM Start address */
        *(.data*)
        . = ALIGN(4);
        _edata = .;               /* RAM End address */
    } > SRAM AT > FLASH           /* Live in RAM, stored in FLASH */

    /* Used by init.c to perform the copy loop */
    _sidata = LOADADDR(.data);

    /* 3. Uninitialized Data (Zeroed at startup) */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;               /* Start of BSS */
        *(.bss*)
        *(COMMON)                 /* Standard C uninitialized globals */
        . = ALIGN(4);
        _ebss = .;               /* End of BSS */
    } > SRAM

    /* Discard unnecessary sections */
    /DISCARD/ :
    {
        *(.comment)
        *(.ARM.attributes)
    }
}