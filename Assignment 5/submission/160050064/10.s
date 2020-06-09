      .data
v:    .double 5.6

      .text
main:
      l.d f1,v(r0)
      l.d f2,v(r0)
      l.d f3,v(r0)
      l.d f4,v(r0)
      l.d f5,v(r0)
      l.d f6,v(r0)
      l.d f7,v(r0)
      l.d f8,v(r0)
      l.d f9,v(r0)
      l.d f10,v(r0)
      l.d f11,v(r0)
      l.d f12,v(r0)

      add.d f14,f1,f2
      add.d f15,f3,f4
      add.d f16,f5,f6
      add.d f17,f7,f8
      add.d f18,f9,f10
      add.d f19,f11,f12

      add.d f20,f14,f15
      add.d f21,f16,f17
      add.d f22,f18,f19

      add.d f23,f20,f21
      add.d f13,f22,f23

      halt
