clear; clc;

N = 100;
n = 0:N-1;

fs=1000;
dt = 1/fs;
T=N*dt;
f0 = 1/T;
t = dt*(0:N-1);

x5 = 1*cos(2*pi*1*(10*f0)*n*dt);
x6 = 1*sin(2*pi*1*(10*f0)*n*dt);

%x5 = 1*cos(2*pi*1*(10.5*f0)*n*dt);
%x6 = 1*sin(2*pi*1*(10.5*f0)*n*dt);

k = 0:N-1;
fk = f0*(0:N-1);  % oś częstotliwości
A_dft = exp(-1j*2*pi/N*(k.'*n));  % macierz DFT bez sqrt(1/N)

c = A_dft * x5.'; % DFT sygnału x5 - to jest nasze "c"
c_sin = A_dft * x6.';

cs = 1/N * c; %wspołczynnik macierzy DFT
cs_sin = 1/N * c_sin;

display(cs);
display(cs_sin);

figure; subplot(211); stem(fk,real(cs)); subplot(212); stem(fk,imag(cs));
figure; subplot(211); stem(fk,abs(cs)); subplot(212); stem(fk,angle(cs));

% WNIOSKI:
% Skalowanie sqrt(1/N) pozwala odczytać rzeczywiste amplitudy harmonicznych z DFT
% Część rzeczywista zawiera informacje o składowych kosinusowych (parzystych)


figure; subplot(211); stem(fk,real(cs_sin)); subplot(212); stem(fk,imag(cs_sin));
figure; subplot(211); stem(fk,abs(cs_sin)); subplot(212); stem(fk,angle(cs_sin));

%WNIOSKI:
% Figure 1 oraz 3, możemy zauważyć że są "symetrczne", jak wiemy z
% poprzedniego zadania, cos odpowiada części rzeczywistej, a sinus urojonej
%dlatego w pierwszym sygnale piki widać w Imz a w Rez są wartości bliskie
%zera, w drugim sygnale za to na odwrót
%
%w figure 2 i 4, pierwszy wykres powinien wyjść dokładnie taki sam,
%ponieważ nie zmieniliśmy parametrów
% stem(abs(cs)) oblicza moduł, czyli (sqrt(real(cs)^2 + imag(cs)^2) oznacza
% to tyle że wynik powinien być identyczny nie zależnie czy funkcja to
% sinus czy cosinus
%
%stem(angle(cs)) pokazuje nam kąt fazowy w radianach, który mówi nam o ile
%przesunięty jest sygnał względem cosinusa
%dlatego, w przypadku figure 2, w pikach (czyli x={20,980}), warości te są
%bliskie zeru
%dla sinusa, watości w pikach z kolei wynoszą +/- ~1.57, dzieje się tak dlatego
%że sinus jest zwyczajnie przesunięty względem cosinua o 1/2 pi

%Dlaczego wartości bezwzględne (moduł liczb zespolonych) współczyników
%widomowych cs są dwa razy mniejsze niż spodziewane, biorąc pod uwagę
%amplitudę analizowanego sygnału
%spodziewamy się wysokości piku równego 1.0 (lub około 1.0 w przypadku gdy
%zmieniemy częstotliwość sygnału) ale dostajemy dwa razy mniejszy (0.5),
%dzieje się tak dla tego że energia rozlewa się widmie na dwa piki
%cosinus to suma dwóch eksponentów zespolonych 
%cos(omega*t) = 1/2 * e ^ (j*omega*t) + 1/2 * e ^ (-j*omega*t)
%i do każdej trafia połowa amplitudy, z sinusem jest podobnie, tylko jedna
%z eksponent jest po prostu na minusie