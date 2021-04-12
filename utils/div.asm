.export div

.include "utils/reg.inc"

; r0L - value
; r1L - divisor
; when finished gREG::r0H will contain the mod value
.proc div

DIV      = REG::r0L;
MOD      = REG::r0H;
DIVISOR  = REG::r1L;

   stz MOD
   clc
   ldx #8

@loop:
   rol DIV
   rol MOD

   lda MOD
   sec
   sbc DIVISOR
   bcc @ignore
   sta MOD
@ignore:
   dex
   bne @loop
   rol DIV

   rts
.endproc