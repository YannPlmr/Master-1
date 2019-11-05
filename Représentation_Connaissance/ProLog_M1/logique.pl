and(0,0,0).
and(1,0,0).
and(0,1,0).
and(1,1,1).

or(0,0,0).
or(1,0,1).
or(0,1,1).
or(1,1,1).

nand(0,0,1).
nand(1,0,1).
nand(0,1,1).
nand(1,1,0).

xor(0,0,0).
xor(1,0,1).
xor(0,1,1).
xor(1,1,0).

not(1,0).
not(0,1).

circuit(X,Y,Z):- nand(X,Y,A), not(X,C), xor(C, A, B), not(B,D), Z is D.
