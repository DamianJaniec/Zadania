% cps07_problem_7_5.m
% filtr Czebyszewa typu I - bieguny na elipsie
clear all; close all; clc;

%% parametry
N = 5;          % liczba biegunow
f0 = 100;       % czestotliwosc graniczna [Hz]
Rp = 1;         % oscylacje w pasmie przepustowym [dB]

%% obliczenie biegunow Czebyszewa (leza na elipsie)
w0 = 2*pi*f0;
eps = sqrt(10^(Rp/10) - 1);  % parametr oscylacji
v0 = asinh(1/eps) / N;

% polozenie biegunow na elipsie
k = 0:N-1;
theta = pi/2 + pi*(2*k+1)/(2*N);  % katy

% polosi elipsy
a_elip = w0 * sinh(v0);  % polos rzeczywista (pozioma)
b_elip = w0 * cosh(v0);  % polos urojona (pionowa)

% bieguny
p_real = a_elip * cos(theta);
p_imag = b_elip * sin(theta);
p = p_real + 1j*p_imag;

% zera i wzmocnienie (LP - brak zer)
z = [];
wzm = prod(-p);
if mod(N,2) == 0
    wzm = wzm / sqrt(1 + eps^2);  % korekta dla parzystego N
end

%% wspolczynniki transmitancji
b = real(wzm * poly(z));
a = real(poly(p));

%% porownanie z cheby1() Matlaba
[b_mat, a_mat] = cheby1(N, Rp, w0, 's');

fprintf('=== FILTR CZEBYSZEWA TYPU I, N=%d, f0=%d Hz, Rp=%.1f dB ===\n', N, f0, Rp);
fprintf('Polos elipsy a = %.2f (rzeczywista)\n', a_elip);
fprintf('Polos elipsy b = %.2f (urojona)\n\n', b_elip);

%% wykres zer i biegunow z elipsa
figure(1);
theta_elip = 0:pi/1000:2*pi;
elip_x = a_elip * cos(theta_elip);
elip_y = b_elip * sin(theta_elip);
plot(elip_x, elip_y, 'k-', 'LineWidth', 1); hold on;
plot(real(p), imag(p), 'r*', 'MarkerSize', 12, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--'); hold off;
grid on; axis equal;
title(['Bieguny Czebyszewa na elipsie - N=' num2str(N)]);
xlabel('Re(s)'); ylabel('Im(s)');
legend('elipsa', 'bieguny');
pause

%% charakterystyka amplitudowa (semilog)
f_log = logspace(-1, 4, 1000);
s_log = 1j*2*pi*f_log;
H = polyval(b, s_log) ./ polyval(a, s_log);

figure(2);
semilogx(f_log, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Czebyszew I - N=' num2str(N) ', Rp=' num2str(Rp) ' dB']);
xline(f0, 'r--', ['f_0 = ' num2str(f0) ' Hz']);
yline(-Rp, 'g--', ['-' num2str(Rp) ' dB']);
grid on; ylim([-80 10]);
pause

%% porownanie Czebyszew vs Butterworth
% Butterworth
alpha = pi/N;
beta = pi/2 + alpha/2 + alpha*(0:N-1);
R = w0;
p_but = R*exp(1j*beta);
b_but = real(prod(-p_but) * poly([]));
a_but = real(poly(p_but));
H_but = polyval(b_but, s_log) ./ polyval(a_but, s_log);

figure(3);
semilogx(f_log, 20*log10(abs(H)), 'b', 'LineWidth', 1.5); hold on;
semilogx(f_log, 20*log10(abs(H_but)), 'r--', 'LineWidth', 1.5); hold off;
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Czebyszew I vs Butterworth - N=' num2str(N)]);
xline(f0, 'k--');
legend('Czebyszew I', 'Butterworth');
grid on; ylim([-80 10]);
pause

%% porownanie z cheby1() Matlaba
H_mat = polyval(b_mat, s_log) ./ polyval(a_mat, s_log);

figure(4);
semilogx(f_log, 20*log10(abs(H)), 'b', 'LineWidth', 2); hold on;
semilogx(f_log, 20*log10(abs(H_mat)), 'r--', 'LineWidth', 1.5); hold off;
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Porownanie: moj filtr vs cheby1() Matlaba');
legend('moj filtr', 'cheby1()');
grid on; ylim([-80 10]);
pause

%% porownanie dla roznych N
figure(5);
kolory = ['b', 'r', 'g', 'm', 'c', 'k', 'y'];
hold on;
for idx = 1:7
    N_test = idx + 1;  % N = 2,3,4,5,6,7,8
    [b_t, a_t] = cheby1(N_test, Rp, w0, 's');
    H_t = polyval(b_t, s_log) ./ polyval(a_t, s_log);
    semilogx(f_log, 20*log10(abs(H_t)), kolory(idx), 'LineWidth', 1.5);
end
hold off;
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Czebyszew I - wplyw N, f0=' num2str(f0) ' Hz']);
legend('N=2', 'N=3', 'N=4', 'N=5', 'N=6', 'N=7', 'N=8');
xline(f0, 'k--');
grid on; ylim([-100 10]);
pause

%% porownanie dla roznych f0
figure(6);
f0_test = [1, 10, 100];
kolory = ['b', 'r', 'g'];
hold on;
for idx = 1:3
    [b_t, a_t] = cheby1(N, Rp, 2*pi*f0_test(idx), 's');
    H_t = polyval(b_t, s_log) ./ polyval(a_t, s_log);
    semilogx(f_log, 20*log10(abs(H_t)), kolory(idx), 'LineWidth', 1.5);
end
hold off;
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title(['Czebyszew I - wplyw f0, N=' num2str(N)]);
legend('f0=1 Hz', 'f0=10 Hz', 'f0=100 Hz');
grid on; ylim([-100 10]);

% Czebyszew I ma:
% - oscylacje w pasmie przepustowym (Rp dB)
% - szybsze przejscie do pasma zaporowego niz Butterworth
% - bieguny na elipsie (nie na okregu)