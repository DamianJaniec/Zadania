% cps07_problem_7_2.m
% metoda projektowania "Zer & Biegunow" - filtry LP, HP, BP, BS
clear all; close all; clc;

%% wybor typu filtra
typ_filtra = 4;  % 1=LP, 2=HP, 3=BP, 4=BS

f = 0 : 0.5 : 2000;
w = 2*pi*f;
s = 1j*w;

%% 1. LOW-PASS: przepuszcza [0, 250] Hz
if typ_filtra == 1
    fprintf('=== LOW-PASS: przepuszcza [0, 250] Hz ===\n');
    
    % bieguny - definiuja czestotliwosc odciecia
    p = -100 + 1j*2*pi*[200, 250];
    p = [p conj(p)];
    
    % brak zer (lub mniej niz biegunow)
    z = [];
    
    wzm = 1e6;
    nazwa = 'LOW-PASS [0, 250] Hz';
end

%% 2. HIGH-PASS: przepuszcza [250, inf] Hz
if typ_filtra == 2
    fprintf('=== HIGH-PASS: przepuszcza [250, inf] Hz ===\n');
    
    % zera przy niskich czestotliwosciach
    z = [0, 0];  % podwojne zero w DC
    
    % bieguny przy wyzszych czestotliwosciach
    p = -50 + 1j*2*pi*[300, 400, 500];
    p = [p conj(p)];
    
    wzm = 1e8;
    nazwa = 'HIGH-PASS [250, inf] Hz';
end

%% 3. BAND-PASS: przepuszcza [400, 600] Hz
if typ_filtra == 3
    fprintf('=== BAND-PASS: przepuszcza [400, 600] Hz ===\n');
    
    % bieguny w pasmie przepustowym - wzmacniaja [400, 600] Hz
    p = -20 + 1j*2*pi*[450, 500, 550];
    p = [p conj(p)];
    
    % zera ponizej i powyzej pasma (mniej niz biegunow!)
    z = 1j*2*pi*[0, 200, 800];
    z = [z conj(z)];
    
    wzm = 1e4;
    nazwa = 'BAND-PASS [400, 600] Hz';
end

%% 4. BAND-STOP: przepuszcza [0, 400] i [600, inf] Hz
if typ_filtra == 4
    fprintf('=== BAND-STOP: przepuszcza [0,400] i [600,inf] Hz ===\n');
    
    % zera w pasmie zaporowym - usuwaja [400, 600] Hz
    z = 1j*2*pi*[500];
    z = [z conj(z)];
    
    % bieguny w pasmach przepustowych (wiecej niz zer)
    p = -50 + 1j*2*pi*[200, 300, 700, 800];
    p = [p conj(p)];
    
    wzm = 1e10;
    nazwa = 'BAND-STOP (notch) [400, 600] Hz';
end

%% obliczenie transmitancji
b = wzm * poly(z);
a = poly(p);
H = polyval(b, s) ./ polyval(a, s);

fprintf('Liczba zer: %d\n', length(z));
fprintf('Liczba biegunow: %d\n', length(p));

%% wykresy
figure(1);
plot(real(z), imag(z)/(2*pi), 'bo', 'MarkerSize', 10, 'LineWidth', 2); hold on;
plot(real(p), imag(p)/(2*pi), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--'); hold off;
grid on;
title(['Zera (o) i Bieguny (*) - ' nazwa]);
xlabel('Re(s)'); ylabel('Im(s)/(2\pi) [Hz]');
legend('zera', 'bieguny');
pause

figure(2);
plot(f, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Charakterystyka amplitudowa - ' nazwa]);
grid on;
ylim([-80 20]);

if typ_filtra == 1
    xline(250, 'r--', 'f_c = 250 Hz');
elseif typ_filtra == 2
    xline(250, 'r--', 'f_c = 250 Hz');
elseif typ_filtra == 3
    xline(400, 'g--', '400 Hz');
    xline(600, 'g--', '600 Hz');
elseif typ_filtra == 4
    xline(400, 'r--', '400 Hz');
    xline(600, 'r--', '600 Hz');
end
pause

figure(3);
plot(f, unwrap(angle(H)), 'r', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('faza [rad]');
title(['Charakterystyka fazowa - ' nazwa]);
grid on;
pause

figure(4);
impulse(b, a);
title('Odpowiedz impulsowa');
grid on;
pause

figure(5);
step(b, a);
title('Odpowiedz skokowa');
grid on;

% metoda zer i biegunow jest prostsza i skutecniejsza nizdobor wspolczynnikow
% bo mamy bezposrednia kontrole nad:
% - gdzie sa dolki (zera)
% - gdzie sa gorki (bieguny)
% - stabilnoscia (bieguny w lewej polplaszczyznie)