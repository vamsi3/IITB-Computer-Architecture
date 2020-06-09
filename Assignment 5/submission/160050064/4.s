		.data
v1:		.double 4.5
v2:		.double 5.6

		.text
main:	l.d f1,v1(r0)
		l.d f2,v2(r0)
		div.d f3,f1,f2
		div.d f4,f1,f2 
		
		halt
