.export sysout

.include "cbm_kernal.inc"
.include "utils/reg.inc"

; invalidates y, a
; r0 - data addr
; .a - length
.proc sysout
    sta REG::t0
    ldy #0
@loop:
    cpy REG::t0
    beq @done
    lda (REG::r0), y
    jsr CHROUT
    iny
    bra @loop
@done:
    rts
.endproc