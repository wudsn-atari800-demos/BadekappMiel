;
;	>>> Badekapp Miel 3 <<<
;
;	1991-05-12 Resourced from binary dump by JAC!
;	1991-05-14 All label addressing reworked by JAC!
;	2010-12-13 Working version for New Years Disk 2010 by JAC!


cnt	= $14

irqa	= $80
irqx	= $81
irqy	= $82
dliup	= $83

p1	= $90
p2	= $92

x1	= $e0
x2	= $e1
x3	= $e2
x4	= $e3

lflag	= $f0	;0 Means german, 1 means English
wcnt	= $f1
wflag	= $f2

sm	= $c000
chr	= $0400
pm	= $0800
dl	= $1000


text_chr	= $9000
grafp1		= $9400
grafp2		= $9500
grafp3		= $9600
grafp4		= $9700
gfx_chr		= $9800

sound_start	= $5000		;Player
music_start	= $8400		;CMC module


;===============================================================

	opt h+
	org $9000

;===============================================================

	.proc fader	;Fade out all 9 color registers
fade_loop
	ldy #0		;Assume all zero
	ldx #8
color_loop
	lda 704,x
	pha
	and #$f0
	sta fade_color
	pla
	and #15
	beq zero
	sec
	sbc #1
	ora #$00
fade_color = *-1
	tay		;At least one not zero

zero	sta 704,x
	dex
	bpl color_loop
	lda cnt
	clc
	adc #2
wait	cmp cnt
	bne wait
	cpy #0
	bne fade_loop
	rts
	.endp		;End of fade

	ini fader

;===============================================================

	org $2000

	.proc main
	lda #1		;Force cold start
	sta 580
	jsr sound.init
	jsr intro	
	jsr scrninit
	jsr story
	lda #0
	sta $d40e
	sta $d40e
	sta $d400
	sei
	lda #$ff
	sta $d301
	jmp $e477
	.endp

;===============================================================

	.proc intro

blend	= x1

	mwa #dl $230
	mva #>intro_chr 756
	mva #0 lflag	;Default is German

	mva #13 blend
blendup	jsr kernel
	lda cnt
	and #3
	bne blendup
	dec blend
	bne blendup

wait	jsr kernel

	lda $d20f
	and #12
	cmp #12
	bne continue_key
	lda $d01f
	and #7
	cmp #7
	bne continue_console
	jmp wait
continue_key
	lda $d209
	and #$3f
	cmp #$2a	;"E"
	bne no_e
	inc lflag
no_e	jmp blenddown

continue_console
	and #1
	bne no_select
	inc lflag
no_select
	jmp blenddown

blenddown
	jsr kernel
	lda cnt
	and #3
	bne blenddown
	inc blend
	lda blend
	cmp #13
	bne blenddown
	rts

;===============================================================

	.proc kernel
	lda #15
wait	cmp $d40b
	bne wait
	ldx #0
loop	txa
	and #7
	adc blend
	tay
	lda colors,y
	sta $d40a
	sta $d017
	inx
	cpx #192
	bne loop
	jsr sound.play
	rts
	.endp

colors	.byte $04,$06,$08,$0a,$0c,$0e,$0c,$0a,$08,$06,$04,$02
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00
;===============================================================

	.align 1024

intro_chr
	ins "BadekappMiel-Intro.chr"

	.local dl
	.byte $70,$70,$70
	.byte $42
	.word text
	.byte $70
	.byte $02,$02,$02,$70,$02,$70,$02
	.byte $02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$70,$02,$02
	.byte $41
	.word dl

	.endl

;===============================================================

text	.byte "         BADEKAPP MIEL 3 - 1991         "
	.byte "  WE ALL DID CRAZY THINGS WHEN WE WERE  "
	.byte "   YOUNG ... AND SOME OF US STILL DO.   "
	.byte "   THIS IS ONE OF THE THINGS IS DID.    "
	.byte "    A CRAZY STORY ABOUT A BATHING CAP   "
	.byte " THE EXPLANTATION WHY THIS IS THE CASE  "
	.byte "       WOULD NOT FIT INTO 64K :-)       "
	.byte " WHEN THE STORY WAS FINSISHED HALF WAY, "
	.byte "MY DISK DRIVE TOOK ALL SOURCES TO HELL. "
	.byte " I DISASSEMBLED THE BINARY - BUT FACED  "
	.byte " WITH LABELS CALLED 'LABEL1 - LABEL200' "
	.byte "     I NEVER FELT LIKE FINISHING IT.    "
	.byte " NOW IN 2010, I FOUND THAT IT FITS THE  "
	.byte " 'EVERYTHING THAT HAS TO DO WITH ATARI' "
	.byte "     SLOGAN OF THE NEW YEARS DISK.      "
	.byte "SO I ADDED THIS TEXT, A NICE TUNE BY 505"
	.byte "AND MULTI LANGUAGE SUPPORT JUST FOR FUN."
	.byte "   PRESS 'START' OR 'E' FOR ENGLISH.    "
	.byte "DRUECKE 'SELECT' ODER 'D' FUER DEUTSCH. "
	.endp

;====================================
	
	.align 1024

dl1	.byte $70,$f0,$f0
	.byte $d4
	.word sm
	.byte $d4
	.word sm+48
	.byte $d4
	.word sm+96
	.byte $d4
	.word sm+144
	.byte $d4
	.word sm+192
	.byte $d4
	.word sm+240
	.byte $d4
	.word sm+288
	.byte $d4
	.word sm+336
	.byte $d4
	.word sm+384
	.byte $d4
	.word sm+432
	.byte $d4
	.word sm+480
	.byte $d4
	.word sm+528
	.byte $d4
	.word sm+576
	.byte $d4
	.word sm+624
	.byte $d4
	.word sm+672
	.byte $d4
	.word sm+720
	.byte $d4
	.word sm+768
	.byte $d4
	.word sm+816
	.byte $d4
	.word sm+864
	.byte $d4
	.word sm+912
	.byte $d4
	.word sm+960
	.byte $d4
	.word sm+1008
	.byte $d4
	.word sm+1056
	.byte $54
	.word sm+1104
	.byte $41
	.word dl

dl2	.byte $c2
	.word talksm
	.byte $c2
	.word talksm+40
	.byte $c2
	.word talksm+80
	.byte $c2
	.word talksm+120

dly	.byte 0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63

talksm	.byte "0123456789012345678901234567890123456789"
	.byte "0123456789012345678901234567890123456789"
	.byte "0123456789012345678901234567890123456789"
	.byte "0123456789012345678901234567890123456789"

talkbuf	.byte "01234567890123456789"

talkp1	.byte 0
talkp2	.byte 0
talkp3	.byte 0
talkyp	.byte 0
talklen	.byte 0

chrtab	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
scrtab	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
fastab	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
fabtab	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

bkgraf	.byte 00,00,00,00,17,17,17,19,00,18,17,17,19,00,17,17
	.byte 17,19,00,18,17,17,17,00,17,00,26,29,00,18,17,17
	.byte 19,00,17,17,17,19,00,17,17,17,19,00,00,00,00,00
	.byte 00,00,00,00,17,22,22,20,00,17,00,00,17,00,17,00
	.byte 00,17,00,17,22,22,00,00,17,26,29,00,00,17,00,00
	.byte 17,00,17,00,00,17,00,17,00,00,17,00,00,00,00,00
	.byte 00,00,00,00,17,23,23,19,00,17,17,17,17,00,17,00
	.byte 00,17,00,17,23,23,00,00,17,28,27,00,00,17,17,17
	.byte 17,00,17,17,17,20,00,17,17,17,20,00,00,00,00,00
	.byte 00,00,00,00,17,17,17,20,00,17,00,00,17,00,17,17
	.byte 17,20,00,21,17,17,17,00,17,00,28,27,00,17,00,00
	.byte 17,00,17,00,00,00,00,17,00,00,00,00,00,00,00,00

pixtab	.byte $c0,$30,$0c,$03
kappgr	.byte 0,1,2,3,4,5,6,7,8,0
	.byte 0,9,10,11,12,13,14,15,16,0
mielgr	.byte 0,72,73,74,75,76,77,78,79,0
	.byte 0,80,81,82,83,84,85,86,87,0
mielgr1	.byte 0,46,47,48,49,50,51,52,53,0
	.byte 0,54,55,56,57,58,59,60,61,0
cybgr	.byte 48,47,46,0
	.byte 51,50,49,0
compgr	.byte 0,62,63,64,65,66,67
	.byte 0,68,69,70,71,72,73

;====================================
	.proc scrninit
	sei
	lda #0
	sta $d40e
	sta $d400
	sta $d20e
	tay
clrchips
	sta $d000,y
	sta $d400,y
	iny
	bne clrchips
	lda #$fe
	sta $d301
	mwa #nmi $fffa

	jsr initdl
	jsr clrsm
	mwa #dl $d402

	lda #2
	sta $d401
	lda #$84
	sta $d016

	jsr clrpm
	lda #>pm
	sta $d407
	lda #1
	sta $d01b
	lda #3
	sta $d01d

	lda $d40b
	bne *-3
	lda #$c0
	sta $d40e
	lda #$3e
	sta $d400
	rts
	.endp

;------------------------------------

nmi	sta irqa
	stx irqx
	bit $d40f
	bpl vbi

dli	ldx dliup
	lda chrtab,x
	sta $d409
	lda fastab,x
	sta $d017
	lda scrtab,x
	sta $d404
	lda fabtab,x
	sta $d018
	inx
	stx dliup
	jmp irqend

vbi	sty irqy
	lda wcnt
	sec
	sbc wflag
	sta wcnt
	bcs vbi1
	lsr wflag
vbi1	lda #0
	sta dliup
	
	jsr sound.play
	ldy irqy
irqend	ldx irqx
	lda irqa
	rti

;====================================
	.proc initdl
	ldx #$52
initdl1	lda dl1,x
	sta dl,x
	dex
	bpl initdl1
	ldx #24
initdl2	lda #>chr
	sta chrtab,x
	lda #$78
	sta fastab,x
	lda #$7e
	sta fabtab,x
	dex
	bpl initdl2
	rts
	.endp
;====================================

	.proc clrsm
	lda #0
	tax
clrsm1	sta sm+$000,x
	sta sm+$100,x
	sta sm+$200,x
	sta sm+$300,x
	sta sm+$380,x
	sta chr+$000,x
	sta chr+$100,x
	sta chr+$200,x
	sta chr+$300,x
	inx
	bne clrsm1
	ldx #24
clrsm2	sta scrtab,x
	dex
	bpl clrsm2
	rts
	.endp
	
;====================================
	.proc clrpm
	lda #0
	tax
clrpm1	sta pm+$300,x
	sta pm+$400,x
	sta pm+$500,x
	sta pm+$600,x
	sta pm+$700,x
	inx
	bne clrpm1
	rts
	.endp

;====================================
	.proc wait
	sta wcnt
	lda #1
	sta wflag
wait1	lda wflag
	bne wait1
wait2	lda $d01f
	lsr
	bcc wait2
	rts
	.endp

;====================================
	.proc talkit
	pla
	sta p1
	pla
	sta p1+1

	ldy #1
	ldx #0
talkit0	lda (p1),y
	sta talkp1,x
	iny
	inx
	cpx #3
	bne talkit0

	lda lflag
	beq dont_skip_german
	dey
	jsr skip_language
	iny
dont_skip_german

	ldx #0
talkit1	lda (p1),y
	bmi talkit2
	sta talkbuf,x
	iny
	inx
	jmp talkit1
talkit2	stx talklen

	lda lflag
	bne dont_skip_english
	jsr skip_language
dont_skip_english

	clc
	tya
	adc p1
	tay
	lda p1+1
	adc #0
	pha
	tya
	pha

	lda talkp3
	beq *+5
	jsr talkout

	ldx talkp1
	stx talkyp
	ldy dly,x
	ldx #0
talkit3	lda dl2,x
	sta dl,y
	iny
	inx
	cpx #12
	bne talkit3

	ldy #39
talkit4	lda #$80
	sta talksm,y
	sta talksm+40,y
	sta talksm+80,y
	lda #0
 	sta talksm+120,y
	dey
	bpl talkit4
	ldy #3
	sty talksm
	iny
	sty talksm+39
	iny
	sty talksm+119
	iny
	sty talksm+80

	ldx talklen
	txa
	clc
	adc #58
	tay
	dex
talkit5	lda talkbuf,x
	sec
	sbc #32
	cmp #64
	bcc *+4
	sbc #32
	ora #$80
	sta talksm,y
	ora #$40
	sta talksm+1,y
	dey
	dey
	dex
	bpl talkit5

	ldy talkp2
	beq talkit6
	lda #$45
	sta talksm+120,y
	lda #$46
	sta talksm+121,y

talkit6	jmp talkin

	.proc skip_language
skip	iny
	lda (p1),y
	bmi next
	jmp skip
next	rts
	.endp

;====================================
	.proc talkin
	ldx talkyp
	lda #>text_chr
	sta chrtab,x
	sta chrtab+1,x
	sta chrtab+2,x
	sta chrtab+3,x
	lda #0
	sta fabtab,x
	sta fabtab+1,x
	sta fabtab+2,x
	sta fabtab+3,x
	ldy #0
talkin1	tya
	sta fastab,x
	sta fastab+1,x
	sta fastab+2,x
	sta fastab+3,x
	lda #0
	jsr wait
	iny
	cpy #16
	bne talkin1
	rts
	.endp

	.endp		;End of talkit

;====================================
	.proc talkout
	ldx talkyp
	ldy #15
talkout1
	tya
	sta fastab,x
	sta fastab+1,x
	sta fastab+2,x
	sta fastab+3,x
	lda #0
	jsr wait
	dey
	bpl talkout1
	lda #6
	jsr wait
	jmp initdl
	.endp		;End of talkout

;====================================
	.proc copychr
	sta p1
	stx p2
	sty x1

	lda #0
	jsr wait

	ldy #0
	sty p1+1
	sty p2+1
	sty x2
	asl p1
	rol p1+1
	asl p1
	rol p1+1
	asl p1
	lda p1+1
	rol
	clc
	adc #>gfx_chr
	sta p1+1

	asl p2
	rol p2+1
	asl p2
	rol p2+1
	asl p2
	lda p2+1
	rol
	clc
	adc #>chr
	sta p2+1

	asl x1
	rol x2
	asl x1
	rol x2
	asl x1
	rol x2

copychr1
	lda (p1),y
	sta (p2),y
	inc p1
	bne *+4
	inc p1+1
	inc p2
	bne *+4
	inc p2+1
	dec x1
	bne copychr1
	dec x2
	bpl copychr1
	rts
	.endp

;====================================
	.proc sprite
	lda #16
	sta sprite2
sprite1	lda grafp1,x
	sta pm+$400,y
	lda grafp2,x
	sta pm+$500,y
	lda grafp3,x
	sta pm+$600,y
	lda grafp4,x
	sta pm+$700,y
	inx
	iny
	dec sprite2
	bne sprite1
	rts

sprite2	.byte 0
	.endp

;====================================

	.proc virus_talk
	lda #75
	sta x3
jll18	lda x3
	and #4
	clc
	adc #105
	ldx #64
	ldy #2
	jsr copychr
	lda #0
	jsr wait
	dec x3
	bne jll18
	rts
	.endp
;====================================

	.proc story

	lda #0
	ldx #1
	ldy #16
	jsr copychr
	lda #25
	jsr wait
	jsr talkit
	.byte 7,0,0
	.byte "dumm-di-dumm",$ff
	.byte "dum-di-dum",$ff

	lda #25
	jsr wait
	lda #0
	sta x1
	sta x2
	sta $d012
	lda #$ca
	sta $d013
	sta $d014
	lda #$ff
	ldx #9
jla1	sta pm+$480,x
	dex 
	bpl jla1
	lda #16
	sta $d000
	lda #3
	sta $d008
jla2	lda #0
	jsr wait
	ldy #0
	lda x1
	cmp #89
	bcs jla4
	lsr
	lsr
	tax 
jla3	lda kappgr,y
	sta sm+$1db,x
	lda kappgr+10,y
	sta sm+$20b,x
	inx 
	iny 
	cpy #9
	bne jla3
	lda x1
	and #3
	sta scrtab+11
	sta scrtab+12
jla4	lda x1
	clc 
	adc #$15
	sta $d001
	clc 
	adc #16
	sta $d002
	ldx x2
	ldy #0
jla5	lda grafp4,x
	sta pm+$580,y
	sta pm+$680,y
	inx 
	iny 
	cpy #10
	bne jla5
	lda x1
	and #3
	bne jla7
	clc 
	lda x2
	adc #10
	cmp #50
	bne jla6
	lda #0
jla6	sta x2
jla7	inc x1
	lda x1
	cmp #200
	bne jla2
	lda #0
	sta $d000
	sta $d008
	jsr clrpm
	lda #25
	jsr wait
	lda #16
	ldx #1
	ldy #16
	jsr copychr
	lda #50
	jsr wait
	jsr talkit
	.byte 7,17,1
	.byte "ei gunn dach!",$ff
	.byte "hi there!",$ff
	lda #150
	jsr wait
	jsr talkit
	.byte 7,17,1
	.byte "ich bin die...",$ff
	.byte "i am the...",$ff
	lda #50
	jsr wait
	lda #48
	ldx #17
	ldy #13
	jsr copychr
	lda #47
	sta x1
jla8	ldx x1
	ldy #0
jla9	lda bkgraf,y
	sta sm+$270,x
	lda bkgraf+48,y
	sta sm+$2a0,x
	lda bkgraf+96,y
	sta sm+$2d0,x
	lda bkgraf+144,y
	sta sm+$300,x
	iny 
	inx 
	cpx #48
	bne jla9
	lda #0
	jsr wait
	dec x1
	bpl jla8
	lda #75
	jsr wait
	jsr talkout
	lda #$34
	ldx #$38
	ldy #14
	sta $d012
	stx $d013
	sty $d014
	sta $d015

	lda #50
	jsr wait
	lda #$18
	sta x1
jla10	lda x1
	sta $d000
	sta $d001
	sta $d002
	and #1
	beq *+4
	lda #16
	tax 
	ldy #$70
	jsr sprite
	lda #$0f
	sta $d201
	lda #0
	jsr wait
	lda #0
	sta $d201
	lda #0
	jsr wait
	inc x1
	lda x1
	cmp #$5e
	bne jla10
	lda #50
	jsr wait
	jsr talkit
	.byte 7,12,0
	.byte "na und!?",$ff
	.byte "so what!?",$ff

	lda #10
	sta x2
jla11	ldx #$20
	ldy #$70
	jsr sprite
	lda $d20a
	and #7
	ora #4
	jsr wait
	ldx #16
	ldy #$70
	jsr sprite
	lda $d20a
	and #7
	ora #4
	jsr wait
	dec x2
	bne jla11

	jsr talkout
	lda #$20
	ldx #1
	ldy #16
	jsr copychr
	lda #50
	jsr wait
	lda #$65
	sta $d003
	ldx #48
	ldy #112
	jsr sprite
	lda #10
	jsr wait
	ldx #$40
	ldy #$70
	jsr sprite
	lda #10
	jsr wait
	ldy #$1a
jla12	ldx #$2e
jla13	lda sm+$1e0,x
	sta sm+$1e1,x
	lda sm+$210,x
	sta sm+$211,x
	dex 
	bpl jla13
	lda #0
	jsr wait
	dey 
	bne jla12
	ldx #48
	ldy #112
	jsr sprite
	lda #10
	jsr wait
	lda #0
	sta $d003
	ldx #16
	ldy #$70
	jsr sprite
	lda #50
	jsr wait
	ldx #$50
	ldy #$70
	jsr sprite
	lda #30
	jsr wait

	lda #$5e
	sta x1
jla15	lda #0
	jsr wait
	lda x1
	sta $d000
	sta $d001
	sta $d002
	clc 
	adc #6
	sta x1
	bcc jla15

	lda #$4d
	ldx #$2e
	ldy #$1a
	jsr copychr
	jsr clrpm
	lda #$e6
	sta $d012
	lda #$ee
	sta $d013
	lda #112
	sta $d000
	sta $d001
	lda #50
	jsr wait
	lda #0
	sta x1
jlf1	ldy x1
	ldx #3
jlf2	lda cybgr,x
	sta sm,y
	lda cybgr+4,x
	sta sm+48,y
	iny 
	dex 
	bpl jlf2
	ldx #0
jlf3	stx scrtab+1
	stx scrtab+2
	lda #0
	jsr wait
	inx 
	cpx #4
	bne jlf3
	inc x1
	lda x1
	cmp #19
	jne jlf9
	lda #25
	jsr wait
	ldy #$8b
	lda #48
	sta x2

jlf4	ldx #47
jlf5	lda $d20a
	and $d20a
	sta pm+$400,x
	lda $d20a
	and $d20a
	sta pm+$500,x
	inx
	cpx x2
	bne jlf5
	cpy #52
	bcc jlf6
	inc x2
jlf6	lda #0
	jsr wait
	dey
	bne jlf4
	lda #$3c
	sta $d019
	ldx #52+$80
	stx sm+548
	inx
	stx sm+549
	inx
	stx sm+596
	inx
	stx sm+597

	ldy #89
jlf7	ldx #47
jlf8	lda $d20a
	and $d20a
	sta pm+$400,x
	lda $d20a
	and $d20a
	sta pm+$500,x
	inx
	cpx x2
	bne jlf8
	lda #0
	sta pm+$400,x
	sta pm+$500,x
	dec x2
	lda #0
	jsr wait
	dey
	bne jlf7
	lda #0
	sta pm+$42f
	sta pm+$52f

	lda #10
	jsr wait

jlf9	lda x1
	cmp #44
	beq *+5
	jmp jlf1
	lda #0
	sta scrtab+1
	sta scrtab+2

	jsr talkit
	.byte 8,17,0
	.byte "hey,ich bin",$ff
	.byte "har,i am",$ff

	lda #100
	jsr wait
	jsr talkit
	.byte 8,17,1
	.byte "galakto-werner!", $ff
	.byte "galactic-werner!", $ff
	lda #50
	jsr wait
	lda #200
	sta x1
jlf10	lda x1
	and #3
	tax 
	lda pixtab,x
	ldy #7
jlf11	sta chr,y
	dey 
	bpl jlf11
	lda x1
	and #7
	tax 
	lda #$ff
	sta chr,x
	lda #0
	jsr wait
	lda #0
	ldy #7
jlf12	sta chr,y
	dey
	bpl jlf12
	dec x1
	bne jlf10

	lda #50
	jsr wait

	jsr talkit
	.byte 8,17,1
	.byte "und ich komme", $ff
	.byte "and i am coming", $ff

	lda #50
	jsr wait

	jsr talkit
	.byte 8,17,1
	.byte "gerade aus einem", $ff
	.byte "right out of a", $ff

	lda #50
	jsr wait

	jsr talkit
	.byte 8,17,1
	.byte "meteoriten sturm", $ff
	.byte "meteor shower", $ff

	lda #75
	jsr wait
	jsr talkout

	lda #16
	ldx #1
	ldy #16
	jsr copychr

	lda #47
	sta x1

jlg1	ldx x1
	ldy #0
jlg2	lda kappgr+1,y
	sta sm+432,x
	lda kappgr+11,y
	sta sm+480,x
	cpx #47
	beq *+3
	inx
	iny
	cpy #9
	bne jlg2
	ldx #3
jlg3	stx scrtab+10
	stx scrtab+11
	lda #0
	jsr wait
	dex
	bpl jlg3

	dec x1
	lda x1
	cmp #24
	bne jlg1

	lda #25
	jsr wait

	jsr talkit
	.byte 6,24,0
	.byte "ach wirklich?", $ff
	.byte "oh, really?", $ff

	lda #75
	jsr wait
	jsr talkout
	lda #25
	jsr wait

	lda #0
	sta x1
	mwa #[sm+20] p1

jlh2	lda #2
	jsr wait
	lda #0
	tay
	sta (p1),y
	iny
	sta (p1),y
	ldy #48
	sta (p1),y
	iny
	sta (p1),y
	adw p1 #48
	ldy #0
	lda #56
	sta (p1),y
	iny
	lda #57
	sta (p1),y
	ldy #48
	lda #58
	sta (p1),y
	iny
	lda #59
	sta (p1),y

	inc x1
	lda x1
	cmp #10
	bne jlh2
	ldx #60+$80
	stx sm+595
	inx
	stx sm+596
	inx
	stx sm+597
	inx
	stx sm+598

	lda #50
	jsr wait

	jsr talkit
	.byte 6,24,0
	.byte "tja,werner", $ff
	.byte "well,werner", $ff

	lda #100
	jsr wait

	jsr talkit
	.byte 6,24,1
	.byte "leider verloren!", $ff
	.byte "so you lose!", $ff

	lda #150
	jsr wait

	jsr talkit
	.byte 6,24,1
	.byte "aber zum glueck", $ff
	.byte "but at least", $ff

	lda #75
	jsr wait

	jsr talkit
	.byte 6,24,1
	.byte "war",39,"s ja kein", $ff
	.byte "it was no", $ff

	lda #75
	jsr wait

	jsr talkit
	.byte 6,24,1
	.byte "blumentopf!", $ff
	.byte "flower pot!", $ff

	lda #100
	jsr wait
	jsr talkout
	lda #100
	jsr wait

	lda #0
	sta x1
	mwa #[sm+19] p1

jlh3	lda #1
	jsr wait
	lda #0
	tay
	sta (p1),y
	iny
	sta (p1),y
	iny
	sta (p1),y
	iny
	sta (p1),y
	ldy #48
	sta (p1),y
	iny
	sta (p1),y
	iny
	sta (p1),y
	iny
	sta (p1),y
	adw p1 #48
	ldy #0
	lda #64
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	ldy #48
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	inc x1
	lda x1
	cmp #10
	bne jlh3
	lda #25
	jsr wait

	lda #32
	ldx #1
	ldy #16
	jsr copychr
	jsr talkit
	.byte 6,24,0
	.byte "...",$ff
	.byte "...",$ff
	lda #200
	jsr wait
	jsr talkit
	.byte 6,24,1
	.byte "oh mann ...",$ff
	.byte "oh damn ...",$ff
	lda #75
	jsr wait
	lda #16
	ldx #1
	ldy #16
	jsr copychr
	jsr talkit
	.byte 6,24,1
	.byte "bei der sauerei",$ff
	.byte "the only thing to",$ff

	lda #75
	jsr wait
	jsr talkit
	.byte 6,24,1
	.byte "hilft nur noch ...",$ff
	.byte "clean the mess is .",$ff

	lda #100
	jsr wait
	jsr talkout
	lda #$3d
	ldx #$48
	ldy #16
	jsr copychr
	lda #$2f
	sta x1
jlh4	ldx x1
	ldy #0
jlh5	lda mielgr+1,y
	sta sm+$210,x
	lda mielgr+11,y
	sta sm+$240,x
	cpx #$2f
	beq *+3
	inx 
	iny 
	cpy #9
	bne jlh5
	lda #0
	jsr wait
	dec x1
	lda x1
	cmp #24
	bne jlh4
	lda #50
	jsr wait
	jsr talkit
	.byte 6,24,0
	.byte "let",39,"s go!",$ff
	.byte "let",39,"s go!",$ff
	lda #75
	jsr wait
	jsr talkout
jlh6	ldx x1
	ldy #0
jlh7	lda kappgr+1,y
	sta sm+$1b0,x
	lda kappgr+11,y
	sta sm+$1e0,x
	lda mielgr+1,y
	sta sm+$210,x
	lda mielgr+11,y
	sta sm+$240,x
	cpx #$2f
	beq *+3
	inx 
	iny 
	cpy #9
	bne jlh7
	lda #0
	jsr wait
	dec x1
	lda x1
	cmp #3
	bne jlh6
	lda #75
	jsr wait

	jsr talkit
	.byte 6,3,0
	.byte "also ich denk",39,$ff
	.byte "well i think",39,$ff
	lda #75
	jsr wait
	jsr talkit
	.byte 6,3,1
	.byte "da unten passt",$ff
	.byte "you'd fit better",$ff
	lda #75
	jsr wait
	jsr talkit
	.byte 6,3,1
	.byte "du besser hin!",$ff
	.byte "down there!",$ff
	lda #75
	jsr wait
	jsr talkout
	lda #50
	jsr wait
	jsr talkit
	.byte 8,3,1
	.byte "wenn du meinst.",$ff
	.byte "if you say so.",$ff
	lda #75
	jsr wait
	jsr talkout
	lda #25
	jsr wait

	ldy #9
jli1	ldx #0
jli2	lda sm+$211,x
	sta sm+$210,x
	lda sm+$241,x
	sta sm+$240,x
	inx 
	cpx #12
	bne jli2
	ldx #3
jli3	stx scrtab+12
	stx scrtab+13
	lda #0
	jsr wait
	dex
	bpl jli3
	dey
	bne jli1
	lda #25
	jsr wait
	lda #$3d
	ldx #$2e
	ldy #16
	jsr copychr
	lda #0
	sta x1
jli4	ldx x1
	ldy #0
jli5	lda mielgr1,y
	sta sm+$41b,x
	lda mielgr1+10,y
	sta sm+$44b,x
	inx 
	iny 
	cpy #9
	bne jli5
	ldx #0
jli6	stx scrtab+23
	stx scrtab+24
	lda #0
	jsr wait
	inx 
	cpx #4
	bne jli6
	inc x1
	lda x1
	cmp #24
	bne jli4

	jsr talkit
	.byte 6,3,0
	.byte "so is besser.",$ff
	.byte "that", 34, "s better.",$ff
	lda #50
	jsr wait
	jsr talkit
	.byte 19,19,1
	.byte "aber auch",$ff
	.byte "but also more",$ff
	lda #75
	jsr wait
	jsr talkit
	.byte 19,19,1
	.byte "gefaehrlicher!",$ff
	.byte "dangerous!",$ff
	lda #125
	jsr wait
	jsr talkit
	.byte 6,3,1
	.byte "hae? wieso?",$ff
	.byte "what? why?",$ff
	lda #100
	jsr wait
	jsr talkit
	.byte 19,19,1
	.byte "auf die tour",$ff
	.byte "this way the",$ff
	lda #100
	jsr wait
	jsr talkit
	.byte 19,19,1
	.byte "stuertzt der",$ff
	.byte "computer often",$ff
	lda #100
	jsr wait
	jsr talkit
	.byte 19,19,1
	.byte "kompuda oft ab!",$ff
	.byte "crashes!",$ff
	lda #100
	jsr wait
	jsr talkout

	lda #$7c
	ldx #$3e
	ldy #$0c
	jsr copychr
	lda #50
	jsr wait
	ldx #0
	ldy #$2f
jli5a	lda #$11
	sta sm+$90,x
	sta sm+$90,y
	lda #$17
	sta sm+$258,x
	sta sm+$228,y
	lda #0
	jsr wait
	inx 
	dey 
	cpx #20
	bne jli5a
	lda #$13
	sta sm+164
	lda #$12
	sta sm+171
	lda #0
	sta x1
jli6a	ldx #0
jli7	stx scrtab+2
	stx scrtab+3
	lda #0
	jsr wait
	inx 
	cpx #4
	bne jli7

	lda #$fc
	sta $d019
	ldx x1
	ldy #0
jli8	lda compgr,y
	ora #$80
	sta sm+$2b,x
	lda compgr+7,y
	ora #$80
	sta sm+$5b,x
	inx 
	iny 
	cpy #7
	bne jli8
	inc x1
	lda x1
	cmp #26
	bne jli6a
	lda #0
	sta scrtab+2
	sta scrtab+3
	lda #0
	sta x1
	mwa #[sm+21] p1
jli9	lda #1
	jsr wait
	lda #0
	tay 
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	ldy #48
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	iny 
	sta (p1),y
	adw p1 #48
	ldy #0
	lda #$3e+$80
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	ldy #48
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	iny 
	adc #1
	sta (p1),y
	inc x1
	lda x1
	cmp #10
	bne jli9

	lda #$88
	ldx #$3e
	ldy #$0c
	jsr copychr
	ldx #$19
jli10	lda $d20a
	and #$70
	sta dl
	lda #0
	jsr wait
	dex 
	bne jli10
	lda #$70
	sta dl
	lda #50
	jsr wait

	ldy #48
jli11	ldx #0
jli12	lda sm+$181,x
	sta sm+$180,x
	inx 
	cpx #$3d
	bne jli12
	lda #0
	jsr wait
	dey 
	bne jli11
	ldy #48
jli13	ldx #0
jli14	lda sm+$1b1,x
	sta sm+$1b0,x
	inx 
	cpx #$3d
	bne jli14
	lda #0
	jsr wait
	dey 
	bne jli13
	jsr talkit
	.byte 5,5,0
	.byte "unn watt nu?",$ff
	.byte "what",34,"s next?",$ff

	lda #100
	jsr wait
	jsr talkout
	lda #$94
	ldx #$4a
	ldy #8
	jsr copychr
	ldy #$2f
jlk1	lda #$4a
	sta sm+$240,y
	lda #0
	jsr wait
	dey 
	bpl jlk1
	ldy #0
jlk2	lda #0
	sta sm+48,y
	sta sm+96,y
	lda #$4e
	sta sm+49,y
	lda #$4f
	sta sm+50,y
	lda #$50
	sta sm+97,y
	lda #$51
	sta sm+98,y
	lda #0
	jsr wait
	iny 
	cpy #18
	bne jlk2
	lda #25
	jsr wait

	lda #$d4
	ldx #$d8
	ldy #24
	sta $d012
	sta $d015
	stx $d013

	sty x1
jlk3	lda x1
	sta $d000
	sta $d001
	sta $d002
	and #1
	beq *+4
	lda #16
	tax
	ldy #$28
	jsr sprite
	lda #$0f
	sta $d201
	lda #0
	jsr wait
	lda #0
	sta $d201
	lda #0
	jsr wait
	inc x1
	lda x1
	cmp #$5e
	bne jlk3
	lda #50
	jsr wait
	lda #$65
	sta $d003
	ldx #48
	ldy #40
	jsr sprite
	lda #10
	jsr wait
	ldx #$40
	ldy #$28
	jsr sprite
	lda #$9c
	ldx #$4e
	ldy #4
	jsr copychr
	lda #$64
	sta $d200
	lda #$68
	sta $d201
	lda #15
	jsr wait
	ldx #48
	ldy #40
	jsr sprite
	lda #10
	jsr wait
	lda #0
	sta $d003
	ldx #16
	ldy #$28
	jsr sprite
	lda #50
	sta x1
jlkx	ldx #$1a
jlk5	lda sm+$1f3,x
	sta sm+$1f4,x
	lda sm+$223,x
	sta sm+$224,x
	dex 
	bne jlk5
	ldx #0
jlk6	stx scrtab+11
	stx scrtab+12
	txa 
	eor #3
	clc 
	adc #$4a
	ldy #$2f
jlk7	sta sm+$240,y
	dey 
	bpl jlk7
	lda #0
	jsr wait
	inx 
	cpx #4
	bne jlk6
	dec x1
	bne jlkx
	ldx #0
	stx scrtab+11
	stx scrtab+12
	lda #$98
	ldx #$4e
	ldy #4
	jsr copychr
	lda #0
	sta $d200
	ldx #$0f
jlk8	stx $d201
	lda #1
	jsr wait
	dex 
	bpl jlk8
	lda #$5e
	sta x1
	lda #$28
	sta x2
	lda x1
	sta $d000
	sta $d001
	sta $d002
	ldx #$50
	ldy x2
	jsr sprite
	lda #0
	jsr wait
	jsr clrpm
jlk9	lda x1
	cmp #$72
	bcc jlk10
	lda x2
	cmp #$70
	bcs jlk10
	inc x2
jlk10	inc x2
	inc x1
	lda x1
	cmp #$d8
	bne jlk9
	ldx #0
	ldy #$2f
jlk11	lda #0
	sta sm+$090,x
	sta sm+$240,y
	lda #0
	jsr wait
	inx 
	dey 
	bpl jlk11

	lda #24
	sta x1
jlk12	lda x1
	sta $d000
	sta $d001
	sta $d002
	cmp #104
	bne jlk13
	lda #0
	sta sm+$42
	sta sm+$43
	sta sm+$72
	sta sm+$73
jlk13	ldx #$50
	ldy #$28
	jsr sprite
	lda #0
	jsr wait
	clc 
	lda x1
	adc #4
	sta x1
	bcc jlk12
;New!
;;	lda #$85
;;	sta wait
	jsr talkit
	.byte 5,3,0
	.byte "und ich dachte", $ff
	.byte "and i thought", $ff
	lda #75
	jsr wait
	jsr talkit
	.byte 5,3,1
	.byte "das kaeme von den", $ff
	.byte "that was due to the", $ff
	lda #75
	jsr wait
	jsr talkit
	.byte 5,3,1
	.byte "computer-viren", $ff
	.byte "computer viruses", $ff

	lda #75
	jsr wait
	jsr talkout

	lda #$85
	sta wait

	jsr clrpm
	lda #128
	sta $d000
	lda #0
	sta $d012
	ldx #15
	lda #$ff
jll1	sta pm+$470,x
	dex
	bpl jll1

	lda #107
	ldx #62
	ldy #17
	jsr copychr

	lda #5
	sta x1

jll2	lda x1
	bne jll3
	ldx #15
	bne jll4
jll3	lda $d20a
	and #31
	tax
	lda $d20a
	and #$f0
	ora #$0c
	sta $d019
jll4	stx jll13+1
	lda #62+$80
	sta sm+488,x
	lda #63+$80
	sta sm+489,x
	lda #64+$80
	sta sm+536,x
	lda #65+$80
	sta sm+537,x
	txa
	asl
	asl
	adc #64
	sta x2
	lda $d20a
	and #1
	sta x3

	lda #$a8
	sta $d201
	ldy #8
jll5	lda x2
	sta $d000
	sta $d200
	lda x3
	bne jll6
	dec x2
	jmp jll7
jll6	inc x2
jll7	lda #0
	jsr wait
	dey
	bpl jll5
	lda x1
	beq jll14
	lda #$44
	sta $d201

	lda #25
	sta x4
jll8	ldx #0
	lda x4
	sta $d200
	and #4
	bne *+4
	ldx #32
	ldy #0
jll9	lda gfx_chr+$338,x
	sta chr+496,y
	inx
	iny
	cpy #32
	bne jll9
	lda #0
	jsr wait
	dec x4
	bne jll8


	lda #$a8
	sta $d201
	ldy #8
jll10	lda x2
	sta $d000
	sta $d200
	lda x3
	beq jll11
	dec x2
	jmp jll12
jll11	inc x2
jll12	lda #0
	jsr wait
	dey
	bpl jll10
	lda #0
	sta $d201
jll13	ldx #0
	lda #0
	sta sm+488,x
	sta sm+489,x
	sta sm+536,x
	sta sm+537,x

	lda #30
	jsr wait
	dec x1
	jmp jll2

jll14	lda #0
	sta $d200
	sta $d201


	jsr talkit
	.byte 7,19,1
	.byte "harr,ich bin ein", $ff
	.byte "harr,i am a", $ff
	jsr virus_talk

	jsr talkit
	.byte 7,19,1
	.byte "computer-virus", $ff
	.byte "computer virus", $ff
	jsr virus_talk

	jsr talkit
	.byte 7,19,1
	.byte "und ich werde nun", $ff
	.byte "and i am going to", $ff
	jsr virus_talk

	jsr talkit
	.byte 7,19,1
	.byte "alles formatieren!", $ff
	.byte "format everything!", $ff
	jsr virus_talk
	rts

	.endp		;End of story
code_end

	.if code_end >=sound_start
	.error "code_end ",code_end, " >= sound_start ", sound_start
	.endif

	org text_chr
	ins "BadekappMiel.chr"

	org grafp1
	ins "BadekappMiel.plr"
	
	org gfx_chr
	ins "BadekappMiel.grf"


;==========================================================

	org sound_start

	.local sound

	ins "BadekappMiel-CMC-Player-$5000.bin"

player		= $5000
player.init	= $5003
player.play	= $5006
player.posptr	= $500c
player.possng	= $500d

;==========================================================

	.proc init		;Initializes the first song
	ldx #<music
	ldy #>music
	lda #$70		;Init code
	jsr player.init
	lda #$00		;Set song code
	tax			;First song
	jmp player.init
	.endp

;==========================================================

	.proc play		 ;Plays sound per frame including volume control

	jmp player.play
	rts
	.endp

;==========================================================

	org music_start
music

	ins "BadekappMiel-505-Numb.cmc",+6

	.endl	;End of sound

;==========================================================

	run main
