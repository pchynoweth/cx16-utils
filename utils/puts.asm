.export puts

.include "cx16.inc"
.include "cbm_kernal.inc"
.include "utils/reg.inc"

.code

; invalidates a,y
.proc puts
    ldy #0
@loop:
    lda (REG::r0), y
    beq @done
    jsr CHROUT
    iny
    bra @loop
@done:
    rts
.endproc
