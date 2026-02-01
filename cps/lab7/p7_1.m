% cps07_problem_7_1.m
% podstawy filtracji analogowej - transmitancja, zera, bieguny
clear all; close all; clc;

%% wybor metody definiowania filtra
metoda = 2;  % 1 = wspolczynniki wielomianow, 2 = zera i bieguny

if metoda == 1
    b = [3, 2];
    a = [4, 3, 2, 1];
    z = roots(b);
    p = roots(a);
else
    wzm = 0.001;
    z = 1j*2*pi*[600, 800];
    z = [z conj(z)];
    p = [-1, -1] + 1j*2*pi*[100, 200];
    p = [p conj(p)];
    b = wzm * poly(z);
    a = poly(p);
end

%% wyswietlenie wspolczynnikow
fprintf('=== WSPOLCZYNNIKI TRANSMITANCJI ===\n');
fprintf('b (licznik):   '); disp(b);
fprintf('a (mianownik): '); disp(a);

%% wykres zer i biegunow
figure(1);
plot(real(z), imag(z), 'bo', 'MarkerSize', 10, 'LineWidth', 2); hold on;
plot(real(p), imag(p), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--'); hold off;
grid on;
title('Zera (o) i Bieguny (*) transmitancji H(s)');
xlabel('Re(s)'); ylabel('Im(s)');
legend('zera', 'bieguny', 'Location', 'best');

if all(real(p) < 0)
    fprintf('Filtr jest STABILNY\n\n');
else
    fprintf('UWAGA: Filtr jest NIESTABILNY!\n\n');
end
pause

%% charakterystyka amplitudowa i fazowa
f = 0 : 0.1 : 1000;
w = 2*pi*f;
s = 1j*w;
H = polyval(b, s) ./ polyval(a, s);

figure(2);
plot(f, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa filtra');
grid on;
pause

figure(3);
plot(f, unwrap(angle(H)), 'r', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('faza [rad]');
title('Charakterystyka fazowa filtra (unwrap)');
grid on;
pause

%% odpowiedz impulsowa i skokowa
figure(4);
impulse(b, a);
title('Odpowiedz impulsowa h(t)');
grid on;
pause

figure(5);
step(b, a);
title('Odpowiedz skokowa u(t)');
grid on;
pause

%% MÓJ FILTR: usuwa 300 Hz, wzmacnia 400 Hz
fprintf('=== MÓJ FILTR: usuwa 300 Hz, wzmacnia 400 Hz ===\n');

wzm_my = 0.01;
z_my = 1j*2*pi*300;
z_my = [z_my conj(z_my)];
p_my = -10 + 1j*2*pi*400;
p_my = [p_my conj(p_my)];

b_my = wzm_my * poly(z_my);
a_my = poly(p_my);

H_my = polyval(b_my, s) ./ polyval(a_my, s);

figure(6);
subplot(2,1,1);
plot(real(z_my), imag(z_my), 'bo', 'MarkerSize', 10, 'LineWidth', 2); hold on;
plot(real(p_my), imag(p_my), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--'); hold off;
grid on; title('Moj filtr: zera (o) i bieguny (*)');
xlabel('Re(s)'); ylabel('Im(s)');

subplot(2,1,2);
plot(f, 20*log10(abs(H_my)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa - dolek przy 300 Hz, gorka przy 400 Hz');
grid on;
xline(300, 'g--', '300 Hz');
xline(400, 'm--', '400 Hz');
pause

figure(7);
impulse(b_my, a_my);
title('Odpowiedz impulsowa mojego filtra');
grid on;

% podsumowanie:
% - zera transmitancji powoduja DOLKI (usuwanie czestotliwosci)
% - bieguny transmitancji powoduja GORKI (wzmacnianie czestotliwosci)
% - bieguny musza lezec w lewej polplaszczyznie (Re < 0) dla stabilnosci
% - zera i bieguny wystepuja w parach sprzezonych -> wspolczynniki rzeczywiste
% - skoki +/- pi w fazie wystepuja przy zerach transmitancji