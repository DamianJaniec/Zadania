% cps_01_sinus.m
%problem 1.1
clc;
clear all; 
close all;
fpr=1000; 
Nx=1000; % parametry: czestotliwosc probkowania, liczba probek
dt = 1/fpr; % okres probkowania
n = 0 : Nx-1; % numery probek
t = dt*n; % chwile probkowania



A1=0.5; f1=10; p1=pi/4; % sinusoida: amplituda, czestotliwosc, faza
x = A1*sin(2*pi*f1 *t+p1); % pierwszy skladnik sygnalu

A1 = 1.5; %zmieniamy pierwszy parametr
x1 = A1*sin(2*pi*f1 *t+p1);

f1 = 3; %zmieniamy drugi
x2 = A1*sin(2*pi*f1 *t+p1);


p1 = 5/2*pi; %zmieniamy trzeic
x3 = A1*sin(2*pi*f1 *t+p1);


figure(1)
subplot(2,2,1)
plot(t,x,'o-'); %przed zmiana
hold on;
plot(t,x1,'o-'); %po zmianie
grid; 
title('Sinus po zmianie Amplitudy'); 
xlabel('Czas [s]'); 
ylabel('Amplituda');
pause();

subplot(2,2,2)
plot(t,x1,'o-'); %przed zmiana
hold on;
plot(t,x2,'o-'); %po zmianie
grid; 
title('Sinus po zmianie Czestotliwosci'); 
xlabel('Czas [s]'); 
ylabel('Amplituda');
pause();

subplot(2,2,3)
plot(t,x2,'o-'); %przed zmiana
hold on;
plot(t,x3,'o-'); %po zmianie
grid; 
title('Sinus po zmianie przesuniecia fazowego'); 
xlabel('Czas [s]'); 
ylabel('Amplituda');
pause();

%A1=0.5; f1=10; p1=pi/4; % sinusoida: amplituda, czestotliwosc, faza
%x = A1*sin(2*pi*f1 *t+p1); % pierwszy skladnik sygnalu

fpr=8000;
Nx=3*fpr;
dt = 1/fpr; % okres probkowania
n = 0 : Nx-1; % numery probek
t = dt*n; % chwile probkowania


A2 = [0.8 1.2 1.6];
f2 = [101 111 110];
p2 = [pi/2 pi pi*3/2];

fpr=8000; Nx=3*fpr; 
dt = 1/fpr; 
n = 0 : Nx-1; 
t = dt*n; 


x1 = A2(1)*sin(2*pi*f2(1) *t+p2(1)); 
x2 = A2(2)*sin(2*pi*f2(2) *t+p2(2)); 
x3 = A2(3)*sin(2*pi*f2(3) *t+p2(3)); 

x = (x1 + x2 + x3);

subplot(2,2,4);
plot(t,x,'o-'); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Połączenie 3 różnych sin');
pause();

sound(x,fpr);
%odsluchalem