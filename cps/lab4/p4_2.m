clear; clc;

N = 100;
n = 0:N-1;

% macierz DFT
k = 0:N-1;
A = sqrt(1/N) * exp(-1j*2*pi/N*(k.'*n));
S = A';

x1 = 10 * S(:, 5).';
x2 = 20 * S(:, 10).';

% DFT sygnałów
X1 = A * x1.';
X2 = A * x2.';


figure(1)
subplot(3,2,1);
stem(abs(X1));
title("x1: moduł DFT");


subplot(3,2,3);
stem(real(X1));
title("x1: część rzeczywista DFT");


subplot(3,2,5);
stem(imag(X1));
title("x1: część urojona DFT");


subplot(3,2,2);
stem(abs(X2));
title("x2: moduł DFT");


subplot(3,2,4);
stem(real(X2));
title("x2: część rzeczywista DFT");


subplot(3,2,6);
stem(imag(X2));
title("x2: część urojona DFT");


fprintf("Amplituda X1: %f, Amplituda X2: %f \n", max(abs(X1)), max(abs(X2)));

x_real = real(x1);  % część rzeczywista - cosinus
x_imag = imag(x1);  % część urojona - sinus

X_real = A * x_real.';
X_imag = A * x_imag.';

figure(2)
subplot(2,2,1);
stem(abs(X_real));
title("real(x1): moduł DFT (cosinus)");
xlabel('k'); ylabel('|X|');

subplot(2,2,2);
stem(real(X_real));
title("real(x1): część rzeczywista DFT");
xlabel('k'); ylabel('Re(X)');

subplot(2,2,3);
stem(abs(X_imag));
title("imag(x1): moduł DFT (sinus)");
xlabel('k'); ylabel('|X|');

subplot(2,2,4);
stem(imag(X_imag));
title("imag(x1): część urojona DFT");
xlabel('k'); ylabel('Im(X)');

% ========== SUMA SYGNAŁÓW ==========
x_suma = x1 + x2;
X_suma = A * x_suma.';

figure(3)
subplot(3,1,1);
stem(abs(X_suma));
title("x1 + x2: moduł DFT");
xlabel('k (częstotliwość)'); ylabel('|X[k]|');

subplot(3,1,2);
stem(real(X_suma));
title("x1 + x2: część rzeczywista DFT");
xlabel('k'); ylabel('Re(X[k])');

subplot(3,1,3);
stem(imag(X_suma));
title("x1 + x2: część urojona DFT");
xlabel('k'); ylabel('Im(X[k])');

max_modul_suma = max(abs(X_suma));
fprintf("Maksymalny moduł dla sumy (x1+x2): %f\n", max_modul_suma);
%Zaobserwuj jaki kształt
%ma wektor stem(c), be˛da˛cy wynikiem transformacji.
%Czy jego wartos´ci informuja˛ nas o wartos´ciach amplitud
%i cz˛estotliwo´sci sygnałów składowych (harmonicznych) analizowanego sygnalu x?

%{
    W przypadku cosinusa, można odczytać amplitudę (5) oraz częstotliwość
    (numer naszej kolumny z macierzy A - każdy numer odpowiada
    częstotliwości) - odczytujemy to z części rzeczywistej - ten szum na
    wykresie części urojonej, to po prostu błąd obliczeniowy - wartości są
    bliskie zeru 10^(-14) w tym przypadku najlepiej przyjąć że są równe 0

    w sinusie sytuacja jest podobna ale odwrotna, w części reczywistej
    występują zera, ale już z części urojonej można odczytać amplitudę i
    częstotliwość

    część rzeczywista zawiera informacje o składowej harmonicznej która
    jest parzysta, część urojona zawiera te same inforamcje ale składowej
    która jest nie parzysta - czyli dla cos będziemy sprawdzać Rez a dla
    sin będziemy sprawdzać Imz

    w naszym przypadku mamy czyste funkcję

    moduł to sqrt( Rez^2 + Imz^2) czyli sqrt(25) = 5

    nasze funkcję są mają bazowo amplitudę 1 ale mnożymy ją przez
    sqrt(1/N) czyli 0.1 a wiedząc że bazowa amplituda DFT wynosi 50
    wychodzi nam 5 - to jest amplituda jednego piku

    a funkcję mają po dwa piki, sumując wychodzi 10
    

%}

%Czy nie
%ma to zwia˛zku z równos´cia˛: cos(α) = 0.5ejα +0.5e−jα?

%{
    tak, energia sygnału rozchodzi się na dwa piki, które trzeba zsumować
    aby otrzymać naszą amplitudę
%}

%A jak jest dla funkcji sinus?

%{
    moduł jest bezwzględny, piki również, więc po prostu pomijamy znaki i
    sumujemy
%}

%Wnioski z rusunku? Na koniec oblicz DFT dla sumy sygnałów x=x1+x2;.

%{

    Z rysunków jasno widać że części składowe, się dodały, wyglądają
    podbnie ponieważ

    Rez + 0 = to dalej ten sam Rez
    Imz + 0 = to dalej ten sam Imz

    moduł to
    Sqrt(Rez^2 + Imz^2) = sqrt(25 + 25) = sqrt(50) = 5*sqrt(2) ~ 7.07 

%}