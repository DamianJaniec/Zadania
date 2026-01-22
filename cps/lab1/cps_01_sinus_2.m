%problem 1.2
clc;
clear all; 
close all;

fpr=8000;
Nx=3*fpr;
dt = 1/fpr;
n = 0 : Nx-1;
t = dt*n;


A2 = [1 1 1];
f2 = [1 fpr+1 2*fpr+1];
p2 = [0 0 0];



x1 = A2(1)*sin(2*pi*f2(1) *t+p2(1)); 
x2 = A2(2)*sin(2*pi*f2(2) *t+p2(2)); 
x3 = A2(3)*sin(2*pi*f2(3) *t+p2(3)); 

subplot(2,2,1)

plot(t,x1);
hold on;
plot(t,x2);
hold on;
plot(t,x3);
title("f1=1; f2=fpr+f1; f3=2*fpr+f1");
pause();

%sygnały są nie rozróżnialne
%dlatego "nachodzą" na siebie
%i wyglądają jak jeden sygnał

%sygnał x1 ma częstotliwość 1 Hz
%sygnał x2 ma częstotliwość 8001 hz
%sygnał x3 ma częstotliwość 16001 Hz

%częstotliwość próbkowania to 8000 Hz

%sygnały są nie rozróżnialne na wykresie
%wynika to ze wzoru (którego ciężko przepisać do postaci tekstowej)
%z tego wzoru wynika że jedyne co się zmienia to wielkrotność 
%częstotliwości próbkowania

%częstotliwość x = k * fpr + fx
%               x1 : k=0; fpr=8kHz fx=1
%               x2 : k=1; fpr=8kHz fx=1
%               x3 : k=2; fpr=8kHz fx=1

A2 = [1 1 1];
f2 = [1 fpr-1 2*fpr-1];
p2 = [0 0 0];



x1 = A2(1)*sin(2*pi*f2(1) *t+p2(1)); 
x2 = A2(2)*sin(2*pi*f2(2) *t+p2(2)); 
x3 = A2(3)*sin(2*pi*f2(3) *t+p2(3)); 

subplot(2,2,2)

plot(t,x1);
hold on;
plot(t,x2);
hold on;
plot(t,x3);
title("f1=1; f2=fpr-f1; f3=2*fpr-f1");
pause();

%w tym przypadku możemy już rozróżnić sygnały
%na wykresie "widzimy" dwa sygnały
%ponieważ sygnał x2 oraz x3 są nie rozróżnialne

%x2 = 7999Hz
%x3 = 15999Hz

%częstotliwość x = k * fpr + fx
%               x2 : k=1; fpr=8kHz fx=-1
%               x3 : k=2; fpr=8kHz fx=-1

%z koleji x1
%               x1 : k=0; fpr=8kHz fx=1

A2 = [1 1 1];
f2 = [5 fpr-5 2*fpr-5];
p2 = [0 0 0];



x1 = A2(1)*sin(2*pi*f2(1) *t+p2(1)); 
x2 = A2(2)*sin(2*pi*f2(2) *t+p2(2)); 
x3 = A2(3)*sin(2*pi*f2(3) *t+p2(3)); 

subplot(2,2,3)

plot(t,x1);
hold on;
plot(t,x2);
hold on;
plot(t,x3);
title("f1=5; f2=fpr-f1; f3=2*fpr-f1");
pause();
%w sytuacja jest ta sama co w poprzednim przykładzie
%zmieniła się tylko częstotliwość sygnału

A2 = [1 1 1];
f2 = [5 fpr-5 2*fpr-5];
p2 = [0 0 0];



x1 = A2(1)*cos(2*pi*f2(1) *t+p2(1)); 
x2 = A2(2)*cos(2*pi*f2(2) *t+p2(2)); 
x3 = A2(3)*cos(2*pi*f2(3) *t+p2(3)); 

subplot(2,2,4)

plot(t,x1);
hold on;
plot(t,x2);
hold on;
plot(t,x3);

title("f1=5; f2=fpr-f1; f3=2*fpr-f1 oraz cos");
pause();
%wszystkie 3 wykresy pokrywają się idealnie
%wynika to z tego że cosinus jest funkcją parzystą
%tzn. cos(x) = cos(-x)
%gdyby naszę parametry z tych
%f2 = [5 fpr-5 2*fpr-5];
%zamienić na
%f2 = [5 fpr+5 2*fpr+5];
%wykres będzie wyglądać dokładnie tak samo

%wniosek: %sygnały są nie rozróżnialne


A2 = [1 1 1];
f2 = [200 fpr+200 2*fpr+200];
p2 = [0 0 0];



x1 = A2(1)*sin(2*pi*f2(1) *t+p2(1)); 
x2 = A2(2)*sin(2*pi*f2(2) *t+p2(2)); 
x3 = A2(3)*sin(2*pi*f2(3) *t+p2(3)); 


%sound(x1,fpr);
%pause();
%sound(x2,fpr);
%pause();
%sound(x3,fpr);
%odsluchalem
%pause();

figure(3);
subplot(2,2,1);
pspectrum(x1,fpr);
pause();
subplot(2,2,2);
pspectrum(x2,fpr);
pause();
subplot(2,2,3);
pspectrum(x3,fpr);
pause();
subplot(2,2,4);
pspectrum(x1,fpr);
hold on;
pspectrum(x2,fpr);
hold on;
pspectrum(x3,fpr);
title("Wszystkie x1,x2,x3 na jednym wykresie");

%wykresy są takie same ponieważ 
%są to sygnały nie rozróżnialne
%a ten fres~14Hz to nie wiem co to