clear all; close all; clc;

fpr = 8000;                 % czestotliwosc probkowania (Hz)
T = 3;                      % czas trwania sygnalu w sekundach
N = round(T*fpr);           % liczba probek, 100 albo 1000
dt=1/fpr; t=dt*(0:N-1);     % os czasu
n = 1:1000;                 % indeksy probkek sygnalu dla rysunkow

% Sygnal
x1 = sin(2*pi*200*t) + sin(2*pi*800*t);                                 % 2xSIN
x2 = sin( 2*pi*( 0*t + 0.5*((1/T)*fpr/4)*t.^2 ) );                      % LFM
fm=0.5; x3 = sin(2*pi*((fpr/4)*t - (fpr/8)/(2*pi*fm)*cos(2*pi*fm*t)));  % SFM
x = x2 + 0.5*randn(1,N);                                                % wybor
figure; plot(t(n),x(n),'b-'); xlabel('t [s]'); title('x(t)'); grid; pause % rysunek

% Widmo FFT
Mwind = 256; Mstep=16; Mfft=2*Mwind; Many = floor((N-Mwind)/Mstep)+1;
t = (Mwind/2+1/2)*dt + Mstep*dt*(0:Many-1);                         % czas
f = fpr/Mfft*(0:Mfft-1);                                            % czestotliwosc
w = hamming( Mwind )';                                              % wybor okna
X1 = zeros(Mfft,Many); X2 = zeros(1,Mfft);                          % inicjalizacja STFT i PSD
for m = 1 : Many                                                    % petla analizy
    bx = x( 1+(m-1)*Mstep : Mwind+(m-1)*Mstep );                    % kolejny fragment sygnalu
    bx = bx .* w;                                                   % okienkowanie
    X = fft( bx, Mfft )/sum(w);                                     % FFT ze skalowaniem
    X1(1:Mfft,m) = X;                                               % <--- ! STFT
    X2 = X2 + abs(X).^2;                                            % <--- ! Welch PSD

    % DODANE - animacja w tej samej petli
    if mod(m, 50) == 1
        semilogy(f, X2/m/fpr);
        title(['iteracja ' num2str(m) ' z ' num2str(Many)]);
        xlabel('f [Hz]'); ylabel('V^2 / Hz');
        grid on;
        drawnow;
    end
    % animacja w pętli, co 50 iteracji rysujemy aktualne widmo psd
    % na początku widmo jest zaszumione, z każdą iteracją staje się coraz gładsza
end                                                                 % konie petli
pause();
X1 = 20*log10( abs(X1) );                                           % przeliczenie na decybele
X2 = (1/Many)*X2/fpr;                                               % normalizacja PSD
% spectrogram(x,Mwind,Mwind-Mstep,Mfft,fpr); pause                  % STFT Matlab

figure;
imagesc(t,f,X1);                                                    % macierz widma amplitudowego jako obraz
c=colorbar; c.Label.String = 'V (dB)'; ax = gca; ax.YDir = 'normal';
xlabel('t (s)'); ylabel('f (Hz)'); title('STFT |X(t,f)|'); pause
figure;
semilogy(f,X2); grid; title('PSD Welcha'); xlabel('f [Hz]'); ylabel('V^2 / Hz'); pause

%Uruchom program oraz obejrzyj dwa obliczone widma
%FFT sygnału: X1 and X2. Dlaczego sa˛ one róz˙ne?

%x1
% stft pokazuje widmo w czasie jako obrazek 2d, widać sinusy jako poziome linie plus szum
% psd welcha uśrednia widma wielu fragmentów, wynik jest gładsza i mniej zaszumiony
%x2
% sygnał chirp ma częstotliwość która rośnie w czasie, na spektrogramie widać skośną linię
% widmo welcha uśrednia po czasie więc widać tylko zakres częstotliwości od 0 do 2000 hz


%% "animacja"
% w kazdej iteracji x2 sie usrednia, na poczatku widmo jest zaszumione
% z kazdym krokiem staje sie coraz gladsze bo dodajemy kolejne widma



X_caly = fft(x);
X_caly_psd = (abs(X_caly)/N).^2 / fpr;
f_caly = fpr/N * (0:N-1);

%% porownanie na jednym wykresie
figure;
semilogy(f, X2, 'b', 'DisplayName', 'Welch PSD');
hold on;
semilogy(f_caly, X_caly_psd, 'r', 'DisplayName', 'jedno FFT');
legend;
xlabel('f [Hz]'); ylabel('V^2 / Hz');
title('porownanie welch vs jedno fft');
grid on;
hold off;
pause();
% jedno fft calego sygnalu jest bardzo zaszumione, pelno pików od szumu
% welch usrednia wiele krotkich fft wiec wynik jest duzo gladszy

%% porownanie z funkcja matlaba pwelch
[Pxx, f_pwelch] = pwelch(x, hamming(Mwind), Mwind-Mstep, Mfft, fpr, 'twosided');

% przelicznik normalizacji
skal = sum(w)^2 / sum(w.^2);

figure;
semilogy(f, X2 * skal, 'b', 'DisplayName', 'nasze welch');
hold on;
semilogy(f_pwelch, Pxx, 'r--', 'DisplayName', 'matlab pwelch');
legend;
xlabel('f [Hz]'); ylabel('V^2 / Hz');
title('porownanie naszego welcha z matlabowym pwelch');
grid on;
hold off;
pause();
% porównanie naszego welcha z funkcją matlaba pwelch, wyniki są prawie identyczne
% różnica w normalizacji bo pwelch używa sum(w.^2) a my sum(w), skal to koryguje

%% porownanie mypwelch z matlab pwelch
[Pxx_my, f_my] = mypwelch(x, Mwind, Mstep, Mfft, fpr);
[Pxx_mat, f_mat] = pwelch(x, hamming(Mwind), Mwind-Mstep, Mfft, fpr, 'twosided');

figure;
semilogy(f_my, Pxx_my, 'b', 'DisplayName', 'mypwelch');
hold on;
semilogy(f_mat, Pxx_mat, 'r--', 'DisplayName', 'matlab pwelch');
legend;
xlabel('f [Hz]'); ylabel('V^2 / Hz');
title('porownanie mypwelch z matlab pwelch');
grid on;
hold off;

%% funkcja

function [Pxx, f] = mypwelch(x, Mwind, Mstep, Mfft, fs)
% x - sygnał
% Mwind - długość okna
% Mstep - krok przesunięcia
% Mfft - długość fft
% fs - częstotliwość próbkowania

    N = length(x);
    w = hamming(Mwind)';
    Many = floor((N - Mwind) / Mstep) + 1;
    
    Pxx = zeros(1, Mfft);
    
    for m = 1 : Many
        bx = x(1 + (m-1)*Mstep : Mwind + (m-1)*Mstep);
        bx = bx .* w;
        X = fft(bx, Mfft);
        Pxx = Pxx + abs(X).^2;
    end
    
    Pxx = Pxx / (Many * fs * sum(w.^2));
    f = fs/Mfft * (0:Mfft-1);
end