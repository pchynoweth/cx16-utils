.export bzero16

.include "utils/reg.inc"

.macro inc16 addr
    .Local @done
    inc addr
    bne @done
    inc addr+1
@done:
.endmacro

.macro dec16 addr
    .Local @done
    dec addr
    bne @done
    dec addr+1
@done:
.endmacro

.macro add16 addr
    clc
    adc addr
    sta addr
    lda #0
    adc addr+1
    sta addr+1
.endmacro

.macro add16x16 lhs, rhs
    clc
    lda lhs
    adc rhs
    sta lhs
    lda lhs+1
    adc rhs+1
    sta lhs+1
.endmacro

.macro sub16 addr
    sec
    sbc addr
    sta addr
    lda #0
    sbc addr+1
    sta addr+1
.endmacro

.macro cmp16 lhs, rhs
    .Local @done
    lda lhs
    cmp rhs
    bne @done
    lda lhs+1
    cmp rhs+1
@done:
.endmacro

; r0 - address to initialise
; r1 - size
.proc bzero16
    add16x16 REG::r1, REG::r0
@loop:
    lda #0
    sta (REG::r0)
    inc16 REG::r0
    cmp16 REG::r0, REG::r1
    bne @loop
    rts
.endproc