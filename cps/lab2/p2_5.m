clc;
clear all; 
close all;

fpr = 8000;         % Częstotliwość próbkowania (Hz)
Nx = 3 * fpr;       % Czas trwania 3 sekundy
dt = 1/fpr;         % Okres próbkowania
t = dt * (0:Nx-1);  % Chwile próbkowania
t_krotkie = dt*(0:50); %krotka chwila


f1 = 100;

x1= 1.0 * sin(2*pi*f1*t); %czysty sinsus

kol = "-k";

figure(1)
plot(t,x1,kol); grid; title('Sygnal x1(t)'); xlabel('czas [s]'); ylabel('Amplituda');
sound(x1,fpr);
pause(); %dzwiek zwykly sinus

%dwie nowe sinusoidy 
f2 = 400;
f3 = 1000;
x2 = 0.6 * sin(2*pi*f2*t);
x3 = 0.3 * sin(2*pi*f3*t);

figure(2);
sgtitle("Sygnały początkowe i wynik po sumowaniu");
subplot(4,1,1);
plot(t,x1,kol); grid; title('Sygnal x1(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,2);
plot(t,x2,kol); grid; title('Sygnal x2(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,3);
plot(t,x3,kol); grid; title('Sygnal x3(t)'); xlabel('czas [s]'); ylabel('Amplituda');

x= x1+x2+x3;

subplot(4,1,4);
plot(t,x,kol); grid; title('Sygnal x(t) = x1+x2+x3'); xlabel('czas [s]'); ylabel('Amplituda');

%"przyblizone wykresy" aby nie musiec korzystac z zacinajacej sie lupy

figure(3);
sgtitle("Sygnały początkowe i wynik po sumowaniu");
subplot(4,1,1);
plot(t_krotkie,x1(1:51),kol); grid; title('Sygnal x1(t) w krotkim okresie'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,2);
plot(t_krotkie,x2(1:51),kol); grid; title('Sygnal x2(t) w krotkim okresie'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,3);
plot(t_krotkie,x3(1:51),kol); grid; title('Sygnal x3(t) w krotkim okresie'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,4);
plot(t_krotkie,x(1:51),kol); grid; title('Sygnal x(t) w krotkim okresie'); xlabel('czas [s]'); ylabel('Amplituda');

sound(x,fpr); %dzwięk, wydaje się bardziej "poszarpany"
pause();

eksponenta_tlumiaca = exp(-1 * t);
gaussoida_tlumiaca = exp(-(t - 1.5).^2);

x1_ex = x1.*eksponenta_tlumiaca;
x2_ex = x2.*eksponenta_tlumiaca;
x3_ex = x3.*eksponenta_tlumiaca;
x_ex = x.*eksponenta_tlumiaca;

x1_ga = x1.*gaussoida_tlumiaca;
x2_ga = x2.*gaussoida_tlumiaca;
x3_ga = x3.*gaussoida_tlumiaca;
x_ga = x.*gaussoida_tlumiaca;

figure(4);
sgtitle("Tłumienie Eksponentą (Sygnały Zanikające w Czasie)");
subplot(4,1,1);
plot(t,x1_ex,kol); grid; title('Sygnal x1(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,2);
plot(t,x2_ex,kol); grid; title('Sygnal x2(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,3);
plot(t,x3_ex,kol); grid; title('Sygnal x3(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,4);
plot(t,x_ex,kol); grid; title('Sygnal x(t) = x1+x2+x3'); xlabel('czas [s]'); ylabel('Amplituda');

sound(x_ex,fpr); %dzwiek zanika w czasie, a jednoczesnie, dalej rezonuje
%przypomina troche jakby uderzenie w dzwon
pause();

figure(5);
sgtitle("Tłumienie Gaussoidą (Sygnały Narastające i Zanikające)");
subplot(4,1,1);
plot(t,x1_ga,kol); grid; title('Sygnal x1(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,2);
plot(t,x2_ga,kol); grid; title('Sygnal x2(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,3);
plot(t,x3_ga,kol); grid; title('Sygnal x3(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(4,1,4);
plot(t,x_ga,kol); grid; title('Sygnal x(t) = x1+x2+x3'); xlabel('czas [s]'); ylabel('Amplituda');

sound(x_ga,fpr); %dzwiek narasta, maleje, troche jak przejezdzajacy obok
%nas samochod

% Modyfikowanie amplitudy przez mnożenie nadaje dźwiękowi charakter dynamiczny
%tłumienie eksponentą powoduje rezonansowe zanikanie siły dźwięku (dzwon) a gaussoidą
%efekt narastania siły osiągnięcia szczytu i ponownego zanikania (przejazd)