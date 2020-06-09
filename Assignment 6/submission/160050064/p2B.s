	.data
a:	.double	0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,0

	.text
main:	lui r1,a
	lui r2,a
	daddi r2,r2,4000
loop:	l.d f1,0(r1)
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
	l.d f2,96(r1)
	add.d f3,f4,f3
	l.d f4,104(r1)
	add.d f1,f2,f1
	l.d f2,112(r1)
	add.d f3,f4,f3
	l.d f4,120(r1)
	add.d f1,f2,f1
	l.d f2,128(r1)
	add.d f3,f4,f3
	l.d f4,136(r1)
	add.d f1,f2,f1
	l.d f2,144(r1)
	add.d f3,f4,f3
	l.d f4,152(r1)
	add.d f1,f2,f1
	l.d f2,160(r1)
	add.d f3,f4,f3
	l.d f4,168(r1)
	add.d f1,f2,f1
	l.d f2,176(r1)
	add.d f3,f4,f3
	l.d f4,184(r1)
	add.d f1,f2,f1
	l.d f2,192(r1)
	add.d f3,f4,f3
	add.d f1,f2,f1
	add.d f1,f3,f1
	add.d f5,f5,f1
	daddi r1,r1,200
	bne r1,r2,loop
	s.d f5,3992(r1)
	halt
