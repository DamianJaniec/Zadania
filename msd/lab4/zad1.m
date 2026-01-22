clc; clear all;

m1 = 90;
m2 = 600;
k1 = 370000;
k2 = 35000;
c1 = 100;
c2 = 2000;

A = [0            0        1            0; 
     0            0        0            1;
    -(k1+k2)/m1   k2/m1   -(c1+c2)/m1   c2/m1;
      k2/m2      -k2/m2     c2/m2      -c2/m2;];


B = [c1/m1;
     0;
     k1/m1 - (c1+c2)*c1/m1^2;
     c1*c2/(m1*m2) ];

C = [1 0 0 0];
D = 0;

sys = ss(A,B,C,D);
G = tf(sys);

display(G);