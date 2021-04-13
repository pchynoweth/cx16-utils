.export puthex

.macpack generic

.include "utils/reg.inc"
.include "cbm_kernal.inc"

.code

; .a - byte with high order nibble zeroed
.proc printc
   cmp #$a
   bcc @number
   clc
   adc #'a'-10
   bra @print
@number:
   clc
   adc #'0'
@print:
   jsr CHROUT
   rts
.endproc

.proc puthex
   lda REG::r0
   lsr
   lsr
   lsr
   lsr

   jsr printc

   lda REG::r0
   and #$f
   bra printc ; intentionally bra to return immediately from subroutine
.endproc
