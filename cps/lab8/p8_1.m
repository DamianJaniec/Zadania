% cps08_problem_8_1.m
% filtry cyfrowe IIR - funkcje Matlaba
clear all; close all; clc;

%% parametry
fpr = 2000;     % czestotliwosc probkowania [Hz]
f1 = 400;       % dolna czestotliwosc graniczna [Hz]
f2 = 600;       % gorna czestotliwosc graniczna [Hz]
N = 8;          % rzad filtra
Rp = 3;         % oscylacje w pasmie przepustowym [dB]
Rs = 80;        % tlumienie w pasmie zaporowym [dB]

typ = 4;        % 1=BS, 2=BP, 3=HP, 4=LP

%% projekt filtra
if typ == 1
    [b, a] = ellip(N, Rp, Rs, [f1, f2]/(fpr/2), 'stop');
    nazwa = 'BAND-STOP (pasmowo-zaporowy)';
elseif typ == 2
    [b, a] = ellip(N, Rp, Rs, [f1, f2]/(fpr/2), 'bandpass');
    nazwa = 'BAND-PASS (pasmowo-przepustowy)';
elseif typ == 3
    [b, a] = ellip(N, Rp, Rs, f1/(fpr/2), 'high');
    nazwa = 'HIGH-PASS (gorno-przepustowy)';
elseif typ == 4
    [b, a] = ellip(N, Rp, Rs, f2/(fpr/2), 'low');
    nazwa = 'LOW-PASS (dolno-przepustowy)';
end

fprintf('=== FILTR ELIPTYCZNY %s ===\n', nazwa);
fprintf('fpr = %d Hz, N = %d, Rp = %d dB, Rs = %d dB\n', fpr, N, Rp, Rs);
fprintf('f1 = %d Hz, f2 = %d Hz\n\n', f1, f2);

%% charakterystyka czestotliwosciowa
figure(1);
Npunkt = 1000;
freqz(b, a, Npunkt, fpr);
title(['Charakterystyka filtra - ' nazwa]);
pause

%% generacja sygnalu testowego
Nx = 1000;
dt = 1/fpr;
t = dt*(0:Nx-1);
fx1 = 10;       % skladowa niska czestotliwosc
fx2 = 500;      % skladowa w pasmie [f1, f2]
x = sin(2*pi*fx1*t) + sin(2*pi*fx2*t);

%% filtracja
y = filter(b, a, x);

figure(2);
subplot(2,1,1);
plot(t, x, 'b'); grid on;
title('Sygnal wejsciowy x(t)');
xlabel('t [s]'); ylabel('amplituda');

subplot(2,1,2);
plot(t, y, 'r'); grid on;
title('Sygnal wyjsciowy y(t) - po filtracji');
xlabel('t [s]'); ylabel('amplituda');
pause

figure(3);
plot(t, x, 'b', t, y, 'r', 'LineWidth', 1);
title('Porownanie: wejscie (niebieski) vs wyjscie (czerwony)');
xlabel('t [s]'); ylabel('amplituda');
legend('wejscie x', 'wyjscie y');
grid on;
pause

%% alternatywy dla ellip()
fprintf('=== ALTERNATYWY DLA ellip() ===\n');

% Butterworth
[b_but, a_but] = butter(N, [f1, f2]/(fpr/2), 'stop');
fprintf('butter() - filtr Butterwortha\n');

% Chebyshev I
[b_ch1, a_ch1] = cheby1(N, Rp, [f1, f2]/(fpr/2), 'stop');
fprintf('cheby1() - filtr Czebyszewa typu I\n');

% Chebyshev II
[b_ch2, a_ch2] = cheby2(N, Rs, [f1, f2]/(fpr/2), 'stop');
fprintf('cheby2() - filtr Czebyszewa typu II\n');

fprintf('ellip()  - filtr eliptyczny (Cauera)\n\n');

%% porownanie wszystkich filtrow
figure(4);
[H_el, f] = freqz(b, a, Npunkt, fpr);
[H_but, ~] = freqz(b_but, a_but, Npunkt, fpr);
[H_ch1, ~] = freqz(b_ch1, a_ch1, Npunkt, fpr);
[H_ch2, ~] = freqz(b_ch2, a_ch2, Npunkt, fpr);

plot(f, 20*log10(abs(H_but)), 'b', 'LineWidth', 1.5); hold on;
plot(f, 20*log10(abs(H_ch1)), 'r', 'LineWidth', 1.5);
plot(f, 20*log10(abs(H_ch2)), 'g', 'LineWidth', 1.5);
plot(f, 20*log10(abs(H_el)), 'm', 'LineWidth', 1.5); hold off;
xlabel('f [Hz]'); ylabel('|H(f)| [dB]');
title('Porownanie filtrow: Butterworth, Cheby1, Cheby2, Elliptic');
legend('Butterworth', 'Chebyshev I', 'Chebyshev II', 'Elliptic');
grid on; ylim([-100 10]);
xline(f1, 'k--'); xline(f2, 'k--');

% ellip - najbardziej strome zbocze, oscylacje w obu pasmach
% butter - plaska charakterystyka, najwolniejsze zbocze
% cheby1 - oscylacje w pasmie przepustowym
% cheby2 - oscylacje w pasmie zaporowym