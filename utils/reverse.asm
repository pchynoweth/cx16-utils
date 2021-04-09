.export reverse

.macpack generic

.include "utils/reg.inc"

; r0 - address of input string
; .A - length
.proc reverse

STR  = REG::r0L
LHS  = REG::r1L
RHS  = REG::r1H
TEMP = REG::r2L

   tay
   beq @done
   dec
   beq @done
   sta RHS
   lda #0
   sta LHS

@loop:
   ; rhs -> temp
   lda RHS
   tay
   lda (STR), y
   sta TEMP

   ; lhs -> rhs
   lda LHS
   tay
   lda (STR), y
   tax
   lda RHS
   tay
   txa
   sta (STR), y

   ; temp -> lhs
   lda LHS
   tay
   lda TEMP
   sta (STR), y

   ; move pointers
   dec RHS
   inc LHS
   lda RHS
   cmp LHS
   bge @loop
@done:
   rts
.endproc