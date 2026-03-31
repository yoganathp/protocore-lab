.syntax unified
.cpu cortex-m4
.thumb

.section .vector_table, "a"
    .word _estack           @ 0x00: Initial Stack Pointer (from linker.ld)
    .word Reset_Handler     @ 0x04: Reset Vector (Entry point)
    

.section .text.Reset_Handler, "ax", %progbits
.global Reset_Handler
.type Reset_Handler, %function
Reset_Handler:

    @ add test
    mov r1, #1
    mov r2, #2
    add r3, r1, r2
    
    @ bl main           @ Call main    
    b .                 @ Infinite loop
