;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                             ; make it known to linker.
;-------------------------------------------------------------------------------

			.data ; data region
			.retain
			.retainrefs
x:			.space 30
;-------------------------------------------------------------------------------

            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;---------------------- Fixed Data in ROM Creation -----------------------------

dataArray:	.word	0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777
			.word	0x8888, 0x9999, 0xAAAA, 0xBBBB, 0xCCCC, 0xDDDD, 0xEEEE
			.word	0xFFFF

dataArrayLength:	.word 0x001e
zero:	.word	0x000
two:	.word	0x002
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

				mov.w 	&zero, R5				;  Move Zero into R5

push_for_loop:
				cmp.w 	&dataArrayLength, R5	;  Comapre  R5 to the number 8
				jge 	exit_push_for_loop		;  Exit For loop

				push.w 	dataArray(R5)			;  Push Data onto the Stack
				add.w 	&two, R5				;  Add 2 to R5
				jmp 	push_for_loop			;  Restart Loop
exit_push_for_loop:

				sub.w 	&two, R5				;  Adjust R5 to (dataArrayLength - 2) to not include __STACK_END in x
pop_for_loop:
				cmp.w 	&zero, R5				;  Compare R5 to the number 0
				jge 	istrue					;  Jump to is true if R5 >= 0
				jmp 	exit_pop_for_loop		;  Exit Loop if R5 <= 0

istrue:
				mov.w 	SP, x(R5)				;  Move SP onto Heap (x)
				pop.w 	R6						;  Pop Stack Data into R6

				sub.w 	&two, R5				;  Decrement R5 by 2
				jmp 	pop_for_loop			;  Restart Loop
exit_pop_for_loop:


loop: 			jmp 	loop;

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
