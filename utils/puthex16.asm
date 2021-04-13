.export puthex16
.import puthex

.include "utils/reg.inc"

.code

.proc puthex16
   lda REG::r0
   pha
   lda REG::r0+1
   sta REG::r0
   jsr puthex

   pla
   sta REG::r0
   jsr puthex
   rts
.endproc
