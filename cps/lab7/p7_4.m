% cps07_problem_7_4.m
% filtry Butterwortha - dolno- i gorno-przepustowe
clear all; close all; clc;

%% parametry
N = 5;          % liczba biegunow
f0 = 100;       % czestotliwosc odciecia [Hz]
typ = 1;        % 1 = LOW-PASS, 2 = HIGH-PASS

%% obliczenie biegunow (leza na okregu)
alpha = pi/N;
beta = pi/2 + alpha/2 + alpha*(0:N-1);
R = 2*pi*f0;    % promien okregu
p = R*exp(1j*beta);

%% zera i wzmocnienie
if typ == 1
    z = [];
    wzm = prod(-p);
    nazwa = 'LOW-PASS';
else
    z = zeros(1, N);  % N zer w poczatku ukladu (s=0)
    wzm = 1;
    nazwa = 'HIGH-PASS';
end

%% wspolczynniki transmitancji
b = wzm * poly(z);
a = poly(p);
b = real(b);
a = real(a);

%% porownanie z funkcja butter()
if typ == 1
    [b_mat, a_mat] = butter(N, 2*pi*f0, 'low', 's');
else
    [b_mat, a_mat] = butter(N, 2*pi*f0, 'high', 's');
end

fprintf('=== FILTR BUTTERWORTHA %s, N=%d, f0=%d Hz ===\n', nazwa, N, f0);
fprintf('Promien okregu R = 2*pi*f0 = %.2f rad/s\n\n', R);

%% wykres zer i biegunow z okregiem
figure(1);
theta = 0:pi/1000:2*pi;
c = R*cos(theta);
s_circle = R*sin(theta);
plot(c, s_circle, 'k-', 'LineWidth', 1); hold on;
if ~isempty(z)
    plot(real(z), imag(z), 'bo', 'MarkerSize', 12, 'LineWidth', 2);
end
plot(real(p), imag(p), 'r*', 'MarkerSize', 12, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--'); hold off;
grid on; axis equal;
title(['Zera (o) i Bieguny (*) na okregu R=' num2str(round(R)) ' - ' nazwa]);
xlabel('Re(s)'); ylabel('Im(s)');
if ~isempty(z)
    legend('okrag', 'zera', 'bieguny');
else
    legend('okrag', 'bieguny');
end
pause

%% charakterystyka amplitudowa (skala liniowa)
f = 0 : 0.1 : 500;
w = 2*pi*f;
s = 1j*w;
H = polyval(b, s) ./ polyval(a, s);

figure(2);
plot(f, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Charakterystyka amplitudowa - ' nazwa]);
xline(f0, 'r--', ['f_0 = ' num2str(f0) ' Hz']);
yline(-3, 'g--', '-3 dB');
grid on; ylim([-80 10]);
pause

%% charakterystyka amplitudowa (skala logarytmiczna)
f_log = logspace(-1, 4, 1000);
w_log = 2*pi*f_log;
s_log = 1j*w_log;
H_log = polyval(b, s_log) ./ polyval(a, s_log);

figure(3);
semilogx(f_log, 20*log10(abs(H_log)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Charakterystyka amplitudowa (semilog) - ' nazwa ', N=' num2str(N)]);
xline(f0, 'r--', ['f_0 = ' num2str(f0) ' Hz']);
yline(-3, 'g--', '-3 dB');
grid on; ylim([-120 20]);
pause

%% charakterystyka fazowa
figure(4);
semilogx(f_log, unwrap(angle(H_log))*180/pi, 'r', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('faza [stopnie]');
title(['Charakterystyka fazowa - ' nazwa]);
grid on;
pause

%% odpowiedz impulsowa i skokowa
figure(5);
impulse(b, a);
title('Odpowiedz impulsowa');
grid on;
pause

figure(6);
step(b, a);
title('Odpowiedz skokowa');
grid on;
pause

%% porownanie z butter() Matlaba
H_mat = polyval(b_mat, s_log) ./ polyval(a_mat, s_log);

figure(7);
semilogx(f_log, 20*log10(abs(H_log)), 'b', 'LineWidth', 2); hold on;
semilogx(f_log, 20*log10(abs(H_mat)), 'r--', 'LineWidth', 1.5); hold off;
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Porownanie: moj filtr vs butter() Matlaba');
legend('moj filtr', 'butter()');
grid on; ylim([-120 20]);
pause

%% porownanie dla roznych N
figure(8);
kolory = ['b', 'r', 'g', 'm', 'c', 'k'];
hold on;
for N_test = 2:2:10
    alpha_t = pi/N_test;
    beta_t = pi/2 + alpha_t/2 + alpha_t*(0:N_test-1);
    p_t = R*exp(1j*beta_t);
    if typ == 1
        z_t = []; wzm_t = prod(-p_t);
    else
        z_t = zeros(1, N_test); wzm_t = 1;
    end
    b_t = real(wzm_t * poly(z_t));
    a_t = real(poly(p_t));
    H_t = polyval(b_t, s_log) ./ polyval(a_t, s_log);
    semilogx(f_log, 20*log10(abs(H_t)), kolory(N_test/2), 'LineWidth', 1.5);
end
hold off;
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Wplyw liczby biegunow N na stromnosc - ' nazwa]);
legend('N=2', 'N=4', 'N=6', 'N=8', 'N=10');
xline(f0, 'k--');
grid on; ylim([-120 20]);

% kazdy biegun dodaje 20 dB/dekade opadania charakterystyki
% N=2: 40 dB/dek, N=4: 80 dB/dek, N=10: 200 dB/dek