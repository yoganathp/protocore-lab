.syntax unified
.cpu cortex-m4
.thumb

.global init

.section .vector_table, "a"
    .word _estack               @ 0x00: Initial Stack Pointer (from linker.ld)
    .word Reset_Handler         @ 0x04: Reset Vector (Entry point)
    
.section .text.Reset_Handler, "ax", %progbits
.global Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    bl init                     @ Call init

.section .text.Default_Handler, "ax", %progbits
Default_Handler:
Loop:   
    b Loop                      @ Infinite loop
