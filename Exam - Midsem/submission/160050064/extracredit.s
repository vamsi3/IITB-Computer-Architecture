.data
	input:			.space		500
	hello_prompt:	.asciiz		"Hello,please enter command:"
	count_prompt:	.asciiz		"Enter Number of characters in string:"
	string_prompt:	.asciiz		"Enter String:"
	endl:			.asciiz		"\n"
	yes:			.asciiz		"YES"
	no:				.asciiz		"NO"
	gap:			.asciiz		" "

.text
main:
	li $v0, 4
	la $a0, hello_prompt
	syscall

	li $v0, 8
	la $a0, input
	li $a1, 2
	syscall

	li $v0, 4
	la $a0, endl
	syscall

	la $t0, input
	lb $t0, 0($t0)

	li $t1, 0x51
	beq $t0, $t1, exit

	li $t1, 0x43
	beq $t0, $t1, command_C

	j main

command_C:
	li $v0, 4
	la $a0, count_prompt
	syscall

	li $v0, 5
	syscall
	move $s0, $v0

	li $v0, 4
	la $a0, string_prompt
	syscall

	li $v0, 8
	la $a0, input
	move $a1, $s0
	addiu $a1, 1
	syscall

	li $v0, 4
	la $a0, endl
	syscall

	### TODO Stuff		# s0 -> len of string, input -> contains string.

	la $s1, input
	la $s2, input
	move $t2, $s0
end_addr_loop:
	beq $t2, $0, end_addr_loop_done
	addiu $t2, -1
	addiu $s2, 1
	j end_addr_loop
end_addr_loop_done:


	# EXTRA CREDIT
	move $a0, $s1
	move $a1, $s2
	jal lower_casify
	# EXTRA CREDIT ends


	move $a0, $s1
	move $a1, $s2
	jal part_a
	move $t0, $v0

	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 4
	la $a0, gap
	syscall

	move $a0, $s1
	move $a1, $s2
	addiu $a1, -1
	jal part_b
	move $t0, $v0

	li $v0, 4

	beq $t0, $0, not_palindrome
	la $a0, yes
	j part_b_return_set
not_palindrome:
	la $a0, no
part_b_return_set:
	syscall

	li $v0, 4
	la $a0, endl
	syscall

	### TODO ends

	j main

exit:
	li $v0, 10
	syscall



part_a:
	# prologue
	addiu $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	# done

	li $v0, 0
	move $t0, $a0
	move $t1, $a1
	addiu $t1, -2

part_a_main_loop:
	bge $t0, $t1, part_a_main_loop_done
	lb $t4, 0($t0)
	lb $t5, 1($t0)
	lb $t6, 2($t0)
	li $t7, 0x31
	li $t8, 0x32

	bne $t4, $t7, no_increase
	bne $t5, $t8, no_increase
	bne $t6, $t7, no_increase
	addiu $v0, 1
no_increase:
	addiu $t0, 1
	j part_a_main_loop
part_a_main_loop_done:

	# epilogue
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addiu $sp, 16
	# done

	jr $ra



part_b:
	# prologue
	addiu $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $a0, 16($sp)
	sw $a1, 20($sp)
	# done

	bge $a0, $a1, base_case

	addiu $a0, 1
	addiu $a1, -1
	jal part_b
	move $t0, $v0
	addiu $a0, -1
	addiu $a1, 1

	lb $t1, 0($a0)
	lb $t2, 0($a1)

#	move $s6, $a0
#	move $s5, $v0
#	#test
#	li $v0, 1
#	move $a0, $t1
#	syscall

#	li $v0, 4
#	la $a0, endl
#	syscall

#	li $v0, 1
#	move $a0, $t2
#	syscall

#	li $v0, 4
#	la $a0, endl
#	syscall
#	#testdone
#	move $v0, $s5
#	move $a0, $s6

	beq $t1, $t2, positive
	move $v0, $0
	j part_b_return
positive:
	move $v0, $t0
	j part_b_return

base_case:
	move $v0, $0
	addiu $v0, 1
	j part_b_return

part_b_return:

	# epilogue
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	sw $a0, 16($sp)
	sw $a1, 20($sp)
	addiu $sp, 24
	# done

	jr $ra


lower_casify:
	# prologue
	addiu $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	# done

	move $t0, $a0
	move $t1, $a1

lower_casify_main_loop:
	bge $t0, $t1, lower_casify_main_loop_done
	lb $t2, 0($t0) 
	blt $t2, 0x41, lower_casify_ignore
	bgt $t2, 0x5a, lower_casify_ignore
	addiu $t2, 32
	sb $t2, 0($t0)
lower_casify_ignore:
	addiu $t0, 1
	j lower_casify_main_loop

lower_casify_main_loop_done:

	# epilogue
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addiu $sp, 16
	# done

	jr $ra