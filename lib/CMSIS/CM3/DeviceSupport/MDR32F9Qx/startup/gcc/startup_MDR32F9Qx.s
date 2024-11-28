/* File: startup_ARMCM3.S
 * Purpose: startup file for Cortex-M3 devices. Should use with
 *   GCC for ARM Embedded Processors
 * Version: V2.0
 * Date: 16 August 2013
 *
 * Copyright (c) 2011 - 2013 ARM LIMITED

   All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:
   - Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
   - Neither the name of ARM nor the names of its contributors may be used
     to endorse or promote products derived from this software without
     specific prior written permission.
   *
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
   ---------------------------------------------------------------------------*/
	.syntax	unified
	.arch	armv7-m

	.section .stack
	.align	3
#ifdef __STACK_SIZE
	.equ	Stack_Size, __STACK_SIZE
#else
	.equ	Stack_Size, 0xc00
#endif
	.globl	__StackTop
	.globl	__StackLimit
__StackLimit:
	.space	Stack_Size
	.size	__StackLimit, . - __StackLimit
__StackTop:
	.size	__StackTop, . - __StackTop

	.section .heap
	.align	3
#ifdef __HEAP_SIZE
	.equ	Heap_Size, __HEAP_SIZE
#else
	.equ	Heap_Size, 0
#endif
	.globl	__HeapBase
	.globl	__HeapLimit
__HeapBase:
	.if	Heap_Size
	.space	Heap_Size
	.endif
	.size	__HeapBase, . - __HeapBase
__HeapLimit:
	.size	__HeapLimit, . - __HeapLimit

	.section .isr_vector
	.align	2
	.globl	__isr_vector
__isr_vector:
	.long	__StackTop            /* Top of Stack */
	.long	Reset_Handler         /* Reset Handler */
	.long	NMI_Handler           /* NMI Handler */
	.long	HardFault_Handler     /* Hard Fault Handler */
	.long	MemManage_Handler     /* MPU Fault Handler */
	.long	BusFault_Handler      /* Bus Fault Handler */
	.long	UsageFault_Handler    /* Usage Fault Handler */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	SVC_Handler           /* SVCall Handler */
	.long	DebugMon_Handler      /* Debug Monitor Handler */
	.long	0                     /* Reserved */
	.long	PendSV_Handler        /* PendSV Handler */
	.long	SysTick_Handler       /* SysTick Handler */

	/* External interrupts */
	.long	CAN1_IRQHandler       /* IRQ0 */
	.long	CAN2_IRQHandler       /* IRQ1 */
	.long	USB_IRQHandler        /* IRQ2 */
	.long	0                     /* IRQ3  reserved */
	.long	0                     /* IRQ4  reserved */
	.long	DMA_IRQHandler        /* IRQ5 */
	.long	UART1_IRQHandler      /* IRQ6 */
	.long	UART2_IRQHandler      /* IRQ7 */
	.long	SSP1_IRQHandler       /* IRQ8 */
	.long	0                     /* IRQ9  reserved */
	.long	I2C_IRQHandler        /* IRQ10 */
	.long	POWER_IRQHandler      /* IRQ11 */
	.long	WWDG_IRQHandler       /* IRQ12 */
	.long	0                     /* IRQ13 reserved */
	.long	Timer1_IRQHandler     /* IRQ14 */
	.long	Timer2_IRQHandler     /* IRQ15 */
	.long	Timer3_IRQHandler     /* IRQ16 */
	.long	ADC_IRQHandler        /* IRQ17 */
	.long	0                     /* IRQ18 reserved */
	.long	COMPARATOR_IRQHandler /* IRQ19 */
	.long	SSP2_IRQHandler       /* IRQ20 */
	.long	0                     /* IRQ21 reserved */
	.long	0                     /* IRQ22 reserved */
	.long	0                     /* IRQ23 reserved */
	.long	0                     /* IRQ24 reserved */
	.long	0                     /* IRQ25 reserved */
	.long	0                     /* IRQ26 reserved */
	.long	BACKUP_IRQHandler     /* IRQ27 */
	.long	EXT_INT1_IRQHandler   /* IRQ28 */
	.long	EXT_INT2_IRQHandler   /* IRQ29 */
	.long	EXT_INT3_IRQHandler   /* IRQ30 */
	.long	EXT_INT4_IRQHandler   /* IRQ31 */

	.size	__isr_vector, . - __isr_vector

	.text
	.thumb
	.thumb_func
	.align	2
	.globl	Reset_Handler
	.type	Reset_Handler, %function
Reset_Handler:
/*  Firstly it copies data from read only memory to RAM. There are two schemes
 *  to copy. One can copy more than one sections. Another can only copy
 *  one section.  The former scheme needs more instructions and read-only
 *  data to implement than the latter.
 *  Macro __STARTUP_COPY_MULTIPLE is used to choose between two schemes.  */
/*  Single section scheme.
 *
 *  The ranges of copy from/to are specified by following symbols
 *    __etext: LMA of start of the section to copy from. Usually end of text
 *    __data_start__: VMA of start of the section to copy to
 *    __data_end__: VMA of end of the section to copy to
 *
 *  All addresses must be aligned to 4 bytes boundary.
 */
	ldr	r1, =__etext
	ldr	r2, =__data_start__
	ldr	r3, =__data_end__

.L_loop1:
	cmp	r2, r3
	ittt	lt
	ldrlt	r0, [r1], #4
	strlt	r0, [r2], #4
	blt	.L_loop1

/*  This part of work usually is done in C library startup code. Otherwise,
 *  define this macro to enable it in this startup.
 *
 *  There are two schemes too. One can clear multiple BSS sections. Another
 *  can only clear one section. The former is more size expensive than the
 *  latter.
 *
 *  Define macro __STARTUP_CLEAR_BSS_MULTIPLE to choose the former.
 *  Otherwise define macro __STARTUP_CLEAR_BSS to choose the later.
 */
/*  Single BSS section scheme.
 *
 *  The BSS section is specified by following symbols
 *    __bss_start__: start of the BSS section.
 *    __bss_end__: end of the BSS section.
 *
 *  Both addresses must be aligned to 4 bytes boundary.
 */
	ldr	r1, =__bss_start__
	ldr	r2, =__bss_end__

	movs	r0, #0
.L_loop3:
	cmp	r1, r2
	itt	lt
	strlt	r0, [r1], #4
	blt	.L_loop3

#ifndef __NO_SYSTEM_INIT
	bl	SystemInit
#endif

	bl	_start

	.pool
	.size	Reset_Handler, . - Reset_Handler

	.align	1
	.thumb_func
	.weak	Default_Handler
	.type	Default_Handler, %function
Default_Handler:
	b	.
	.size	Default_Handler, . - Default_Handler

/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
	.macro	def_irq_handler	handler_name
	.weak	\handler_name
	.set	\handler_name, Default_Handler
	.endm

	def_irq_handler NMI_Handler
	def_irq_handler HardFault_Handler
	def_irq_handler MemManage_Handler
	def_irq_handler BusFault_Handler
	def_irq_handler UsageFault_Handler
	def_irq_handler SVC_Handler
	def_irq_handler DebugMon_Handler
	def_irq_handler PendSV_Handler
	def_irq_handler SysTick_Handler

	def_irq_handler CAN1_IRQHandler
	def_irq_handler CAN2_IRQHandler
	def_irq_handler USB_IRQHandler
	def_irq_handler DMA_IRQHandler
	def_irq_handler UART1_IRQHandler
	def_irq_handler UART2_IRQHandler
	def_irq_handler SSP1_IRQHandler
	def_irq_handler I2C_IRQHandler
	def_irq_handler POWER_IRQHandler
	def_irq_handler WWDG_IRQHandler
	def_irq_handler Timer1_IRQHandler
	def_irq_handler Timer2_IRQHandler
	def_irq_handler Timer3_IRQHandler
	def_irq_handler ADC_IRQHandler
	def_irq_handler COMPARATOR_IRQHandler
	def_irq_handler SSP2_IRQHandler
	def_irq_handler BACKUP_IRQHandler
	def_irq_handler EXT_INT1_IRQHandler
	def_irq_handler EXT_INT2_IRQHandler
	def_irq_handler EXT_INT3_IRQHandler
	def_irq_handler EXT_INT4_IRQHandler

	.end