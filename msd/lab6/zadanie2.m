%Zadanie 2

%y''' + 2y'' + 2y' + y = 2u(t) + u'

%x'_3 = -2x_3 -2x_2 - x_1 + 2u(t) + u'(t)

A = [0  1  0 0
     0  0  1 0
    -1 -2 -2 2
     0  0  0 0
    ];
B = [0
     0
     1
     1];

C = [1 0 0 0];
D = 0;

%transmitacja 
% G(s) = C(sI-A)^-1 * B + D
syms s

sI_A = s*eye(4) - A;
inv_sI_A = inv(sI_A);

G = C * inv_sI_A * B + D

%x4=u %x4'=u'