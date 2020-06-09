.data
count_prompt:   .asciiz "Enter count(number of integers to be input): "
endl:           .asciiz "\n"
error_prompt:   .asciiz "Error"
input_prompt:   .asciiz "Enter integers: \n"
k_prompt:       .asciiz "Enter k: "
max_data:       .word 0 0 0 0
max_prompt:     .asciiz "kth largest integer is: "


.text
main:
    la $t6, max_data
    add $t7, $t6, 4
    add $t8, $t6, 8
    add $t9, $t6, 12



    li $v0, 4
    la $a0, count_prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0
    move $s7, $t0

    li $v0, 4
    la $a0, input_prompt
    syscall

    li $v0, 5
    syscall
    move $t1, $v0
    add $t0, $t0, -1

    li $s5, -2147483647
    sw $v0, ($t9)
    sw $s5, ($t8)
    sw $s5, ($t7)
    sw $s5, ($t6)

loop:
    lw $s0, ($t6)
    lw $s1, ($t7)
    lw $s2, ($t8)
    lw $s3, ($t9)
    beqz $t0, done
    li $v0, 5
    syscall
    blt $s3, $v0, notmax3
    blt $s2, $v0, notmax2
    blt $s1, $v0, notmax1
    blt $s0, $v0, notmaxall
    j again

notmax3:
    sw $s3, ($t8)
    sw $s2, ($t7)
    sw $s1, ($t6)
    sw $v0, ($t9)
    j again
notmax2:
    sw $s2, ($t7)
    sw $s1, ($t6)
    sw $v0, ($t8)
    j again
notmax1:
    sw $s1, ($t6)
    sw $v0, ($t7)
    j again
notmaxall:
    sw $v0, ($t6)
again:
    add $t0, $t0, -1
    j loop

done:
    la $t6, max_data
    add $t7, $t6, 4
    add $t8, $t6, 8
    add $t9, $t6, 12

    li $v0, 4
    la $a0, k_prompt
    syscall

    li $v0, 5
    syscall

    ble $v0, $s7, noerror
    
    li $v0, 4
    la $a0, error_prompt
    syscall
    j alldone

noerror:
    
    beq $v0, 1, k1
    beq $v0, 2, k2
    beq $v0, 3, k3
    beq $v0, 4, k4
k1:
    lw $t1, ($t9)
    j final
k2:
    lw $t1, ($t8)
    j final
k3:
    lw $t1, ($t7)
    j final
k4:
    lw $t1, ($t6)
    j final
final:

    li $v0, 4
    la $a0, max_prompt
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

alldone:

    li $v0, 4
    la $a0, endl
    syscall
    li $v0, 10
    syscall
.end
