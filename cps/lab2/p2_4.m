clear all; close all;
fpr = 8000;         % Częstotliwość próbkowania (Hz)
Nx = 3 * fpr;       % Czas trwania 3 sekundy
dt = 1/fpr;         % Okres próbkowania
t = dt * (0:Nx-1);  % Chwile próbkowania                   % chwilepobieraniaprobek

fA = 0.5;
kA = 0.25;
f0 = 5;
fF = 2;
kF = 5;
A = 1;

mA_t = sin(2*pi*fA*t); % Sygnal modulujacy AM
mF_t = sin(2*pi*fF*t); % Sygnal modulujacy FM

A_x_t = A*(1+ kA *mA_t); % A_x(t) z tabeli 2.2
Phi_x_t = (2*pi*kF * cumsum(mF_t) * dt); % phi_x(t) x7

katAlfa_t = 2*pi*f0*t + Phi_x_t;

x = A_x_t.*sin(katAlfa_t);

%sygnał wynikowy


kol = "-k";

figure(1)
plot(t,x,kol); grid; title('Sygnal x(t)'); xlabel('czas [s]'); ylabel('Amplituda');


% Z powodzeniem zaimplementowano sygnał AM-FM, poprawnie rozdzielając stałą częstotliwość nośną od zmiennej fazy modulującej.
% Sygnał wykazuje sinusoidalną zmianę amplitudy z f=0.5 Hz oraz sinusoidalną zmianę częstotliwości od 0 Hz do 10 Hz.


