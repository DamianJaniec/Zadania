% cps07_problem_7_3.m
% filtr dolno-przepustowy dla przetwornika A/C
clear all; close all; clc;

%% parametry
fpr = 48000;        % czestotliwosc probkowania
fc = fpr/2;         % czestotliwosc odciecia = 24000 Hz (Nyquist)

f = 0 : 10 : 50000;
w = 2*pi*f;
s = 1j*w;

%% proba 1: metoda zer i biegunow
fprintf('=== PROBA 1: metoda zer i biegunow ===\n');

% bieguny rowno rozlozone ponizej fc
p1 = -1000 + 1j*2*pi*[20000, 22000, 24000];
p1 = [p1 conj(p1)];

z1 = [];  % brak zer
wzm1 = abs(polyval(poly(p1), 0));  % normalizacja do 1 przy DC

b1 = wzm1 * poly(z1);
a1 = poly(p1);
H1 = polyval(b1, s) ./ polyval(a1, s);

figure(1);
subplot(2,1,1);
plot(real(p1), imag(p1)/(2*pi), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--');
grid on; title('Proba 1: bieguny');
xlabel('Re(s)'); ylabel('Im(s)/(2\pi) [Hz]');

subplot(2,1,2);
plot(f/1000, 20*log10(abs(H1)), 'b', 'LineWidth', 1.5);
xlabel('f [kHz]'); ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa');
xline(fc/1000, 'r--', 'f_{pr}/2 = 24 kHz');
grid on; ylim([-80 10]);
pause

%% proba 2: wiecej biegunow
fprintf('=== PROBA 2: wiecej biegunow ===\n');

p2 = -500 + 1j*2*pi*[18000, 20000, 22000, 23000, 24000];
p2 = [p2 conj(p2)];

z2 = [];
wzm2 = abs(polyval(poly(p2), 0));

b2 = wzm2 * poly(z2);
a2 = poly(p2);
H2 = polyval(b2, s) ./ polyval(a2, s);

figure(2);
subplot(2,1,1);
plot(real(p2), imag(p2)/(2*pi), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--');
grid on; title('Proba 2: wiecej biegunow');
xlabel('Re(s)'); ylabel('Im(s)/(2\pi) [Hz]');

subplot(2,1,2);
plot(f/1000, 20*log10(abs(H2)), 'b', 'LineWidth', 1.5);
xlabel('f [kHz]'); ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa');
xline(fc/1000, 'r--', 'f_{pr}/2 = 24 kHz');
grid on; ylim([-80 10]);
pause

%% wniosek
% metoda zer i biegunow nie daje dobrego filtra LP
% bo trudno uzyskac plaska charakterystyke i strome zbocze
% lepiej uzyc funkcji butter(), cheby1(), ellip()