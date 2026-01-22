%Zadanie 1

%y''' + 2y'' + y' + 4y = 3u(t)

%x'_3 = -2x_3 - x_2 - 4x_1 + 3u(t)

A = [0 1 0
    0 0 1
    -4 -1 -2
    ];
B = [0
     0
     3];

C = [1 0 0];
D = 0;

%transmitacja 
% G(s) = C(sI-A)^-1 * B + D
syms s

sI_A = s*eye(3) - A;
inv_sI_A = inv(sI_A);

G = C * inv_sI_A * B + D