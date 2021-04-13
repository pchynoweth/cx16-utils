.include "utils/bzero.mac"
.include "utils/sysout.mac"

.include "utils/boilerplate.inc"

.include "cx16.inc"
.include "cbm_kernal.inc"

.export init_test_suite, finish_test_suite, scenario
.export check_reg, check_reg16, check_memory
.import bzero, putint16, puts, sysout, puthex16

.rodata

running_msg: .asciiz "running"
test_msg: .asciiz "test "
passed_msg: .asciiz "passed"
failed_msg: .asciiz "failed"
expected_msg: .asciiz "expected '"
got_msg: .byte "'", CH::ENTER, "got      '", 0
scenario_msg: .asciiz "scenario "
summary_msg: .asciiz "summary"
line_msg:    .asciiz "======="
total_msg: .asciiz "total:  "

.data

.struct testState
    pass    .word
    fail    .word
    desc    .word ; Description of current scenario
    curr    .word ; current test within scenario
.endstruct

state: .tag testState

.code

.proc init_test_suite
    storeaddr REG::r0, state+testState::pass
    lda .SIZEOF(testState)
    jsr bzero
    rts
.endproc

.proc finish_test_suite
    calli puts, summary_msg
    lda #CH::ENTER
    jsr CHROUT
    calli puts, line_msg
    lda #CH::ENTER
    jsr CHROUT

    calli puts, total_msg
    call putint16, state+testState::curr
    lda #CH::ENTER
    jsr CHROUT

    calli puts, passed_msg
    lda #':'
    jsr CHROUT
    lda #' '
    jsr CHROUT
    call putint16, state+testState::pass
    lda #CH::ENTER
    jsr CHROUT

    calli puts, failed_msg
    lda #':'
    jsr CHROUT
    lda #' '
    jsr CHROUT
    call putint16, state+testState::fail
    lda #CH::ENTER
    jsr CHROUT

    lda state+testState::fail
    ora state+testState::fail+1
    beq @passed
    calli puts, failed_msg
    bra @done
@passed:
    calli puts, passed_msg
@done:
    lda #CH::ENTER
    jsr CHROUT
    rts
.endproc

; invalidates a,x
.proc scenario
    copyaddr state+testState::desc, REG::r0

    stz state+testState::curr
    stz state+testState::curr+1

    calli puts, running_msg
    lda #':'
    jsr CHROUT
    lda #' '
    jsr CHROUT
    call puts, state+testState::desc
    lda #CH::ENTER
    jsr CHROUT
    rts
.endproc

.macro inc16 ptr
    .Local @done
    inc ptr
    bne @done
    inc ptr+1
@done:
.endmacro

.proc complete
    inc16 state+testState::curr

    call puts, state+testState::desc

    lda #':'
    jsr CHROUT

    call putint16, state+testState::curr

    lda #':'
    jsr CHROUT
    lda #' '
    jsr CHROUT

    rts
.endproc

.proc passed
    inc16 state+testState::pass
    jsr complete

    calli puts, test_msg
    calli puts, passed_msg
    lda #CH::ENTER
    jsr CHROUT

    rts
.endproc

.proc failed
    inc16 state+testState::fail
    jsr complete

    calli puts, test_msg
    calli puts, failed_msg
    lda #CH::ENTER
    jsr CHROUT

    rts
.endproc

.macro __CHECK_REG expected, COMPARE
    .Local @failed
    COMPARE expected
    bne @failed
    jsr passed
    rts
@failed:
    jsr failed
    rts
.endmacro

; r0L - val
; r1L - expected
.proc check_reg
    lda REG::r0
    cmp REG::r1
    bne @failed
    jsr passed
    rts
@failed:
    jsr failed
    rts
.endproc

; r0 - val
; r1 - expected
.proc check_reg16
    lda REG::r0
    cmp REG::r1
    bne @failed
    lda REG::r0+1
    cmp REG::r1+1
    bne @failed
    jsr passed
    rts
@failed:
    pushaddr REG::r0
    pushaddr REG::r1
    jsr failed
    calli puts, expected_msg
    pulladdr REG::r0
    jsr puthex16
    calli puts, got_msg
    pulladdr REG::r0
    jsr puthex16
    lda #$27
    jsr CHROUT
    lda #CH::ENTER
    jsr CHROUT
    rts
.endproc

; r0 - data addr
; r1 - expected value data addr
; .a - length
.proc check_memory
    sta REG::t0
    ldy #0
@loop:
    lda (REG::r1),y
    cmp (REG::r0),y
    bne @failed
    iny
    cpy REG::t0
    bne @loop
    jsr passed
    rts
@failed:
    pushaddr REG::r0
    lda REG::t0
    pha
    pushaddr REG::r1
    jsr failed
    calli puts, expected_msg
    pulladdr REG::r0
    pla
    pha
    jsr sysout
    calli puts, got_msg
    pla
    sta REG::t0
    pulladdr REG::r0
    lda REG::t0
    jsr sysout
    lda #$27
    jsr CHROUT
    lda #CH::ENTER
    jsr CHROUT
    rts
.endproc