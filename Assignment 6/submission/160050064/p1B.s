	.data
a:	.double	0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,0

	.text
main:
	lui r1,a

	l.d f1,0(r1)
	l.d f2,8(r1)
	l.d f3,16(r1)
	l.d f4,24(r1)
	add.d f1,f2,f1
	l.d f2,32(r1)
	add.d f3,f4,f3
	l.d f4,40(r1)
	add.d f1,f2,f1
	l.d f2,48(r1)
	add.d f3,f4,f3
	l.d f4,56(r1)
	add.d f1,f2,f1
	l.d f2,64(r1)
	add.d f3,f4,f3
	l.d f4,72(r1)
	add.d f1,f2,f1
	l.d f2,80(r1)
	add.d f3,f4,f3
	l.d f4,88(r1)

	add.d f1,f2,f1
	add.d f3,f4,f3

	add.d f1,f3,f1

	s.d f1,96(r1)

	halt
