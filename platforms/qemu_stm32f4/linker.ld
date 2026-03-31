ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
    SRAM (xrw) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* Defensive stack: points to the last valid 4-byte word in RAM */
_estack = ORIGIN(SRAM) + LENGTH(SRAM) - 4;

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        KEEP(*(.vector_table))    /* Place vectors at 0x08000000 */

        . = 0x188;                /* Skip 98-entry IVT (16 System + 82 IRQ) */
        *(.text.Reset_Handler)    /* Place entry code exactly at 0x188 */
        
        *(.text*)                 /* Collect remaining code */
        *(.rodata*)               /* Collect constants */
        . = ALIGN(4);
    } > FLASH
}