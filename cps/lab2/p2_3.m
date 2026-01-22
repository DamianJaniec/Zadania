% cps_01_sinus.m
clear all; close all;
fpr=1000; Nx=10*fpr;                % parametry: czestotliwosc probkowania, liczba probek
dt = 1/fpr;                         % okres probkowania
n = 0 : Nx-1;                       % numery probek
t = dt*n;                           % chwile probkowania
A1=1; f1=1; p1=0;                    % sinusoida: amplituda, czestotliwosc, faza
%x1 = A1*sin(2*pi*f1 *t+p1);         % pierwszy skladnik sygnalu
df=200;
%x1 = A1*sin(2*pi*f1*df*t.^2 + p1);
%x1=cos(2*pi*(0*t+0.5*df*t.^2));
x1=exp(j*2*pi*(0*t+0.5*df*t.^2));


kol = 'k-';

subplot(2,1,1);
plot(t,x1,kol); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');
subplot(2,1,2);
plot(t,x1,kol); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');
spectrogram(x1,256,256-64,512,fpr);

%sound(x1,fpr);
