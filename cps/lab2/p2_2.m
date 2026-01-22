% cps_01_sinus.m
clear all; close all;
fpr=1000; Nx=10*fpr;                % parametry: czestotliwosc probkowania, liczba probek
dt = 1/fpr;                         % okres probkowania
n = 0 : Nx-1;                       % numery probek
t = dt*n;                           % chwile probkowania
A1=1; f1=1; p1=0;                    % sinusoida: amplituda, czestotliwosc, faza
%x1 = A1*sin(2*pi*f1 *t+p1);         % pierwszy skladnik sygnalu
df=200;
%x1 = A1*sin(2*pi*f1*df*t.^2 + p1);
x1=cos(2*pi*(0*t+0.5*df*t.^2));

kol = 'k-';

subplot(2,2,1);
plot(t,x1,kol); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');
subplot(2,2,2);
plot(t,x1,kol); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');
spectrogram(x1,256,256-64,512,fpr);
pause();

%Zapoznaj si˛e z kształtem sygnału. Wytłumacz dlaczego
%powtarza si˛e on okresowo: przecie˙z cz˛estotliwo´s´c 
%synału jest inna, coraz wi˛eksza.

%ponieważ sygnał zwiększa swoją częstotliwość
%ale nie ma ustalonej granicy
%więc bardzo szybko wykracza poza nasz zakres "probkowania"
%dla naszego próbkowania 1000Hz
%granica sygnału to 200Hz
%więc już po 2.5 sekundach sygnał staje sie nierozróżnialny

fpr=8000; Nx=10*fpr;
dt = 1/fpr;
n = 0 : Nx-1;
t = dt*n;
A1=1; f1=1; p1=0;
df=2000;
x1=cos(2*pi*(0*t+0.5*df*t.^2));

subplot(2,2,3);
plot(t,x1,kol); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');
pause();
sound(x1,fpr);
pause();
subplot(2,2,4);
plot(t,x1,kol); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');
spectrogram(x1,256,256-64,512,fpr);


%w tym przypadku fpr=8000Hz
%czyli granica rozróżnialności to 4000Hz
%a zmiana df=2000Hz - wiec
%sygnal stanie sie nie rozroznialny po 2 sekundach
%na wykresie widzimy wyraźne "przerwy" wlasnie w 4 i 8 sekundzie
%po odsluchaniu słychać że sygnał "rośnie" przez 2 sekudny
%a później "maleje" przez kolejne dwie (dalej sygnał się zapętla)

%Wywołaj funkcj˛e Matlaba: spectrogram(x,256,256-64,512,fpr),
% która pokazuje zmian˛e cz˛estotliwo´sci sygnału 
% w czasie. Czy zgadzasz sie˛ ze zmiennos´cia˛
% cze˛stotliwos´ci na rysunku? Przeciez˙ 
% sam wygenerowałes´ sygnał i wiesz jaka ona jest 
% w ka˙zdej chwili!

%jeżelibyśmy zwiększyli częstotliwość próbkowania
%dla pierwszego sygnału do 4000Hz
%dla drugiego sygnału do 40kHz
%to na spektogramie zobaczybyśmy przekątną

%linia ze spektogramu przedstawia chwilą częstotliwość
%sygnału zmierzonego, dlatego przy pierwszym sygnale
%"odbija się" co 2.5 sekundy
%a w przypadku drugiego co 2 sekundy