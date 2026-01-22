%problem 1.3
clc;
clear all; 
close all;

Nx=10000;
s1=rand(1,Nx);  %s1 = 0.1*(2*(s1-0.5)); % rownomierny, skalowanie do [-0.1,0.1]
s2=randn(1,Nx); %s2 = 0.1*s2; % gaussowski, skalowanie do std=0.1


subplot(221); plot(s1,'.-'); grid; title('Szum rownomierny [0,1]');
subplot(222); plot(s2,'.-'); grid; title('Szum gaussowski');
subplot(223); hist(s1,20); title('Histogram szumu rownomiernego');
subplot(224); hist(s2,20); title('Histogram szumu gaussowskiego');

pause();

%zaobserwowane kształty wykresów
%Równomierny: Wykres wygląda jakby był jednolicie wypełniony
%Gausowski: Wykres wygląda jakby punkty koncentrowały się w około prostej

%zaobserwowane kształy histogramów
%Równomierny: Wszystkie słupki są podobnej wysokości
%Gausowski: Najwyższe słupki są w okolicach średniej, im dalej od niej tym
%są niższe (kształt dzwonu)

%Równomierny Min: x=4595 y=0.000123064
%Równomierny Max: x=147 y=0.999973

%Gaussowski Max: x=547 y=3.8924
%Gaussowski Min: x=7175 y=-3.96868

%Po przeskalowaniu:
%Kształt wykresów nie zmienił się znacząco, można zobaczyć podobne wzory co
%wcześniej, zmieniły się jednak wartości na wykresie

%Problem 1.1 + Szum
fpr=1000; Nx=1000;
dt = 1/fpr; n = 0 : Nx-1; t = dt*n;
A1=0.5; f1=10; p1=pi/4;
x = A1*sin(2*pi*f1 *t+p1);

szum_gaussowski  = randn(1,Nx); 
szum_rownomierny = rand(1,Nx);

std_maly   = 0.01;
std_sredni = 0.2;  
std_duzy   = 2.0;

x_maly   = x + std_maly   * szum_gaussowski;
x_sredni = x + std_sredni * szum_gaussowski;
x_duzy   = x + std_duzy   * szum_gaussowski;


x_maly   = x + std_maly   * szum_rownomierny;
x_sredni = x + std_sredni * szum_rownomierny;
x_duzy   = x + std_duzy   * szum_rownomierny;


figure(2);
subplot(4,1,1); plot(t, x); grid on; title('Sinusoida Czysta (A=0.5)');
subplot(4,1,2); plot(t, x_maly); grid on; title('Sinusoida + Szum Mały ');
subplot(4,1,3); plot(t, x_sredni); grid on; title('Sinusoida + Szum Średni');
subplot(4,1,4); plot(t, x_duzy); grid on; title('Sinusoida + Szum Duży');
xlabel('Czas [s]'); ylabel('Amplituda');

pause();

figure(3);
subplot(1,2,1);
hist(x, 20);
title('Histogram czysty sinus');
xlabel('Amplituda'); ylabel('Liczba Próbek');


subplot(1,2,2);
hist(x_duzy, 20);
title('Histogram Sinus + Duży Szum');
xlabel('Amplituda'); ylabel('Liczba Próbek');
pause();

%Dla czystej sinusoidy najwięcej próbek gromadzi się na skrajach
%bo tam sygnał "zmienia" się najwolniej

%Dla sin z szumem: kształt histogramu jest zbliżony do rozkładu gaussa
%ponieważ szum zasłania już prawie całkowicie orginalny sygnał (średnia
%bliska 0)