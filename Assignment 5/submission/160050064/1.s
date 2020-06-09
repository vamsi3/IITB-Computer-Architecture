		.data
v1:		.double 4.5
v2:		.double 5.6 

		.text
main:	daddi	r1,r0,108
		daddi	r2,r0,10
		l.d		f1,v1(r0)
		l.d		f2,v2(r0)

		dmul	r3,r1,r2
		ddiv	r4,r1,r2

		add.d	f3,f1,f2
		mul.d	f4,f1,f2
		div.d	f5,f1,f2

		halt
