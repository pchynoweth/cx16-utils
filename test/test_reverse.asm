.include "cx16.inc"
.include "cbm_kernal.inc"
.macpack generic

.include "utils/boilerplate.inc"

.code
   jmp start

.import reverse, scenario, check_memory, init_test_suite, finish_test_suite

.code

.macro check_char c, sub, next
   .Local @skip
   cmp c
   bne @skip
   jsr sub
   bra next
@skip:
.endmacro

.macro memcpy dst, src
   pha
   lda src
   sta dst
   lda src+1
   sta dst+1
   pla
.endmacro

; PETSCII Codes
CLR               = $93

.rodata

desc: .asciiz "reverse"

.data

test_string: .byte "0123456789"
test_string_end: .byte 0
expected: .asciiz "9876543210"

.code

start:
   ; clear screen, set text to white
   lda #CLR
   jsr CHROUT
   lda #CH::WHITE
   jsr CHROUT
   jsr test_div
   jsr test_reverse
   rts

.proc test_div
   rts
.endproc

.proc test_reverse
   jsr init_test_suite
   calli scenario, desc

   ; test one
   storeaddr REG::r0, test_string
   lda #(test_string_end-test_string)
   jsr reverse

   storeaddr REG::r1, expected
   lda #(test_string_end-test_string)
   jsr check_memory

   ; test two - empty
   lda #'a'
   sta test_string
   sta expected
   storeaddr REG::r0, test_string
   lda #0
   jsr reverse

   storeaddr REG::r1, expected
   lda #1
   jsr check_memory

   ; test three - 1 element
   lda #'a'
   sta test_string
   sta expected
   storeaddr REG::r0, test_string
   lda #1
   jsr reverse

   storeaddr REG::r1, expected
   lda #1
   jsr check_memory

   jsr finish_test_suite
   rts
.endproc