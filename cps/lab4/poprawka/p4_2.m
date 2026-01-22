clear; clc;

N = 100;
n = 0:N-1;
k = 0:N-1;

A = sqrt(1/N) * exp(-1j * 2*pi/N * (k.' * n)); % macierz syntezy
S = A';

x1 = 10*S(:,5); % sygnal #1
x2 = 20*S(:,10); % sygnal #2

%% Analiza Sygnału x1

x = x1;
c = A*x;

figure(1);
stem(c);
title("widmo sygnału x1");

%"Czy jego wartos´ci informuja˛ nas o wartos´ciach amplitud
%i cz˛estotliwo´sci sygnałów składowych (harmonicznych) analizowanego 
%sygnalu x?"

%tak - pozycja piku = częstotliwość, wysokość piku = amplituda

pause();

x = real(x1);
c = A*x;

figure(1);
subplot(4,1,1);
stem(real(c));
title('x=real(x1): Rez(c)');
subplot(4,1,2);
stem(imag(c));
title('x=real(x1): Imz(c)');
%tutaj wzieliśmy część rzeczywistą z sygnału
%zrobiliśmy widmo
%i teraz wyświetlamy Rez i Imz z widma

fprintf('Moduł w piku (k=4): %.2f\n', abs(c(5)));  % indeks 5 = k=4
fprintf('Moduł w piku (k=96): %.2f\n', abs(c(97))); % indeks 97 = k=96
fprintf('Suma obu pików: %.2f\n', abs(c(5)) + abs(c(97)));

x = imag(x1);
c = A*x;

subplot(4,1,3);
stem(real(c));
title('x=imag(x1): Rez(c)');
subplot(4,1,4);
stem(imag(c));
title('x=imag(x1): Imz(c)');
%tutaj wzieliśmy część urojoną z sygnału
%zrobiliśmy widmo
%i teraz wyświetlamy Rez i Imz z widma

fprintf('Moduł w piku (k=4): %.2f\n', abs(c(5)));  % indeks 5 = k=4
fprintf('Moduł w piku (k=96): %.2f\n', abs(c(97))); % indeks 97 = k=96
fprintf('Suma obu pików: %.2f\n', abs(c(5)) + abs(c(97)));

pause();

%Dlaczego widmo DFT sygnału jest symetryczne w cz˛e´sci rzeczywistej dla sygnału x=real(x1)
%oraz asymetryczne w cze˛s´ci urojonej dla sygnału x=imag(x1)?

% Cosinus (k=4) daje 2 piki symetrycznie (k=4 i k=96) bo cos→suma eksponent, sinus daje 2 piki asymetrycznie (przeciwne znaki) bo sin→różnica eksponent

%Dlaczego moduły współczynników transformaty sa˛
%w obu przypadkach dwa razy mniejsze ni˙z amplituda analizowanych sygnałów o kształcie kosinusa/sinusa?

% Każdy pik ma połowę amplitudy bo cos=0.5e^jω+0.5e^-jω (wzór Eulera), suma obu pików (k=4 i k=96) daje pełną amplitudę 10

%% Analiza Sygnału x2

x = x2;
c = A*x;

figure(2);
stem(c);
title("widmo sygnału x2");

pause();

x = real(x2);
c = A*x;

figure(2);
subplot(4,1,1);
stem(real(c));
title('x=real(x2): Rez(c)');
subplot(4,1,2);
stem(imag(c));
title('x=real(x2): Imz(c)');

fprintf('Moduł w piku (k=9): %.2f\n', abs(c(10)));  % indeks 5 = k=4
fprintf('Moduł w piku (k=91): %.2f\n', abs(c(91))); % indeks 97 = k=96
fprintf('Suma obu pików: %.2f\n', abs(c(10)) + abs(c(91)));

x = imag(x2);
c = A*x;

subplot(4,1,3);
stem(real(c));
title('x=imag(x2): Rez(c)');
subplot(4,1,4);
stem(imag(c));
title('x=imag(x2): Imz(c)');

fprintf('Moduł w piku (k=9): %.2f\n', abs(c(10)));  % indeks 5 = k=4
fprintf('Moduł w piku (k=91): %.2f\n', abs(c(91))); % indeks 97 = k=96
fprintf('Suma obu pików: %.2f\n', abs(c(10)) + abs(c(91)));

pause();

%Wnioski z rusunku?

% Wnioski: identyczna sytuacja jak dla x1, ale piki na k=9 i k=91, każdy pik ma amplitudę 10 (połowę z 20), symetria/asymetria taka sama

%% Analiza sumy x1 + x2
x = x1 + x2;
c = A*x;
figure(3);
stem(c);
title("widmo sygnału x1+x2");

x = real(x1 + x2);
c = A*x;
figure(3);
subplot(4,1,1);
stem(real(c));
title('x=real(x1+x2): Rez(c)');
subplot(4,1,2);
stem(imag(c));
title('x=real(x1+x2): Imz(c)');
fprintf('Moduł w piku (k=4): %.2f\n', abs(c(5)));
fprintf('Moduł w piku (k=9): %.2f\n', abs(c(10)));
fprintf('Moduł w piku (k=91): %.2f\n', abs(c(92)));
fprintf('Moduł w piku (k=96): %.2f\n', abs(c(97)));

x = imag(x1 + x2);
c = A*x;
subplot(4,1,3);
stem(real(c));
title('x=imag(x1+x2): Rez(c)');
subplot(4,1,4);
stem(imag(c));
title('x=imag(x1+x2): Imz(c)');
fprintf('Moduł w piku (k=4): %.2f\n', abs(c(5)));
fprintf('Moduł w piku (k=9): %.2f\n', abs(c(10)));
fprintf('Moduł w piku (k=91): %.2f\n', abs(c(92)));
fprintf('Moduł w piku (k=96): %.2f\n', abs(c(97)));

% Wnioski: DFT sumy sygnałów to suma ich transformat - 
% widzimy niezależnie wszystkie 4 piki (k=4,9,91,96) 
% z zachowanymi amplitudami. Sygnały x1 i x2 nie mieszają się, 
% każdy zachowuje swoją częstotliwość i amplitudę.