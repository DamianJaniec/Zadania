clear all; close all;
fs=100; Nx=1000;                   %czestotliwoscprobkowania, liczbaprobek
dt = 1/fs;                         % okresprobkowania
t =dt*(0:Nx-1);                    % chwilepobieraniaprobek
x1=sin(2*pi*10*t);                 % sinus 10 Hz
x2=sin(2*pi*1*t);                  % sinus 1 Hz
x3=exp(-5*t);                      %eksponentaopadajaca w czasie
x4=exp(-25*(t-0.5).^2);            %gaussoida
x5=sin(2*pi*(0*t+0.5*20*t.^2));    % liniowyprzyrostczest. (LFM): od 0 Hz, +20Hz/s
x6=sin(2*pi*(10*t-(9/(2*pi*1)*cos(2*pi*1*t)))); % sinus. FM: 9Hz wokol 10Hz 1x na sec
x7=sin(2*pi*(10*t+9*cumsum(x2)*dt));
% tosamoco x6;dlaczego?
x =x1;
% wybor: x1,x2,...,x7, 0.23*x1 + x2, x1.*x3, ...
%plot(t,x,'o-'); grid; title('Sygnal x(t)'); xlabel('czas [s]'); ylabel('Amplituda');

kol = 'k-';
figure(1)
subplot(7,1,1);
plot(t,x1,kol); grid; title('Sygnal x1(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(7,1,2);
plot(t,x2,kol); grid; title('Sygnal x2(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(7,1,3);
plot(t,x3,kol); grid; title('Sygnal x3(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(7,1,4);
plot(t,x4,kol); grid; title('Sygnal x4(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(7,1,5);
plot(t,x5,kol); grid; title('Sygnal x5(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(7,1,6);
plot(t,x6,kol); grid; title('Sygnal x6(t)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(7,1,7);
plot(t,x7,kol); grid; title('Sygnal x7(t)'); xlabel('czas [s]'); ylabel('Amplituda');
sgtitle("Sygnały podane w zadaniu");


pause();
figure(2)
subplot(3,1,1);
plot(t,(0.25*x1+2*x2),kol); grid; title('Sygnal (0.25*x1+2*x2)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(3,1,2);
plot(t,(0.5*x2+3*x3),kol); grid; title('Sygnal (0.5*x2+3*x3)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(3,1,3);
plot(t,(6*x4+x1),kol); grid; title('Sygnal (6*x4+x1)'); xlabel('czas [s]'); ylabel('Amplituda');
sgtitle("Sygnały addytwyne")

%Po dodaniu sygnałów powstaje nowy przebieg, 
%który łączy kształty sygnałów składowych. 
%W miejscach, gdzie sygnały mają zgodne fazy, 
%amplituda rośnie, a gdzie są przeciwne – zmniejsza się.

pause();
figure(3)
subplot(6,1,1);
plot(t,((1+0.5*x2).*x1),kol); grid; title('Sygnal ((1+0.5*x2).*x1)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(6,1,2);
plot(t,(x2.*x1),kol); grid; title('Sygnal (x2.*x1)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(6,1,3);
plot(t,(x3.*x1),kol); grid; title('Sygnal (x3.*x1)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(6,1,4);
plot(t,(x4.*x1),kol); grid; title('Sygnal (x4.*x1)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(6,1,5);
plot(t,((1+0.5*x2).*x5),kol); grid; title('Sygnal ((1+0.5*x2).*x5)'); xlabel('czas [s]'); ylabel('Amplituda');
subplot(6,1,6);
plot(t,((1+0.5*x2).*x6),kol); grid; title('Sygnal ((1+0.5*x2).*x6)'); xlabel('czas [s]'); ylabel('Amplituda');
sgtitle("Sygnały multipikatywne");

%w tym przypadku jeżeli przynajmniej 1 sygnałów jest bliski zera
%sygnał wynikowy jest tłumiony 
%na dwóch ostatnich wykresach możemy zaobserować zmianę


%na niektórych wykresach (zaczynając od pierwszego bloku)
%możemy zobaczyć że sygnał zmienia częstotliwość
%jest to spowodowane, że nie które sygnały nie mają stałej fazy
%częstotliwość chwilowa jest pochodną od przesunięcia fazowego
%więc jeżeli faza jest stała, albo funkcją liniową 
%nie zaobserowujemy tego zjawiska
%ale dla niektórych sygnałów (x5,x6,x7), zmiana częstotliwości
%nastąpi np. w x5 w sposób liniowy


%Dwie ostatnie sinusoidy sa jednoczesnie zmodulowane w amplitudzie (AM)
% i czestotliwosci (FM). Przesledz zmiane
%wartosci amplitudy i czestotliwosci sygnału w czasie

%w ostatnich dwóch sygnałach amplituda zmienia się w czasię
%sinusoidalnie - przez co sygnał wygląda jak "wypełniona 
%sinsuida" (?) od sygnału (x2)
%z kolei częstotliwość przypomina drugi składnik sygnału (x5,x6)
















