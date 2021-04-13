.export putint16

.include "utils/reg.inc"
.include "cbm_kernal.inc"

.code

.proc putint16
r0 = REG::r0;
bcd = REG::t0

   ; intialize BCD number to zero
   stz bcd
   stz bcd+1
   stz bcd+2
   ; check for negative
   bit r0+1
   bpl @convert
   ; subtract from zero to get negated value
   lda #0
   sec
   sbc r0
   sta r0
   lda #0
   sbc r0+1
   sta r0+1
   lda #'-'
   jsr CHROUT
@convert:
   ; convert 16-bit r0 to 5-digit BCD
   sed
   ldx #16
@main_loop:
   ; shift highest bit to C
   asl r0
   rol r0+1
   ldy #0
   ; BCD = BCD*2 + C
   php
@add_loop:
   plp
   lda bcd,y
   adc bcd,y
   sta bcd,y
   php
   iny
   cpy #3
   bne @add_loop
   plp
   dex
   bne @main_loop
   cld
   ; print BCD as PETSCII string
   ldy #2
@trim_lead:
   lda bcd,y
   bne @check_upper
   dey
   bne @trim_lead
   lda bcd,y
@check_upper:
   bit #$F0
   beq @print_lower
@print_upper:
   pha
   lsr
   lsr
   lsr
   lsr
   ora #'0'
   jsr CHROUT
   pla
@print_lower:
   and #$0F
   ora #'0'
   jsr CHROUT
@print_rest:
   dey
   bmi @return
   lda bcd,y
   bra @print_upper
@return:
   rts
.endproc
