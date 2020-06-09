.data
count_prompt:	.asciiz "Enter count(number of integers to be input): "
endl:   .asciiz "\n"
input_prompt:	.asciiz "Enter integers: \n"
max_prompt:	.asciiz "Largest integer is: "

.text
main:
    li $v0, 4
    la $a0, count_prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    li $v0, 4
    la $a0, input_prompt
    syscall

    li $v0, 5
    syscall
    move $t1, $v0
    add $t0, $t0, -1

loop:
    beqz $t0, done
    li $v0, 5
    syscall
    bge $t1, $v0, notmax
    move $t1, $v0

notmax:
    add $t0, $t0, -1
    j loop

done:
    li $v0, 4
    la $a0, max_prompt
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, endl
    syscall

    li $v0, 10
    syscall
.end
