;Program compiled by Great Cow BASIC (0.94 2015-08-05)
;Need help? See the GCBASIC forums at http://sourceforge.net/projects/gcbasic/forums,
;check the documentation or email w_cholmondeley at users dot sourceforge dot net.

;********************************************************************************

;Chip Model: MEGA328P
;Assembler header file
.INCLUDE "m328pdef.inc"

;SREG bit names (for AVR Assembler compatibility, GCBASIC uses different names)
#define I 7
#define T 6
#define H 5
#define S 4
#define V 3
#define N 2
#define Z 1
#define C 0

;********************************************************************************

;Set aside memory locations for variables
.EQU	BITOUT=256
.EQU	BYTEOUT=257
.EQU	NUM=258
.EQU	NUM0=259
.EQU	TEMPBYTE=260

;********************************************************************************

;Register variables
.DEF	DELAYTEMP=r25
.DEF	DELAYTEMP2=r26
.DEF	SysBYTETempA=r22
.DEF	SysBitTest=r5
.DEF	SysCalcTempA=r22
.DEF	SysValueCopy=r21
.DEF	SysWaitTempMS=r29
.DEF	SysWaitTempMS_H=r30
.DEF	SysWaitTempS=r31
.DEF	SysTemp1=r0

;********************************************************************************

;Vectors
;Interrupt vectors
.ORG	0
	rjmp	BASPROGRAMSTART ;Reset
.ORG	2
	reti	;INT0
.ORG	4
	reti	;INT1
.ORG	6
	reti	;PCINT0
.ORG	8
	reti	;PCINT1
.ORG	10
	reti	;PCINT2
.ORG	12
	reti	;WDT
.ORG	14
	reti	;TIMER2_COMPA
.ORG	16
	reti	;TIMER2_COMPB
.ORG	18
	reti	;TIMER2_OVF
.ORG	20
	reti	;TIMER1_CAPT
.ORG	22
	reti	;TIMER1_COMPA
.ORG	24
	reti	;TIMER1_COMPB
.ORG	26
	reti	;TIMER1_OVF
.ORG	28
	reti	;TIMER0_COMPA
.ORG	30
	reti	;TIMER0_COMPB
.ORG	32
	reti	;TIMER0_OVF
.ORG	34
	reti	;SPI_STC
.ORG	36
	reti	;USART_RX
.ORG	38
	reti	;USART_UDRE
.ORG	40
	reti	;USART_TX
.ORG	42
	reti	;ADC
.ORG	44
	reti	;EE_READY
.ORG	46
	reti	;ANALOG_COMP
.ORG	48
	reti	;TWI
.ORG	50
	reti	;SPM_READY

;********************************************************************************

;Start of program memory page 0
.ORG	52
BASPROGRAMSTART:
;Initialise stack
	ldi	SysValueCopy,high(RAMEND)
	out	SPH, SysValueCopy
	ldi	SysValueCopy,low(RAMEND)
	out	SPL, SysValueCopy
;Call initialisation routines
	rcall	INITSYS

;Start of the main program
	rcall	INIT595
SysDoLoop_S1:
	ldi	SysWaitTempS,1
	rcall	Delay_S
	ldi	SysValueCopy,0
	sts	NUM0,SysValueCopy
SysForLoop1:
	lds	SysTemp1,NUM0
	inc	SysTemp1
	sts	NUM0,SysTemp1
	ldi	SysValueCopy,255
	sts	BYTEOUT,SysValueCopy
	rcall	SHIFTBYTE
	lds	SysCalcTempA,NUM0
	cpi	SysCalcTempA,3
	brlo	SysForLoop1
SysForLoopEnd1:
	ldi	SysWaitTempS,1
	rcall	Delay_S
	ldi	SysValueCopy,0
	sts	TEMPBYTE,SysValueCopy
	ldi	SysValueCopy,0
	sts	NUM0,SysValueCopy
SysForLoop2:
	lds	SysTemp1,NUM0
	inc	SysTemp1
	sts	NUM0,SysTemp1
	ldi	SysValueCopy,0
	sts	NUM,SysValueCopy
SysForLoop3:
	lds	SysTemp1,NUM
	inc	SysTemp1
	sts	NUM,SysTemp1
	clr	SysValueCopy
	lds	SysBitTest,TEMPBYTE
	sbrc	SysBitTest,0
	inc	SysValueCopy
	sts	BITOUT,SysValueCopy
	rcall	SHIFTBIT
	lds	SysBYTETempA,TEMPBYTE
	clc
	sbrc	SysBYTETempA,0
	sec
	ror	SysBYTETempA
	sts	TEMPBYTE,SysBYTETempA
	ldi	SysWaitTempS,1
	rcall	Delay_S
	lds	SysCalcTempA,NUM
	cpi	SysCalcTempA,8
	brlo	SysForLoop3
SysForLoopEnd3:
	lds	SysCalcTempA,NUM0
	cpi	SysCalcTempA,3
	brlo	SysForLoop2
SysForLoopEnd2:
	rjmp	SysDoLoop_S1
SysDoLoop_E1:
BASPROGRAMEND:
	sleep
	rjmp	BASPROGRAMEND

;********************************************************************************

Delay_MS:
	inc	SysWaitTempMS_H
DMS_START:
	ldi	DELAYTEMP2,254
DMS_OUTER:
	ldi	DELAYTEMP,20
DMS_INNER:
	dec	DELAYTEMP
	brne	DMS_INNER
	dec	DELAYTEMP2
	brne	DMS_OUTER
	dec	SysWaitTempMS
	brne	DMS_START
	dec	SysWaitTempMS_H
	brne	DMS_START
	ret

;********************************************************************************

Delay_S:
DS_START:
	ldi	SysWaitTempMS,232
	ldi	SysWaitTempMS_H,3
	rcall	Delay_MS
	dec	SysWaitTempS
	brne	DS_START
	ret

;********************************************************************************

INIT595:
	sbi	DDRB,5
	sbi	DDRB,4
	sbi	DDRB,3
	sbi	DDRB,2
	sbi	DDRB,1
	cbi	PORTB,5
	cbi	PORTB,4
	cbi	PORTB,3
	cbi	PORTB,2
	cbi	PORTB,1
	sbi	PORTB,5
	ret

;********************************************************************************

INITSYS:
	ldi	SysValueCopy,0
	out	PORTB,SysValueCopy
	ldi	SysValueCopy,0
	out	PORTC,SysValueCopy
	ldi	SysValueCopy,0
	out	PORTD,SysValueCopy
	ret

;********************************************************************************

SHIFTBIT:
	cbi	PORTB,3
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,BITOUT
	sbrc	SysBitTest,0
	sbi	PORTB,1
	sbi	PORTB,4
	sbi	PORTB,3
	ret

;********************************************************************************

SHIFTBYTE:
	cbi	PORTB,3
	ldi	SysValueCopy,255
	sts	NUM,SysValueCopy
SysForLoop4:
	lds	SysTemp1,NUM
	inc	SysTemp1
	sts	NUM,SysTemp1
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,BYTEOUT
	sbrc	SysBitTest,0
	sbi	PORTB,1
	sbi	PORTB,4
	lds	SysBYTETempA,BYTEOUT
	ror	SysBYTETempA
	sts	BYTEOUT,SysBYTETempA
	lds	SysCalcTempA,NUM
	cpi	SysCalcTempA,7
	brlo	SysForLoop4
SysForLoopEnd4:
	sbi	PORTB,3
	ret

;********************************************************************************


