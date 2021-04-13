.include "cx16.inc"
.include "cbm_kernal.inc"
.macpack generic

.include "utils/boilerplate.inc"

.code
   jmp start

.import scenario, init_test_suite, finish_test_suite
.import check_reg16, check_memory
.import div

.code

; PETSCII Codes
CLR               = $93

.rodata

basic_desc: .asciiz "basic - div"
zero_desc: .asciiz "zero - div"
one_desc: .asciiz "one - div"
max_desc: .asciiz "max - div"

.data

.code

start:
   ; clear screen, set text to white
   lda #CLR
   jsr CHROUT
   lda #CH::WHITE
   jsr CHROUT
   jsr test_div
   rts

.macro RUN_TEST val, divisor, result, mod
   lda val
   sta REG::r0L
   lda divisor
   sta REG::r1L
   jsr div

   ; check result
   lda result
   sta REG::r1
   lda mod
   sta REG::r1+1
   jsr check_reg16
.endmacro

.proc test_div
   jsr init_test_suite

   calli scenario, basic_desc
   RUN_TEST #30, #3, #10, #0
   RUN_TEST #31, #3, #10, #1
   RUN_TEST #29, #3, #9, #2

   calli scenario, zero_desc
   RUN_TEST #0, #3, #0, #0
   RUN_TEST #0, #1, #0, #0
   RUN_TEST #0, #255, #0, #0

   calli scenario, one_desc
   RUN_TEST #1, #1, #1, #0
   RUN_TEST #1, #2, #0, #1
   RUN_TEST #1, #255, #0, #1

   calli scenario, max_desc
   RUN_TEST #255, #3, #85, #0

   jsr finish_test_suite
   rts
.endproc