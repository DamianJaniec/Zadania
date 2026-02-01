% cps08_problem_8_2.m
% transmitancja i odpowiedz czestotliwosciowa filtra cyfrowego IIR
clear all; close all; clc;

%% parametry
fpr = 2000;     % czestotliwosc probkowania [Hz]
metoda = 1;     % 1 = wspolczynniki, 2 = zera i bieguny

%% wybor/projekt wspolczynnikow
if metoda == 1
    b = [2, 3];
    a = [1, 0.2, 0.3, 0.4];
    z = roots(b);
    p = roots(a);
else
    gain = 0.001;
    z = [1, 1] .* exp(1j*2*pi*[600, 800]/fpr);
    z = [z conj(z)];
    p = [0.99, 0.99] .* exp(1j*2*pi*[100, 200]/fpr);
    p = [p conj(p)];
    b = gain * poly(z);
    a = poly(p);
end

fprintf('=== FILTR CYFROWY IIR ===\n');
fprintf('fpr = %d Hz\n', fpr);
fprintf('b = '); disp(b);
fprintf('a = '); disp(a);

%% sprawdzenie stabilnosci
if all(abs(p) < 1)
    fprintf('Filtr jest STABILNY (bieguny wewnatrz okregu jednostkowego)\n\n');
else
    fprintf('UWAGA: Filtr jest NIESTABILNY!\n\n');
end

%% wykres zer i biegunow z okregiem jednostkowym
figure(1);
alfa = 0 : pi/1000 : 2*pi;
c = cos(alfa);
s = sin(alfa);
plot(real(z), imag(z), 'bo', 'MarkerSize', 10, 'LineWidth', 2); hold on;
plot(real(p), imag(p), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
plot(c, s, 'k-', 'LineWidth', 1); hold off;
grid on; axis equal;
title('Zera (o) i Bieguny (*) - okrag jednostkowy');
xlabel('Re(z)'); ylabel('Im(z)');
legend('zera', 'bieguny', 'okrag');
pause

%% charakterystyka czestotliwosciowa
f = 0 : 0.1 : fpr/2;
wn = 2*pi*f/fpr;
zz = exp(1j*wn);
H = polyval(b, zz) ./ polyval(a, zz);

figure(2);
plot(f, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa');
grid on;
pause

figure(3);
plot(f, unwrap(angle(H)), 'r', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('faza [rad]');
title('Charakterystyka fazowa');
grid on;
pause

%% porownanie z freqz()
figure(4);
[H_freqz, f_freqz] = freqz(b, a, 1000, fpr);
subplot(2,1,1);
plot(f_freqz, 20*log10(abs(H_freqz)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('freqz() - charakterystyka amplitudowa');
grid on;

subplot(2,1,2);
plot(f_freqz, unwrap(angle(H_freqz)), 'r', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('faza [rad]');
title('freqz() - charakterystyka fazowa');
grid on;
pause

%% ZADANIE: filtr usuwajacy 300 Hz i wzmacniajacy 400 Hz
fprintf('=== MÓJ FILTR: usuwa 300 Hz, wzmacnia 400 Hz ===\n');

% zero na okregu przy 300 Hz - usuwa te czestotliwosc
z_my = exp(1j*2*pi*300/fpr);
z_my = [z_my conj(z_my)];

% biegun blisko okregu przy 400 Hz - wzmacnia te czestotliwosc
p_my = 0.95 * exp(1j*2*pi*400/fpr);
p_my = [p_my conj(p_my)];

b_my = poly(z_my);
a_my = poly(p_my);

% normalizacja wzmocnienia
H_dc = polyval(b_my, 1) / polyval(a_my, 1);
b_my = b_my / abs(H_dc);

fprintf('zera przy 300 Hz: '); disp(z_my);
fprintf('bieguny przy 400 Hz: '); disp(p_my);

figure(5);
subplot(2,1,1);
plot(real(z_my), imag(z_my), 'bo', 'MarkerSize', 10, 'LineWidth', 2); hold on;
plot(real(p_my), imag(p_my), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
plot(c, s, 'k-'); hold off;
grid on; axis equal;
title('Moj filtr: zera (o) i bieguny (*)');
xlabel('Re(z)'); ylabel('Im(z)');

subplot(2,1,2);
[H_my, f_my] = freqz(b_my, a_my, 1000, fpr);
plot(f_my, 20*log10(abs(H_my)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Charakterystyka - dolek przy 300 Hz, gorka przy 400 Hz');
xline(300, 'g--', '300 Hz');
xline(400, 'm--', '400 Hz');
grid on;

% zero transmitancji = killer czestotliwosci (dolek)
% biegun transmitancji = wzmacniacz czestotliwosci (gorka)
% bieguny musza byc WEWNATRZ okregu jednostkowego (|p| < 1) dla stabilnosci
% zera i bieguny w parach sprzezonych -> wspolczynniki rzeczywiste