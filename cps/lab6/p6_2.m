% cps_06_fftapp1_start.m
clear all; close all; clc;      % "mycie rak"
fpr = 1000;                     % czestotliwosc probkowania (Hz)
N = 100;                        % liczba probek sygnalu, 100 lub 1000
dt=1/fpr; t=dt*(0:N-1);         % chwile probkowania sygnalu, os czasu

% Signal
f0=50; x = sin(2*pi*f0*t); % sygnal o czestotliwosciach f0 = 50,100,125,200 Hz

% FFT spectrum
X = fft(x); % FFT
f = fpr/N *(0:N-1); % os czestotliwosci

% ... kontynuacja programu - czesc 2
% Interpolacja widma FFT z okienkowaniem sygnalu
K = 10;                     % rzad interpolacji
w1 = rectwin(N);            % okno prostokatne
w2 = chebwin(N,100);        % okno Czebyszewa
w = w2;                     % wybor okna: w1, w2, ...
x = x.*w';                  % okienkowanie sygnalu
X = fft(x,N);               % bez dolaczenia zer na koncu sygnalu
Xz = fft(x,K*N);            % z zerami; Xz = fft([x,zeros(1,(K-1)*N)])/sum(w);
fz = fpr/(K*N)*(0:K*N-1);   % os czestotliwosci
figure                      %
plot(f,20*log10(abs(X)/sum(w)),'bo-',fz,20*log10(abs(Xz)/sum(w)),'r.-','MarkerFaceColor','b');
xlabel('f (Hz)'); title('Zoomowanie widma DFT z uzyciem FFT'); grid; %pause


%% wybierz w=w1. Uruchom program. Zwró´c uwag˛e na ko´ncowy rysunek, 
% pokazujacy dwa widma FFT: 1) bez dodania zer na ko´ncu sygnału 
% oryginalnego (X), 2) z dodaniemzer (Xz)

%w = 1
% dołączenie zer interpoluje widmo, ale nie  zwieksza rozdzielczosci
%w =2
%tutaj też zachodzi interpolacja, ale okno czebyszewa znacząco redukuje
%listki boczone


%% Ustaw x=ones(1,N). Potem najpierw wybierz w=w1, a za drugim razem w=w2. 
% Powiedz co teraz widzisz w widmie sygnału? Mo˙ze listek główny i listki 
% boczne widma DFT funkcji okna?

K = 10;                     % rzad interpolacji
w1 = rectwin(N);            % okno prostokatne
w2 = chebwin(N,100);        % okno Czebyszewa
w = w2;                     % wybor okna: w1, w2, ... (zacznij od w1!)
x = ones(1,N);              % DODAJ TO - sygnal samych jedynek
x = x.*w';                  % okienkowanie sygnalu
X = fft(x,N);               % bez dolaczenia zer na koncu sygnalu
Xz = fft(x,K*N);            % z zerami
fz = fpr/(K*N)*(0:K*N-1);   % os czestotliwosci
figure
plot(f,20*log10(abs(X)/sum(w)),'bo-',fz,20*log10(abs(Xz)/sum(w)),'r.-','MarkerFaceColor','b');
xlabel('f (Hz)'); title('Widmo okna'); grid;

% Główne piki będą w 0 oraz w 1000
% w1 - listki opadają powoli, i powoli rosną powstaje "banan"
% w2 - listki szybko opadają, zrówuja się zerem, a później szybko rosną

%% Dodaj kilka innych funkcji
% okien do programu. Porównaj widma X oraz Xz dla ró˙znych warto´sci stopnia
% nadpróbkowania (interpolacji) widma: K=10, 8, 6, 4, 2.

x = ones(1,N);
w = chebwin(N,100);
x_win = x.*w';

K_values = [2, 4, 6, 8, 10];

figure;
for i = 1:length(K_values)
    K = K_values(i);
    Xz = fft(x_win, K*N);
    fz = fpr/(K*N) * (0:K*N-1);
    
    subplot(length(K_values), 1, i);
    plot(fz, 20*log10(abs(Xz)/sum(w)), 'b.-');
    xlabel('f (Hz)'); ylabel('dB');
    title(['K = ' num2str(K) ', liczba punktow = ' num2str(K*N)]);
    grid on;
    xlim([0 fpr]);
end

%% Wszystkie K na jednym wykresie
x = ones(1,N);
w = chebwin(N,100);
x_win = x.*w';

K_values = [2, 4, 6, 8, 10];   
kolory = ['r','g','b','m','c'];

figure; hold on;
for i = 1:length(K_values)
    K = K_values(i);
    Xz = fft(x_win, K*N);
    fz = fpr/(K*N) * (0:K*N-1);
    plot(fz, 20*log10(abs(Xz)/sum(w)), kolory(i), 'DisplayName', ['K=' num2str(K)]);
end
xlabel('f (Hz)'); ylabel('dB');
title('Porownanie interpolacji dla roznych K');
legend; grid on; hold off;
xlim([0 fpr]);

% Im wieksze K tym wiecej punktow widma (gestsza interpolacja, gladszy 
% wykres)
% mniejsze K tym mniej punktow (bardziej kanciasty).