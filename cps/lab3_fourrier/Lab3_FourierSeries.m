% cps03_szereg_fouriera.m
% szereg Fouriera, aproksymacja wybranych przebiegow czasowych
% wspolczynniki analityczne i numeryczne
clear all; clf; subplot(111);

%% 1. Parametry programu
T = 1;              % okres przebiegu [sekundy]
N = 1000;           % liczba probek na okres
dt = T/N;           % odstep miedzy probkami
t = 0:dt:(N-1)*dt;  % os czasu
A = 1;              % amplituda sygnalu
NF = N/2;           % liczba wspolczynnikow szeregu Fouriera
isygnal = 10;        % numer sygnalu testowego
f0 = 1/T;           % czestotliwosc podstawowa
w0 = 2*pi*f0;       % pulsacja podstawowa

%% 2. Wygenerowanie jednego okresu sygnalu
% isygnal 1: prostokatny bipolarny
% isygnal 2: prostokatny bipolarny przesuniete
% isygnal 3: prostokatny bipolarny inne wypelnienie
% isygnal 4: pila trojkatny unipolarny 2
% isygnal 5: trojkat trojkatny bipolarny 2
% isygnal 6: sinus
% isygnal 7: prostokatny unipolarny wypelnienie 1/2
% isygnal 8: trojkatny bipolarny 1
% isygnal 9: sinusoidalny wyprostowany dwupolowkowo
% isygnal 10: sinusoidalny wyprostowany jednopolowkowo

if (isygnal==1) x = [0 A*ones(1,N/2-1) 0 -A*ones(1,N/2-1)]; end
if (isygnal==2) x = [A*ones(1,N/4) 0 -A*ones(1,N/2-1) 0 A*ones(1,N/4-1)]; end
if (isygnal==3) x = [A*ones(1,N/8) 0 -A*ones(1,5*N/8-1) 0 A*ones(1,2*N/8-1)]; end
if (isygnal==4) x = (A/T)*t; end  % pila
if (isygnal==5) x = [(2*A/T)*t(1:N/2+1) (2*A/T)*t(N/2:-1:2)]; end  % trojkat
if (isygnal==6) x = sin(2*pi*t/T); end

% nowe sygnaly z tabeli 3-1
if (isygnal==7)  % prostokatny unipolarny wypelnienie 1/2 (rys 3.1b)
    x = [A*ones(1,N/2) zeros(1,N/2)];
end
if (isygnal==8)  % trojkatny bipolarny 1 (rys 3.1d)
    x = [4*A/T*t(1:N/4) A-4*A/T*(t(N/4+1:3*N/4)-T/4) -A+4*A/T*(t(3*N/4+1:N)-3*T/4)];
end
if (isygnal==9)  % sinusoidalny wyprostowany dwupolowkowo (rys 3.1h)
    x = abs(A*sin(2*pi*t/T));
end
if (isygnal==10) % sinusoidalny wyprostowany jednopolowkowo (rys 3.1i)
    x = A*sin(2*pi*t/T);
    x(x<0) = 0;
end

figure(1);
plot(t, x, 'LineWidth', 2); grid; 
title(['Sygnal analizowany nr ' num2str(isygnal)]); 
xlabel('czas [sek]');
pause

%% 3. Wyznaczenie wspolczynnikow numerycznych (z probek sygnalu)
for k = 0:NF-1
    ck = cos(2*pi*k*f0*t);
    sk = sin(2*pi*k*f0*t);
    a_num(k+1) = sum(x.*ck)/N;  % wspolczynnik kosinusa numeryczny
    b_num(k+1) = sum(x.*sk)/N;  % wspolczynnik sinusa numeryczny
end

%% 4. Wyznaczenie wspolczynnikow analitycznych (ze wzorow z tabeli 3-1)
a_an = zeros(1, NF);
b_an = zeros(1, NF);

if (isygnal==1)  % prostokatny bipolarny (rys 3.1a)
    % x(t) = 4A/pi * (sin(w0*t) + 1/3*sin(3w0*t) + 1/5*sin(5w0*t) + ...)
    % tylko sinusy, nieparzyste harmoniczne
    for k = 1:2:NF-1
        b_an(k+1) = (4*A)/(pi*k);
    end
end

if (isygnal==4)  % pila - trojkatny unipolarny 2 (rys 3.1g)
    % x(t) = A/2 - A/pi * sum(sin(k*w0*t)/k)
    a_an(1) = A/2;
    for k = 1:NF-1
        b_an(k+1) = -A/(pi*k);
    end
end

if (isygnal==5)  % trojkat - trojkatny bipolarny 2 (rys 3.1e)
    % x(t) = 8A/pi^2 * (sin(w0*t) - 1/9*sin(3w0*t) + 1/25*sin(5w0*t) - ...)
    % tylko nieparzyste harmoniczne
    for k = 1:2:NF-1
        b_an(k+1) = (8*A)/(pi^2 * k^2) * (-1)^((k-1)/2);
    end
end

if (isygnal==6)  % sinus - tylko pierwsza harmoniczna
    b_an(2) = A;  % sin(w0*t) ma wspolczynnik A
end

if (isygnal==7)  % prostokatny unipolarny wypelnienie 1/2 (rys 3.1b)
    % x(t) = A/2 + 2A/pi * (cos(w0*t) - 1/3*cos(3w0*t) + 1/5*cos(5w0*t) - ...)
    a_an(1) = A/2;
    for k = 1:2:NF-1
        a_an(k+1) = (2*A)/(pi*k) * (-1)^((k-1)/2);
    end
end

if (isygnal==8)  % trojkatny bipolarny 1 (rys 3.1d)
    % x(t) = 8A/pi^2 * (sin(w0*t) - 1/9*sin(3w0*t) + 1/25*sin(5w0*t) - ...)
    for k = 1:2:NF-1
        b_an(k+1) = (8*A)/(pi^2 * k^2) * (-1)^((k-1)/2);
    end
end

if (isygnal==9)  % sinusoidalny wyprostowany dwupolowkowo (rys 3.1h)
    % x(t) = 2A/pi - 4A/pi * sum(cos(2k*w0*t)/(4k^2-1))
    a_an(1) = 2*A/pi;
    for k = 1:NF-1
        if mod(k,2) == 0  % tylko parzyste harmoniczne
            a_an(k+1) = -4*A/(pi*(k^2-1));
        end
    end
end

if (isygnal==10) % sinusoidalny wyprostowany jednopolowkowo (rys 3.1i)
    % x(t) = A/pi + A/2*sin(w0*t) - 2A/pi * sum(cos(2k*w0*t)/(4k^2-1))
    a_an(1) = A/pi;
    b_an(2) = A/2;  % pierwsza harmoniczna sinusa
    for k = 2:2:NF-1  % parzyste harmoniczne
        a_an(k+1) = -2*A/(pi*(k^2-1));
    end
end

%% 5. Porownanie wspolczynnikow numerycznych i analitycznych
f = 0 : f0 : (NF-1)*f0;

figure(2);
subplot(211); stem(f, a_num, 'filled', 'b'); hold on;
stem(f, a_an, 'r', 'LineWidth', 1.5); hold off;
xlabel('[Hz]'); title('Wspolczynniki cos: numeryczne (niebieskie) vs analityczne (czerwone)');
legend('numeryczne', 'analityczne'); xlim([0 20*f0]);

subplot(212); stem(f, b_num, 'filled', 'b'); hold on;
stem(f, b_an, 'r', 'LineWidth', 1.5); hold off;
xlabel('[Hz]'); title('Wspolczynniki sin: numeryczne (niebieskie) vs analityczne (czerwone)');
legend('numeryczne', 'analityczne'); xlim([0 20*f0]);
pause

figure(3);
subplot(211); plot(f, a_num - a_an); grid; 
xlabel('[Hz]'); title('Roznica cos: numeryczne - analityczne');
subplot(212); plot(f, b_num - b_an); grid; 
xlabel('[Hz]'); title('Roznica sin: numeryczne - analityczne');
pause

%% 6. Porownanie z DFT
X = fft(x, N)/N;
X = conj(X);

figure(4);
subplot(211); plot(f, a_num - real(X(1:NF))); grid; 
title('Roznica z DFT - COS');
subplot(212); plot(f, b_num - imag(X(1:NF))); grid; 
title('Roznica z DFT - SIN');
pause

%% 7. Synteza sygnalu ze wspolczynnikow (zad1)
% UWAGA: wspolczynniki analityczne z tabeli zakladaja okreslona symetrie sygnalu
% dlatego dla syntezy uzywamy wspolczynnikow numerycznych obliczonych z probek
figure(5);
subplot(111);

a_syn = a_num;
b_syn = b_num;
a_syn(1) = a_syn(1)/2;

y = zeros(1, N);

for k = 0:NF-1
    y = y + 2*a_syn(k+1)*cos(2*pi*k*f0*t) + 2*b_syn(k+1)*sin(2*pi*k*f0*t);
    err_maxabs(k+1) = max(abs(y - x));
    
    if k < 20 || mod(k, 50) == 0
        plot(t, y, 'b', t, x, 'r--', 'LineWidth', 1.5); grid;
        title(['Synteza - ' num2str(k+1) ' harmonicznych, blad = ' num2str(err_maxabs(k+1), '%3.4f')]);
        xlabel('czas [sek]');
        legend('synteza', 'oryginal');
        drawnow
    end
end
pause

figure(6);
plot(t, y - x, '.-'); grid; 
title('Sygnal bledu (synteza analityczna - oryginal)'); 
xlabel('czas [sek]');
pause

figure(7);
plot(err_maxabs, '.-r'); grid;
xlabel('Liczba wspolczynnikow szeregu Fouriera');
ylabel('Blad maksymalny');
title('Blad syntezy w zaleznosci od liczby harmonicznych');
axis tight;

% wspolczynniki analityczne daja taki sam wynik jak numeryczne
% roznica wynika tylko z dokladnosci obliczen numerycznych