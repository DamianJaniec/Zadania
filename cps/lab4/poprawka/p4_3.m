clear; clc;

%% Parametry sygnału
N = 100;
fs = 1000;          % częstotliwość próbkowania [Hz]
dt = 1/fs;          % okres próbkowania [s]
T = N*dt;           % czas trwania sygnału [s]
f0 = 1/T;           % podstawowa częstotliwość [Hz]
t = dt*(0:N-1);     % wektor czasu [s]

%% DEFINICJA SYGNAŁU TUTAJ ZMIENIAĆ
x5 = 1*cos(2*pi*(10*f0)*t);  % amplituda A=1, częstotliwość 10*f0
x6 = 1*sin(2*pi*(10*f0)*t);
x7 = 1*cos(2*pi*(10.5*f0)*t);
x8 = 1*sin(2*pi*(10.5*f0)*t);

x = x5;

fprintf('Parametry sygnału:\n');
fprintf('N = %d próbek\n', N);
fprintf('fs = %d Hz (częstotliwość próbkowania)\n', fs);
fprintf('dt = %.4f s (okres próbkowania)\n', dt);
fprintf('T = %.4f s (czas trwania)\n', T);
fprintf('f0 = %.2f Hz (częstotliwość podstawowa)\n', f0);
fprintf('Częstotliwość sygnału = 10*f0 = %.2f Hz\n', 10*f0);


%% Macierz DFT
n = 0:N-1;
k = 0:N-1;
A = sqrt(1/N) * exp(-1j * 2*pi/N * (k.' * n));

%% DFT sygnału
c = A * x.';

%% POPRAWNE SKALOWANIE
cs = sqrt(1/N) * c;

%% OŚ CZĘSTOTLIWOŚCI
fk = f0 * (0:N-1);  % częstotliwości odpowiadające każdemu k [Hz]

%% Porównanie c vs cs
fprintf('\n=== SKALOWANIE ===\n');
fprintf('Maksymalny moduł c (bez skalowania): %.4f\n', max(abs(c)));
fprintf('Maksymalny moduł cs (po skalowaniu): %.4f\n', max(abs(cs)));
fprintf('Oczekiwana amplituda: 0.5 (połowa z A=1 bo dwa piki)\n');

%% Wykresy z osią częstotliwości
figure(1);
subplot(2,1,1);
stem(fk, real(cs));  % OŚ X to teraz CZĘSTOTLIWOŚĆ!
title('cos(10*f0): Re(cs)');
xlabel('Częstotliwość [Hz]'); ylabel('Re(cs)');
grid on;

subplot(2,1,2);
stem(fk, imag(cs));
title('cos(10*f0): Im(cs)');
xlabel('Częstotliwość [Hz]'); ylabel('Im(cs)');
grid on;

figure(2);
subplot(2,1,1);
stem(fk, abs(cs));
title('cos(10*f0): |cs| (moduł)');
xlabel('Częstotliwość [Hz]'); ylabel('|cs|');
grid on;

subplot(2,1,2);
stem(fk, angle(cs));
title('cos(10*f0): faza');
xlabel('Częstotliwość [Hz]'); ylabel('faza [rad]');
grid on;

fprintf('\n=== PIKI W WIDMIE ===\n');
[pks, locs] = findpeaks(abs(cs), 'MinPeakHeight', 0.4);
fprintf('Piki na częstotliwościach: ');
fprintf('%.2f Hz ', fk(locs));
fprintf('\n');


%% ========== WNIOSKI ==========

% PRZYPADEK 1: cos(10*f0)
% Widzimy dwa ostre piki na częstotliwościach 100 Hz i 900 Hz
% o amplitudzie 0.5 każdy. Część rzeczywista ma symetryczne piki,
% część urojona jest bliska zeru (błędy numeryczne)

% PRZYPADEK 2: sin(10*f0)
% Analogicznie do cos - dwa ostre piki na 100 Hz i 900 Hz, ale energia
% w części urojonej (asymetryczne - przeciwne znaki) Część rzeczywista
% bliska zeru.

% PRZYPADEK 3: cos(10.5*f0)
% Energia rozlewa się na wiele częstotliwości (wyciek widmowy) - brak 
% ostrych pików. Maksymalny moduł < 0.5 nie pasuje do bazy DFT 
% (nie jest całkowitą wielokrotnością f0)

% PRZYPADEK 4: sin(10.5*f0)
% Identyczny efekt wycieku jak dla cos(10.5*f0) - energia rozproszona. 
% Różnica tylko w tym, że energia w części urojonej zamiast rzeczywistej.

% Dlaczego moduł = 0.5 zamiast 1 dla 10*f0?
% Energia dzieli się równo na dwa piki (f i fs-f) zgodnie z wzorami Eulera