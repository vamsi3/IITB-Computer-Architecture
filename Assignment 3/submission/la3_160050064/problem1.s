.data
operation_prompt:	.asciiz "Enter operation code (1-add, 2-subtract, 3-multiply, 4-exponentiation, 5-inversion, 6-logarithm, 7-exit): "
a_prompt:			.asciiz "Enter a: "
b_prompt:			.asciiz "Enter b: "
n_prompt:			.asciiz "Enter n: "
result_prompt:		.asciiz "Result = "
no_solution_prompt: .asciiz "No Solution"
endl:				.asciiz "\n"

.text
main:
	# initialize all temporary registers to zero
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0

	# prompt and take operation as input
    li $v0, 4
    la $a0, operation_prompt
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    # if exit, branch to exit
    beq $t0, 7, exit

    # prompt and take a as input
    li $v0, 4
    la $a0, a_prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    # prompt and take b as input
    li $v0, 4
    la $a0, b_prompt
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    # prompt and take n as input
    li $v0, 4
    la $a0, n_prompt
    syscall
    li $v0, 5
    syscall
    move $t3, $v0

    # branch according to operation
    beq $t0, 1, addition
    beq $t0, 2, subtraction
    beq $t0, 3, multiplication
    beq $t0, 4, exponentiation
    beq $t0, 5, inverse
    beq $t0, 6, discrete_logarithm

addition:
	add $t4, $t1, $t2
	div $t4, $t3
	mfhi $t4
	j operation_done

subtraction:
	sub $t4, $t1, $t2
	div $t4, $t3
	mfhi $t4
	j operation_done

multiplication:
	mult $t1, $t2
	mflo $t4
	div $t4, $t3
	mfhi $t4
	j operation_done

exponentiation:
	li $t4, 1
	li $t6, 1

exponentiation_loop:
	and $t5, $t2, $t6
	beq $t5, $0, no_exponentiation_multiply
	mult $t4, $t1
	mflo $t4

no_exponentiation_multiply:
	mult $t1, $t1
	mflo $t1
	div $t4, $t3
	mfhi $t4
	div $t2, $t6
	srlv $t2, $t2, $t6
	bnez $t2, exponentiation_loop
	j operation_done

inverse:
    add $t4, $t4, 1
    mult $t1, $t4
    mflo $t5
    div $t5, $t3
    mfhi $t5
    beq $t4, $t3, no_inverse_found
    bne $t5, 1, inverse
    j operation_done

no_inverse_found:
    # prompt the result string
    li $v0, 4
    la $a0, result_prompt
    syscall
    la $a0, no_solution_prompt
    syscall
    la $a0, endl
    syscall

    # looping ack again for next operation
    j loop_again

discrete_logarithm:
    li $t6, 1
    div $t2, $t3
    mfhi $t2
    add $t4, $t4, -1

discrete_logarithm_loop:
    add $t4, $t4, 1
    mult $t6, $t1
    mflo $t6
    div $t6, $t3
    mfhi $t7
    beq $t4, $t3, no_discrete_logarithm_found
    bne $t7, $t2, discrete_logarithm_loop
    j operation_done

no_discrete_logarithm_found:
    # prompt the result string
    li $v0, 4
    la $a0, result_prompt
    syscall
    la $a0, no_solution_prompt
    syscall
    la $a0, endl
    syscall

    # looping ack again for next operation
    j loop_again

operation_done:
    # making answer positive
    add $t4, $t4, $t3
    div $t4, $t3
    mfhi $t4

	# prompt the result string
    li $v0, 4
    la $a0, result_prompt
    syscall

    # display the result value
    li $v0, 1
    move $a0, $t4
    syscall

    # display a new line
    li $v0, 4
    la $a0, endl
    syscall

loop_again:
    # go back in loop to ask for next operation
	j main

exit:
    li $v0, 10
    syscall

.end
