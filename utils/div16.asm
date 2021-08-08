.export div16

.include "utils/reg.inc"

.macro sub16 lhs, rhs
   sec

   ; lo byte
   lda lhs
   sbc rhs
   sta lhs
   
   ; hi byte
   lda lhs+1
   sbc rhs+1
   sta lhs+1
.endmacro

; r0 - value
; r1 - divisor
; when finished REG::r2 will contain the mod value
.proc div16

DIV      = REG::r0;
DIVISOR  = REG::r1;
MOD      = REG::r2;
TMP      = REG::t0

   stz MOD
   stz MOD+1
   clc
   ldx #16

@loop:
   rol DIV
   rol DIV+1
   rol MOD
   rol MOD+1

   lda MOD
   sta TMP
   lda MOD+1
   sta TMP+1

   sub16 TMP, DIVISOR
   bcc @ignore ; carry clear indicates that MOD is less than DIVISOR
   
   lda TMP
   sta MOD
   lda TMP+1
   sta MOD+1
@ignore:
   dex
   bne @loop
   rol DIV
   rol DIV+1

   rts
.endproc