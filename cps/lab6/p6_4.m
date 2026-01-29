clear all; close all; clc;
%% dane
fpr = 8000;
T = 1;
N = round(T * fpr);
dt = 1/fpr;
t = dt * (0:N-1);
f0 = 200;

%% figure z czystym sygnałem, szumem i połączeniem
figure;
subplot(3,1,1);
plot(t(1:500), sin(2*pi*f0*t(1:500)));
title('czysty sinus 200 hz');
xlabel('t [s]');
grid on;

subplot(3,1,2);
plot(t(1:500), randn(1,500));
title('sam szum gaussowski');
xlabel('t [s]');
grid on;

subplot(3,1,3);
plot(t(1:500), sin(2*pi*f0*t(1:500)) + randn(1,500));
title('sinus + szum');
xlabel('t [s]');
grid on;

%% różne poziomy szumu
sigma_values = [0.5, 1, 2, 5, 10, 20];

%% figure z widmami
figure;
for i = 1:length(sigma_values)
    sigma = sigma_values(i);
    x = sin(2*pi*f0*t) + sigma*randn(1,N);
    
    X = fft(x);
    f = fpr/N * (0:N-1);
    Pxx = (abs(X)/N).^2;
    
    subplot(length(sigma_values), 1, i);
    plot(f(1:N/2), Pxx(1:N/2));
    title(['widmo mocy, sigma = ' num2str(sigma)]);
    xlabel('f [Hz]'); ylabel('V^2');
    grid on;
end

% pierwsza figura pokazuje czysty sinus i sam szum osobno
% druga figura pokazuje jak pik sinusa znika w widmie przy rosnącym szumie

%% uśrednianie widm - metoda welcha
sigma = 20;
T_long = 300;
N_long = round(T_long * fpr);
t_long = dt * (0:N_long-1);

x_long = sin(2*pi*f0*t_long) + sigma*randn(1,N_long);

% parametry podziału na fragmenty
Mwind = 1024;
Mfft = Mwind;
Many = floor(N_long / Mwind);

% uśrednianie widm
Pxx_avg = zeros(1, Mfft);
for m = 1 : Many
    fragment = x_long(1 + (m-1)*Mwind : m*Mwind);
    X = fft(fragment);
    Pxx_avg = Pxx_avg + (abs(X)/Mwind).^2;   % normalizacja przez Mwind
end
Pxx_avg = Pxx_avg / Many;

f_avg = fpr/Mfft * (0:Mfft-1);

% porównanie
figure;
subplot(2,1,1);
X_all = fft(x_long);
Pxx_all = (abs(X_all)/N_long).^2;
f_all = fpr/N_long * (0:N_long-1);
plot(f_all(1:N_long/2), Pxx_all(1:N_long/2));
title('jedno fft całego sygnału');
xlabel('f [Hz]'); ylabel('V^2');
grid on;

subplot(2,1,2);
plot(f_avg(1:Mfft/2), Pxx_avg(1:Mfft/2));
title(['uśrednione widmo z ' num2str(Many) ' fragmentów']);
xlabel('f [Hz]'); ylabel('V^2');
grid on;

% uśrednianie wielu widm wygładza szum do stałego poziomu
% pik sinusa nie znika przy uśrednianiu bo jest w tym samym miejscu w każdym fragmencie
% szum jest losowy więc się uśrednia do zera, a sinus zostaje widoczny

%% Wyznacz ile widm nalez˙y u´sredni´c, aby maksimum sinusa było dobrze 
% widoczne w u´srednionym widmie.

%% ile fragmentów potrzeba żeby pik był widoczny
sigma = 20;
T_long = 300;
N_long = round(T_long * fpr);
t_long = dt * (0:N_long-1);
x_long = sin(2*pi*f0*t_long) + sigma*randn(1,N_long);

Mwind = 1024;
Mfft = Mwind;
f_avg = fpr/Mfft * (0:Mfft-1);

Many_values = [10, 50, 100, 500, 1000, 2000];

figure;
for i = 1:length(Many_values)
    Many = Many_values(i);
    
    Pxx_avg = zeros(1, Mfft);
    for m = 1 : Many
        fragment = x_long(1 + (m-1)*Mwind : m*Mwind);
        X = fft(fragment);
        Pxx_avg = Pxx_avg + (abs(X)/Mwind).^2;
    end
    Pxx_avg = Pxx_avg / Many;
    
    subplot(length(Many_values), 1, i);
    plot(f_avg(1:Mfft/2), Pxx_avg(1:Mfft/2));
    title(['uśrednionych fragmentów: ' num2str(Many)]);
    xlabel('f [Hz]'); ylabel('V^2');
    grid on;
end

% przy małej liczbie fragmentów szum jest duży i pik sinusa niewidoczny
% im więcej fragmentów tym szum się bardziej wygładza i pik staje się widoczny
% dla sigma=20 potrzeba około 100-500 fragmentów żeby pik był wyraźny