
%cps03_trans.m
clear all; close all; clc;

%Orthogonalmatrix for DCT-IV orthogonaltransform
N =100;% wymiarmacierzykwadratowej, 25, 100
k =(0:N-1); n=(0:N-1);% k-kolumny/funkcje, n-wiersze/probki
A = sqrt(1/N) * exp(-1j * 2*pi/N * (k.' * n));   % analiza DFT
S = A';

for i = 1:99
    v1 = A(i,:);      
    v2 = A(i+1,:);    

    prod1 = sum(v1 .* conj(v2));
    prod2 = dot(v1, v2);
    prod3 = v1 * v2';

    %fprintf("i=%d   sum=%f   dot=%f   v1v2'=%f\n", i, prod1, prod2, prod3);
end

M0 = eye(100);
M1 = S*A;
M2 = A'*A;

if ((max(max(abs(M0 - M1))) < 1e-12) && (max(max(abs(M0 - M2))) < 1e-12))
    fprintf("macierz jest ortonormalna\n");
else
    fprintf("macierz nie jest ortonormalna\n");
end

for i = 1:10
    % -------- część rzeczywista ----------
    subplot(10,2,2*i - 1);
    plot(real(A(i,:)),'b');
    grid on;
    title(['Re(A(', num2str(i), '))']);
    
    % -------- część urojona ----------
    subplot(10,2,2*i);
    plot(imag(A(i,:)),'r');
    grid on;
    title(['Im(A(', num2str(i), '))']);
end

%Nast˛epnie porównaj cz˛e´ sci rzeczywiste i urojone nast˛epuj ˛acych par
 %wierszy macierzy: 2-iego oraz N-tego, 3-ciego oraz N-1-szego, 4 oraz N-2-iego,... Jaki wniosek mo˙ zna wyci ˛agn ˛a´c z
 %tego porównania? Cz˛e´ sci rzeczywiste wierszy s ˛aidentyczne, a urojone- zanegowane?
figure(2)
for i=1:5
    subplot(10,2,4*i - 1);
    plot(real(A(i+1,:)),'b');
    grid on;
    title(['Re(A(', num2str(i+1), '))']);
    
    % -------- część urojona ----------
    subplot(10,2,4*i);
    plot(imag(A(i+1,:)),'r');
    grid on;
    title(['Im(A(', num2str(i+1), '))']);
end

for i=1:5
    subplot(10,2,4*i-3);
    plot(real(A(N-i+1,:)),'b');
    grid on;
    title(['Re(A(', num2str(N-i+1), '))']);
    
    % -------- część urojona ----------
    subplot(10,2,4*i-2);
    plot(imag(A(N-i+1,:)),'r');
    grid on;
    title(['Im(A(', num2str(N-i+1), '))']);
end

% Nast˛epnie porównaj cz˛e´ sci rzeczywiste i urojone nast˛epuj ˛acych par
% wierszy macierzy: 2-iego oraz N-tego, 3-ciego oraz N-1-szego, 4 oraz N-2-iego,... Jaki wniosek mo˙ zna wyci ˛agn ˛a´c z
% tego porównania? Cz˛e´ sci rzeczywiste wierszy s ˛aidentyczne, a urojone- zanegowane?

%faktycznie, część rzeczywista, jest zachowana, odpowiadającym ich wierszom
%  100 -> 2
%  99  -> 3
%  98  -> 4
% itd.
%natomiast część urojnona również prawie niczym się nie różni, poza
%przesunięciem w fazie



%Czy mógłby´ s udowodni´c swoje
%spostrze˙ zenie matematycznie? Je´ sli tak, to otrzymasz dodatkowy punkt!

%nie, matematycznie nie umiem