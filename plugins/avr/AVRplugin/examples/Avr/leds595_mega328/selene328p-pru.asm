;Program compiled by Great Cow BASIC (0.94 2015-10-27)
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
.EQU	_PWMDUTY1=256
.EQU	CONT_LTASK5=265
.EQU	CONT_LTASK5_H=266
.EQU	CONT_TASK1=267
.EQU	CONT_TASK2=268
.EQU	DUTY1=269
.EQU	DUTY2=270
.EQU	DUTY3=271
.EQU	OUTBIT=272
.EQU	PREOUTBIT=273
.EQU	PWMCONT=274
.EQU	PWMDUTY1=275
.EQU	RANDOM=276
.EQU	RANDOMSEED=277
.EQU	RANDOMSEED_H=278
.EQU	RANDOMTEMP=280
.EQU	RANDOMTEMP_H=281
.EQU	REGSER1=282
.EQU	SaveSREG=283
.EQU	SaveSysByteTempX=284
.EQU	SaveSysCalcTempA=285
.EQU	SaveSysCalcTempB=286
.EQU	SaveSysStringA=287
.EQU	SaveSysStringA_H=288
.EQU	SaveSysTemp1=289
.EQU	SaveSysTemp2=290
.EQU	SaveSysTemp3=291
.EQU	SaveSysValueCopy=292
.EQU	SaveSysWordTempA_H=293
.EQU	SaveSysWordTempB_H=294
.EQU	SysArrayTemp1=295
.EQU	SysArrayTemp2=296
.EQU	SysIntOffCount=297
.EQU	SysPointerX=298
.EQU	SysRepeatTemp1=299
.EQU	TIME_LTASK5=300
.EQU	TIME_LTASK5_H=301
.EQU	TIME_TASK1=302
.EQU	TIME_TASK2=303

;********************************************************************************

;Register variables
.DEF	DELAYTEMP=r25
.DEF	DELAYTEMP2=r26
.DEF	SysBYTETempA=r22
.DEF	SysBYTETempB=r28
.DEF	SysBYTETempX=r0
.DEF	SysBitTest=r5
.DEF	SysCalcTempA=r22
.DEF	SysCalcTempB=r28
.DEF	SysDivLoop=r5
.DEF	SysStringA=r26
.DEF	SysStringA_H=r27
.DEF	SysValueCopy=r21
.DEF	SysWORDTempA=r22
.DEF	SysWORDTempA_H=r23
.DEF	SysWORDTempB=r28
.DEF	SysWORDTempB_H=r29
.DEF	SysWaitTempMS=r29
.DEF	SysWaitTempMS_H=r30
.DEF	SysTemp1=r1
.DEF	SysTemp1_H=r2
.DEF	SysTemp2=r16
.DEF	SysTemp2_H=r17
.DEF	SysTemp3=r18

;********************************************************************************

;Alias variables
#define	SYS_PWMDUTY1_0	256
#define	SYS_PWMDUTY1_1	257
#define	SYS_PWMDUTY1_2	258
#define	SYS_PWMDUTY1_3	259
#define	SYS_PWMDUTY1_4	260
#define	SYS_PWMDUTY1_5	261
#define	SYS_PWMDUTY1_6	262
#define	SYS_PWMDUTY1_7	263

;********************************************************************************

;Vectors
;Interrupt vectors
	nop
	rjmp	BASPROGRAMSTART ;Reset
	nop
	reti	;INT0
	nop
	reti	;INT1
	nop
	reti	;PCINT0
	nop
	reti	;PCINT1
	nop
	reti	;PCINT2
	nop
	reti	;WDT
	nop
	reti	;TIMER2_COMPA
	nop
	reti	;TIMER2_COMPB
	nop
	reti	;TIMER2_OVF
	nop
	reti	;TIMER1_CAPT
	nop
	reti	;TIMER1_COMPA
	nop
	reti	;TIMER1_COMPB
	nop
	reti	;TIMER1_OVF
	nop
	rjmp	IntTIMER0_COMPA ;TIMER0_COMPA
	nop
	reti	;TIMER0_COMPB
	nop
	reti	;TIMER0_OVF
	nop
	reti	;SPI_STC
	nop
	reti	;USART_RX
	nop
	reti	;USART_UDRE
	nop
	reti	;USART_TX
	nop
	reti	;ADC
	nop
	reti	;EE_READY
	nop
	reti	;ANALOG_COMP
	nop
	reti	;TWI
	nop
	reti	;SPM_READY

;********************************************************************************

;Start of program memory page 0
nop
BASPROGRAMSTART:
;Initialise stack
	ldi	SysValueCopy,high(RAMEND)
	out	SPH, SysValueCopy
	ldi	SysValueCopy,low(RAMEND)
	out	SPL, SysValueCopy
;Call initialisation routines
	rcall	INITSYS
	rcall	INIT_MULTITASK
	rcall	INITRANDOM
;Enable interrupts
	clr	SysValueCopy
	sts	SysIntOffCount,SysValueCopy
	sei
;Automatic pin direction setting
	sbi	DDRB,4
	sbi	DDRB,3
	sbi	DDRB,1

;Start of the main program
	ldi	SysValueCopy,1
	sts	CONT_TASK1,SysValueCopy
SysDoLoop_S1:
	rcall	FN_RANDOM
	lds	SysBYTETempA,RANDOM
	ldi	SysBYTETempB,5
	rcall	SysDivSub
	sts	DUTY1,SysBYTETempA
	rcall	FN_RANDOM
	lds	SysBYTETempA,RANDOM
	ldi	SysBYTETempB,5
	rcall	SysDivSub
	sts	DUTY2,SysBYTETempA
	rcall	FN_RANDOM
	lds	SysBYTETempA,RANDOM
	ldi	SysBYTETempB,5
	rcall	SysDivSub
	sts	DUTY3,SysBYTETempA
	ldi	SysWaitTempMS,44
	ldi	SysWaitTempMS_H,1
	rcall	Delay_MS
	rjmp	SysDoLoop_S1
SysDoLoop_E1:
	rcall	INIT_MULTITASK
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

INITRANDOM:
	ldi	SysValueCopy,73
	sts	RANDOMSEED,SysValueCopy
	ldi	SysValueCopy,193
	sts	RANDOMSEED_H,SysValueCopy
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

INIT_MULTITASK:
	ldi	SysValueCopy,50
	out	OCR0A,SysValueCopy
	ldi	SysValueCopy,2
	out	TCCR0A,SysValueCopy
	ldi	SysValueCopy,3
	out	TCCR0B,SysValueCopy
	lds	SysValueCopy,TIMSK0
	sbr	SysValueCopy,1<<OCIE0A
	sts	TIMSK0,SysValueCopy
	ldi	SysValueCopy,1
	sts	TIME_TASK1,SysValueCopy
	rjmp	INIT_REST_OF_TASKS

;********************************************************************************

INIT_REST_OF_TASKS:
	ldi	SysValueCopy,1
	sts	TIME_TASK2,SysValueCopy
	ldi	SysValueCopy,250
	sts	TIME_LTASK5,SysValueCopy
	ldi	SysValueCopy,0
	sts	TIME_LTASK5_H,SysValueCopy
	ret

;********************************************************************************

INTERR_TIMER0:
	lds	SysTemp1,CONT_TASK1
	inc	SysTemp1
	sts	CONT_TASK1,SysTemp1
	lds	SysCalcTempA,CONT_TASK1
	lds	SysCalcTempB,TIME_TASK1
	cp	SysCalcTempA,SysCalcTempB
	brsh	PC + 2
	rjmp	ENDIF1
	ldi	SysValueCopy,0
	sts	CONT_TASK1,SysValueCopy
	lds	SysTemp1,PWMCONT
	inc	SysTemp1
	sts	PWMCONT,SysTemp1
	ldi	SysCalcTempA,50
	lds	SysCalcTempB,PWMCONT
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF4
	ldi	SysValueCopy,0
	sts	PWMCONT,SysValueCopy
ENDIF4:
	ldi	SysValueCopy,255
	sts	REGSER1,SysValueCopy
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_0
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF5
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<0
	sts	REGSER1,SysValueCopy
ENDIF5:
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_1
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF6
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<1
	sts	REGSER1,SysValueCopy
ENDIF6:
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_2
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF7
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<2
	sts	REGSER1,SysValueCopy
ENDIF7:
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_3
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF8
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<3
	sts	REGSER1,SysValueCopy
ENDIF8:
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_4
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF9
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<4
	sts	REGSER1,SysValueCopy
ENDIF9:
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_5
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF10
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<5
	sts	REGSER1,SysValueCopy
ENDIF10:
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_6
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF11
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<6
	sts	REGSER1,SysValueCopy
ENDIF11:
	lds	SysCalcTempA,PWMCONT
	lds	SysCalcTempB,SYS_PWMDUTY1_7
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF12
	lds	SysValueCopy,REGSER1
	cbr	SysValueCopy,1<<7
	sts	REGSER1,SysValueCopy
ENDIF12:
ENDIF1:
	lds	SysTemp1,CONT_TASK2
	inc	SysTemp1
	sts	CONT_TASK2,SysTemp1
	lds	SysCalcTempA,CONT_TASK2
	lds	SysCalcTempB,TIME_TASK2
	cp	SysCalcTempA,SysCalcTempB
	brlo	ENDIF2
	ldi	SysValueCopy,0
	sts	CONT_TASK2,SysValueCopy
	cbi	PORTB,3
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,0
	sbi	PORTB,1
	sbi	PORTB,4
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,1
	sbi	PORTB,1
	sbi	PORTB,4
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,2
	sbi	PORTB,1
	sbi	PORTB,4
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,3
	sbi	PORTB,1
	sbi	PORTB,4
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,4
	sbi	PORTB,1
	sbi	PORTB,4
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,5
	sbi	PORTB,1
	sbi	PORTB,4
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,6
	sbi	PORTB,1
	sbi	PORTB,4
	cbi	PORTB,4
	cbi	PORTB,1
	lds	SysBitTest,REGSER1
	sbrc	SysBitTest,7
	sbi	PORTB,1
	sbi	PORTB,4
	sbi	PORTB,3
ENDIF2:
	lds	SysTemp1,CONT_LTASK5
	inc	SysTemp1
	sts	CONT_LTASK5,SysTemp1
	lds	SysTemp1,CONT_LTASK5_H
	brne	PC + 2
	inc	SysTemp1
	sts	CONT_LTASK5_H,SysTemp1
	lds	SysWORDTempA,CONT_LTASK5
	lds	SysWORDTempA_H,CONT_LTASK5_H
	lds	SysWORDTempB,TIME_LTASK5
	lds	SysWORDTempB_H,TIME_LTASK5_H
	rcall	SysCompLessThan16
	com	SysByteTempX
	sbrs	SysByteTempX,0
	rjmp	ENDIF3
	ldi	SysValueCopy,0
	sts	CONT_LTASK5,SysValueCopy
	sts	CONT_LTASK5_H,SysValueCopy
	ldi	SysValueCopy,8
	sts	OUTBIT,SysValueCopy
SysForLoop1:
	lds	SysTemp1,OUTBIT
	dec	SysTemp1
	sts	OUTBIT,SysTemp1
	dec	SysTemp1
	sts	PREOUTBIT,SysTemp1
	ldi	SysTemp2,low(_PWMDUTY1)
	add	SysTemp1,SysTemp2
	mov	SysStringA,SysTemp1
	ldi	SysTemp2,0
	ldi	SysTemp3,high(_PWMDUTY1)
	adc	SysTemp2,SysTemp3
	mov	SysStringA_H,SysTemp2
	ld	SysValueCopy,X
	sts	SysArrayTemp2,SysValueCopy
	sts	SysArrayTemp1,SysValueCopy
	lds	SysTemp1,OUTBIT
	ldi	SysTemp2,low(_PWMDUTY1)
	add	SysTemp1,SysTemp2
	mov	SysStringA,SysTemp1
	ldi	SysTemp2,0
	ldi	SysTemp3,high(_PWMDUTY1)
	adc	SysTemp2,SysTemp3
	mov	SysStringA_H,SysTemp2
	lds	SysValueCopy,SysArrayTemp1
	st	X,SysValueCopy
	ldi	SysCalcTempA,1
	lds	SysCalcTempB,OUTBIT
	cp	SysCalcTempA,SysCalcTempB
	brlo	SysForLoop1
SysForLoopEnd1:
	lds	SysValueCopy,SYS_PWMDUTY1_0
	sts	PWMDUTY1,SysValueCopy
	lds	SysCalcTempA,PWMDUTY1
	lds	SysCalcTempB,DUTY1
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF14
	lds	SysTemp2,DUTY1
	lds	SysTemp3,PWMDUTY1
	sub	SysTemp2,SysTemp3
	mov	SysTemp1,SysTemp2
	mov	SysTemp3,SysTemp1
	lsr	SysTemp3
	lds	SysTemp1,PWMDUTY1
	add	SysTemp1,SysTemp3
	sts	SYS_PWMDUTY1_0,SysTemp1
ENDIF14:
	lds	SysCalcTempA,DUTY1
	lds	SysCalcTempB,PWMDUTY1
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF15
	lds	SysTemp2,PWMDUTY1
	lds	SysTemp3,DUTY1
	sub	SysTemp2,SysTemp3
	mov	SysTemp1,SysTemp2
	mov	SysTemp3,SysTemp1
	lsr	SysTemp3
	lds	SysTemp1,PWMDUTY1
	sub	SysTemp1,SysTemp3
	sts	SYS_PWMDUTY1_0,SysTemp1
ENDIF15:
ENDIF3:
	ret

;********************************************************************************

IntTIMER0_COMPA:
	rcall	SysIntContextSave
	rcall	INTERR_TIMER0
	cbi	TIFR0,OCF0A
	rjmp	SysIntContextRestore

;********************************************************************************

FN_RANDOM:
	ldi	SysValueCopy,7
	sts	SysRepeatTemp1,SysValueCopy
SysRepeatLoop1:
	lds	SysValueCopy,RANDOMSEED
	sts	RANDOMTEMP,SysValueCopy
	lds	SysValueCopy,RANDOMSEED_H
	sts	RANDOMTEMP_H,SysValueCopy
	lds	SysWORDTempA,RANDOMTEMP
	lds	SysWORDTempA_H,RANDOMTEMP_H
	clc
	sbrc	SysWORDTempA_H,7
	sec
	rol	SysWORDTempA
	rol	SysWORDTempA_H
	sts	RANDOMTEMP,SysWORDTempA
	sts	RANDOMTEMP_H,SysWORDTempA_H
	ldi	SysTemp2,1
	lds	SysTemp3,RANDOMSEED
	and	SysTemp3,SysTemp2
	mov	SysTemp1,SysTemp3
	ldi	SysValueCopy,0
	mov	SysTemp1_H,SysValueCopy
	com	SysTemp1
	mov	SysTemp2,SysTemp1
	com	SysTemp1_H
	mov	SysTemp2_H,SysTemp1_H
	ldi	SysTemp3,1
	add	SysTemp2,SysTemp3
	mov	SysTemp1,SysTemp2
	ldi	SysTemp3,0
	adc	SysTemp2_H,SysTemp3
	mov	SysTemp1_H,SysTemp2_H
	ldi	SysTemp2,0
	ldi	SysTemp3,180
	and	SysTemp1_H,SysTemp3
	mov	SysTemp2_H,SysTemp1_H
	lds	SysTemp1,RANDOMTEMP
	eor	SysTemp2,SysTemp1
	sts	RANDOMSEED,SysTemp2
	lds	SysTemp1,RANDOMTEMP_H
	eor	SysTemp2_H,SysTemp1
	sts	RANDOMSEED_H,SysTemp2_H
	lds	SysTemp1,RANDOM
	lds	SysTemp3,RANDOMSEED_H
	eor	SysTemp3,SysTemp1
	sts	RANDOM,SysTemp3
	lds	SysTemp1,SysRepeatTemp1
	dec	SysTemp1
	sts	SysRepeatTemp1,SysTemp1
	breq	PC + 2
	rjmp	SysRepeatLoop1
SysRepeatLoopEnd1:
	ret

;********************************************************************************

SYSCOMPLESSTHAN16:
	clr	SYSBYTETEMPX
	cp	SYSWORDTEMPB_H,SYSWORDTEMPA_H
	brlo	SCLT16FALSE
	cp	SYSWORDTEMPA_H,SYSWORDTEMPB_H
	brlo	SCLT16TRUE
	cp	SYSWORDTEMPA,SYSWORDTEMPB
	brlo	SCLT16TRUE
	ret
SCLT16TRUE:
	com	SYSBYTETEMPX
SCLT16FALSE:
	ret

;********************************************************************************

SYSDIVSUB:
	clr	SYSBYTETEMPX
	ldi	SysValueCopy,8
	mov	SYSDIVLOOP,SysValueCopy
SYSDIV8START:
	lsl	SYSBYTETEMPA
	rol	SYSBYTETEMPX
	sub	SYSBYTETEMPX,SYSBYTETEMPB
	sbr	SYSBYTETEMPA,1
	brsh	DIV8NOTNEG
	cbr	SYSBYTETEMPA,1
	add	SYSBYTETEMPX,SYSBYTETEMPB
DIV8NOTNEG:
	dec	SYSDIVLOOP
	brne	SYSDIV8START
	ret

;********************************************************************************

SysIntContextRestore:
;Allow interrupt to be re-enabled
	clr	SysValueCopy
	sts	SysIntOffCount,SysValueCopy
;Restore registers
	lds	SysTemp1,SaveSysTemp1
	lds	SysCalcTempA,SaveSysCalcTempA
	lds	SysCalcTempB,SaveSysCalcTempB
	lds	SysWordTempA_H,SaveSysWordTempA_H
	lds	SysWordTempB_H,SaveSysWordTempB_H
	lds	SysByteTempX,SaveSysByteTempX
	lds	SysTemp2,SaveSysTemp2
	lds	SysStringA,SaveSysStringA
	lds	SysTemp3,SaveSysTemp3
	lds	SysStringA_H,SaveSysStringA_H
;Restore SREG
	lds	SysValueCopy,SaveSREG
	out	SREG,SysValueCopy
;Restore SysValueCopy
	lds	SysValueCopy,SaveSysValueCopy
	reti

;********************************************************************************

SysIntContextSave:
;Store SysValueCopy
	sts	SaveSysValueCopy,SysValueCopy
;Store SREG
	in	SysValueCopy,SREG
	sts	SaveSREG,SysValueCopy
;Store registers
	sts	SaveSysTemp1,SysTemp1
	sts	SaveSysCalcTempA,SysCalcTempA
	sts	SaveSysCalcTempB,SysCalcTempB
	sts	SaveSysWordTempA_H,SysWordTempA_H
	sts	SaveSysWordTempB_H,SysWordTempB_H
	sts	SaveSysByteTempX,SysByteTempX
	sts	SaveSysTemp2,SysTemp2
	sts	SaveSysStringA,SysStringA
	sts	SaveSysTemp3,SysTemp3
	sts	SaveSysStringA_H,SysStringA_H
;Prevent interrupt from being re-enabled
	ldi	SysValueCopy,1
	sts	SysIntOffCount,SysValueCopy
	ret

;********************************************************************************


