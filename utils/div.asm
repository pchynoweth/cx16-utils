.export div

.include "utils/reg.inc"

; when finished gREG::r0H will contain the mod value
.proc div

DIV      = REG::r0L;
MOD      = REG::r0H;
DIVISOR  = REG::r1L;

   phx
   phy
   pha

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

   pla
   ply
   plx
   rts
.endproc