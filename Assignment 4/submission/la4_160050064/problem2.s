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

	la $s3, array
	move $s4, $s0

	la $a0, array
	move $a1, $s0
	jal merge_sort

print_array:
	li $v0, 1
	lw $a0, ($s3)
	syscall

	li $v0, 4
	la $a0, endl
	syscall

	addi $s3, 4
	blt $s3, $s4, print_array

all_done:
	li $v0, 10
	syscall

merge_sort:
	addi $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)

	sub $t0, $a1, $a0

	ble $t0, 4, merge_sort_end

	srl $t0, $t0, 3
	sll $t0, $t0, 2
	add $a1, $a0, $t0
	sw $a1, 12($sp)

	jal merge_sort

	lw $a0, 12($sp)
	lw $a1, 8($sp)

	jal merge_sort

	lw $a0, 4($sp)
	lw $a2, 8($sp)
	lw $a1, 12($sp)

	jal merge_sorted_arrays

merge_sort_end:
	lw $ra, 0($sp)
	addi $sp, 16
	jr $ra

merge_sorted_arrays:
	addi $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)

	move $s0, $a0
	move $s1, $a1

merge_sorted_arrays_loop:
	lw $t0, 0($s0)
	lw $t1, 0($s1)

	bgt $t1, $t0, no_shift

	move $a0, $s1
	move $a1, $s0
	jal shift_element

	addi $s1, 4

no_shift:
	addi $s0, 4

	lw $a2, 12($sp)
	bge $s0, $a2, merge_sorted_arrays_loop_end
	bge $s1, $a2, merge_sorted_arrays_loop_end
	j merge_sorted_arrays_loop

merge_sorted_arrays_loop_end:
	lw $ra, 0($sp)
	addi $sp, 16
	jr $ra

shift_element:
	ble $a0, $a1, shift_element_end
	addi $t6, $a0, -4
	lw $t7, 0($a0)
	lw $t8, 0($t6)
	sw $t7, 0($t6)
	sw $t8, 0($a0)
	move $a0, $t6
	j shift_element

shift_element_end:
	jr $ra