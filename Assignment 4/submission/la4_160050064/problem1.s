.data
	array	:		.space 500
	endl	:		.asciiz "\n"

.text
main:
	li $v0, 5
	syscall
	move $t0, $v0

	la $s0, array

take_array_input:
	li $v0, 5
	syscall
	sw $v0, ($s0)

	addi $s0, 4
	addi $t0, -1

	bnez $t0, take_array_input

	li $v0, 5
	syscall
	move $t1, $v0

	move $a0, $t1
	la $a1, array
	move $a2, $s0
	move $v0, $0
	jal count_in_array
	move $t2, $v0

	li $v0, 1
	move $a0, $t2
	syscall

all_done:
	li $v0, 4
	la $a0, endl
	syscall

	li $v0, 10
	syscall


count_in_array:
		bge $a1, $a2, base_case

		addi $sp, -4
		sw $ra, 0($sp)

		lw $t0, ($a1)
		beq $a0, $t0, found
		addi $a1, 4
		jal count_in_array

		lw $ra, 0($sp)
		addi $sp, 4
		jr $ra

	found:
		addi $a1, 4
		jal count_in_array
		addi $v0, 1

		lw $ra, 0($sp)
		addi $sp, 4
		jr $ra

	base_case:
		move $v0, $0
		jr $ra

