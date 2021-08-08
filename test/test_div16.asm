.include "cx16.inc"
.include "cbm_kernal.inc"
.macpack generic

.include "utils/boilerplate.inc"

.code
   jmp start

.import scenario, init_test_suite, finish_test_suite
.import check_reg16, check_memory
.import div16

.code

; PETSCII Codes
CLR               = $93

.rodata

basic_desc: .asciiz "basic - div16"
zero_desc: .asciiz "zero - div16"
one_desc: .asciiz "one - div16"
max_desc: .asciiz "max - div16"

.data

.code

start:
   ; clear screen, set text to white
   lda #CLR
   jsr CHROUT
   lda #CH::WHITE
   jsr CHROUT
   jsr test_div16
   rts

.macro LOAD_CONST_16 target, src
   lda #<src
   sta target
   lda #>src
   sta target+1
.endmacro

.macro RUN_TEST val, divisor, result, mod
   LOAD_CONST_16 REG::r0, val
   LOAD_CONST_16 REG::r1, divisor
   jsr div16

   ; check result
   LOAD_CONST_16 REG::r1, result
   jsr check_reg16

   lda REG::r2
   sta REG::r0
   lda REG::r2+1
   sta REG::r0+1
   LOAD_CONST_16 REG::r1, mod
   jsr check_reg16
.endmacro

.proc test_div16
   jsr init_test_suite

   calli scenario, basic_desc
   RUN_TEST 30, 3, 10, 0
   RUN_TEST 31, 3, 10, 1
   RUN_TEST 29, 3, 9, 2

   calli scenario, zero_desc
   RUN_TEST 0, 3, 0, 0
   RUN_TEST 0, 1, 0, 0
   RUN_TEST 0, 255, 0, 0

   calli scenario, one_desc
   RUN_TEST 1, 1, 1, 0
   RUN_TEST 1, 2, 0, 1
   RUN_TEST 1, 255, 0, 1

   calli scenario, max_desc
   RUN_TEST 255, 3, 85, 0
   RUN_TEST 256, 3, 85, 1
   RUN_TEST 65535, 3, 21845, 0
   RUN_TEST 65534, 256, 255, 254

   jsr finish_test_suite
   rts
.endproc