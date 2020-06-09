		.text
main:	daddi	r1,r0,18
		bnez	r1,my_branch
		daddi	r1,r1,6
		halt

branch:	daddi	r1,r1,5
		halt
