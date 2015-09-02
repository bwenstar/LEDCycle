PRGPIO 			equ 0x400FEA08
RCGCGPIO 		equ 0x400FE608
GPIO_D_DIR 		equ 0x40007400
GPIO_D_AFSEL 	equ 0x40007420
GPIO_D_DR8R		equ	0x40007508
GPIO_D_DEN 		equ 0x4000751C
GPIODATA 		equ 0x400073FC

	THUMB
	
	AREA DATA, ALIGN=2
M	space 4		; data allocation here
	ALIGN
		
	AREA main, CODE, READONLY, ALIGN=2
	EXPORT __main

__main
	PUSH {LR, R0, R1}	; write to stack
	BL SetupPortD
	BL WritePortD
  
Spin
	b Spin

SetupPortD
	; enable clock
	LDR R0, =RCGCGPIO
	LDR R1, [R0]
	ORR R1, #0x8
	STR R1, [R0]
	
	; GPIO to stabilise
	LDR R0, =PRGPIO
Check	LDR R1, [R0]
	AND R1, #0x8
	CMP R1, #0
	BEQ Check
	
	; set data direction
	LDR R0, =GPIO_D_DIR
	LDR R1, [R0]
	ORR R1, #0xF
	STR R1, [R0]
	
	; set GPIO port access
	LDR R0, =GPIO_D_AFSEL
	LDR R1, [R0]
	BIC R1, #0xF	; 0 -> controlled by GPIO registers
	STR R1, [R0]
 
	; enable output
	LDR R0, =GPIO_D_DR8R
	LDR R1, [R0]
	ORR R1, #0xF
	STR R1, [R0]
	
	; enable digital
	LDR R0, =GPIO_D_DEN
	LDR R1, [R0]
	ORR R1, #0xF
	STR R1, [R0]
	
	POP {LR, R0, R1}
	BX LR
		
WritePortD
	MOV R3, #0x0
	LDR R0, =GPIODATA
Loop STR R3, [R0]
	BL Delay 			; wait 1 second
	ADD R3, R3, #0x1
	CMP R3, #0xF
	BNE Loop
	BX LR

Delay 
	PUSH {LR, R0} 		; save current values of R0 & LR 
	MOV R0, #0x2000000 	; R0=SIZE 
cntdn SUB R0, #1 		; R0=R0-1 takes 1 cycle 
	CMP R0, #0 			; ans=(R0-0) takes 1 cycle 
	BNE cntdn 			; if (ans!=0) branch to cntdn takes 2 cycles 
	POP {LR, R0} 		; restore previous R0 & LR 
	BX LR 				; return from subroutine 

	ALIGN
	END
