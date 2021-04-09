.include "utils/reg.inc"

.macro pushaddr addr
    lda addr
    pha
    lda addr+1
    pha
.endmacro

.macro pulladdr addr
    pla
    sta addr+1
    pla
    sta addr
.endmacro

.macro copyaddr dst, src
    lda src
    sta dst
    lda src+1
    sta dst+1
.endmacro

.macro call sub, p0, p1, p2, p3
    .if (.paramcount > 1)
        copyaddr REG::r0, p0
    .endif
    .if (.paramcount > 2)
        copyaddr REG::r1, p1
    .endif
    .if (.paramcount > 3)
        copyaddr REG::r2, p2
    .endif
    .if (.paramcount > 4)
        copyaddr REG::r3, p3
    .endif
    .if (.paramcount > 5)
        .fatal "Too many arguments"
    .endif
    jsr sub
.endmacro

.macro storeaddr dst, addr
    lda #<addr
    sta dst
    lda #>addr
    sta dst+1
.endmacro

.macro calli sub, p0, p1, p2, p3
    .if (.paramcount > 1)
        storeaddr REG::r0, p0
    .endif
    .if (.paramcount > 2)
        storeaddr REG::r1, p1
    .endif
    .if (.paramcount > 3)
        storeaddr REG::r2, p2
    .endif
    .if (.paramcount > 4)
        storeaddr REG::r3, p3
    .endif
    .if (.paramcount > 5)
        .fatal "Too many arguments"
    .endif
    jsr sub
.endmacro