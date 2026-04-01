ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
    SRAM (xrw) : ORIGIN = 0x20000000, LENGTH = 128K
}

_estack = ORIGIN(SRAM) + LENGTH(SRAM);

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        _stext = .;
        KEEP(*(.vector_table))    /* Place vectors at 0x08000000 */

        . = 0x188;                /* Skip 98-entry IVT (16 System + 82 IRQ) */
        *(.text.Reset_Handler)    /* Place entry code exactly at 0x188 */
        
        *(.text*)                 /* Collect remaining code */
        *(.rodata*)               /* Collect constants */
        *(.rodata.*) 
        . = ALIGN(4);
        _etext = .;
    } > FLASH

    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        _sidata = LOADADDR(.data);
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > SRAM AT > FLASH

    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss*)
        . = ALIGN(4);
        _ebss = .;
    } > SRAM
}