.syntax unified
.cpu cortex-m4
.thumb

/* --- Vector Table --- */
.section .vector_table, "a"
    .word _estack               @ 0x00: Initial Stack Pointer
    .word Reset_Handler         @ 0x04: Reset Vector
    .word NMI_Handler           @ 0x08: Non-Maskable Interrupt
    .word HardFault_Handler     @ 0x0C: Hard Fault (The "Catch All" for errors)
    .word MemManage_Handler     @ 0x10: MPU Fault
    .word BusFault_Handler      @ 0x14: Bus Fault
    .word UsageFault_Handler    @ 0x18: Usage Fault (Undefined instruction)
    .word 0                     @ 0x1C: Reserved
    .word 0                     @ 0x20: Reserved
    .word 0                     @ 0x24: Reserved
    .word 0                     @ 0x28: Reserved
    .word SVC_Handler           @ 0x2C: System Service Call
    .word DebugMon_Handler      @ 0x30: Debug Monitor
    .word 0                     @ 0x34: Reserved
    .word PendSV_Handler        @ 0x38: PendSV (Context switching)
    .word SysTick_Handler       @ 0x3C: System Tick Timer

    /* External Interrupts (IRQs) start at 0x40 */
    /* ... Specific IRQs will be added here as if needed ... */

/* --- Code Section --- */
.section .text.Reset_Handler, "ax", %progbits
.global Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    @ The stack pointer is set automatically by hardware from 0x00
    bl init                     @ Call init function -> Initialize memory, clocks, VTOR
    bl main                     @ Call main function -> Enter the application

/* --- Default Handler --- */
.section .text.Default_Handler, "ax", %progbits
.global Default_Handler
.type Default_Handler, %function
Default_Handler:
    b .                         @ Infinite loop

/* * Weak Aliases: 
 * These map every handler to Default_Handler. 
 * If you write 'void HardFault_Handler(void)' in C, 
 * the C version will automatically override these.
 */
.weak NMI_Handler
.thumb_set NMI_Handler, Default_Handler

.weak HardFault_Handler
.thumb_set HardFault_Handler, Default_Handler

.weak MemManage_Handler
.thumb_set MemManage_Handler, Default_Handler

.weak BusFault_Handler
.thumb_set BusFault_Handler, Default_Handler

.weak UsageFault_Handler
.thumb_set UsageFault_Handler, Default_Handler

.weak SVC_Handler
.thumb_set SVC_Handler, Default_Handler

.weak DebugMon_Handler
.thumb_set DebugMon_Handler, Default_Handler

.weak PendSV_Handler
.thumb_set PendSV_Handler, Default_Handler

.weak SysTick_Handler
.thumb_set SysTick_Handler, Default_Handler
