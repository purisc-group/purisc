PROGRAM_MEM:
//%c = add i32 %a, 2       
c c NEXT
t1 t1 NEXT
%a t1 NEXT
0 t1 NEXT
t1 c NEXT
//%d = sub i32 %a, %c       
d d NEXT
t1 t1 NEXT
%a t1 NEXT
%c d NEXT
t1 d NEXT
//%e = mul i32 %a, @b       
counter counter NEXT
adder adder NEXT
t1 t1 NEXT
t2 t2 NEXT
%a t1 apos
t1 adder NEXT
@b t2 bpos
bneg: t2 counter NEXT
t3 t3 continue
bpos: %a adder NEXT
t3 t3 continue
apos: %a adder NEXT
t1 t1 NEXT
@b t1 bpos
@b t2 NEXT
t3 t3 bneg
continue: one counter NEXT
tempC tempC NEXT
again: adder tempC NEXT
one counter again
e e NEXT
tempC e NEXT
//%f = icmp eq i32 %a, %a
f f NEXT
t0 t0 NEXT
%a t0 NEXT
t0 f NEXT
%a f possiblyEq
f f done
possiblyEq: t1 t1 NEXT
f t1 eq
f f done
eq: t1 f NEXT
done: t0 t0 NEXT
//%g = icmp ne i32 %c, @b
g g NEXT
t0 t0 NEXT
%c t0 NEXT
t0 g NEXT
@b g NEXT
//%h = icmp sgt i32 %d, %e
h h NEXT
t0 t0 NEXT
%d t0 NEXT
t0 h NEXT
%e h less
t1 t1 done
less: h h NEXT
done: t3 t3 NEXT


DATA_MEM:
a: #2
0: #2
c: #0
b: #15
e: #0
d: #0
g: #0
f: #0
h: #0
one: #1
negOne: #-1
