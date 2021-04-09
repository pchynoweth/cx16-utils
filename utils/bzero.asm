.export bzero

.include "utils/reg.inc"

; invalidates x,y
; r0 - address to initialise
; .a - size
.proc bzero
    sta REG::t0
    ldy #0
@loop:
    lda #0
    sta (REG::r0), y
    iny
    cpy REG::t0
    bne @loop
    rts
.endproc