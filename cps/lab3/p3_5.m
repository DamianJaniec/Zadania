% cps03_trans.m
clear all; close all
% Orthogonal matrix for DCT-IV orthogonal transform
N = 100;                                    % wymiar macierzy kwadratowej, 25, 100
k = (0:N-1); n=(0:N-1);                     % k-kolumny/funkcje, n-wiersze/probki
S = sqrt(2/N)*cos(pi/N*(n'+1/2)*(k+1/2));   % macierz syntezy
A = S';                                     % macierz analizy: transpozycja i sprzezenie S
% S*A, pause % sprawdzenie ortogonalnosci: macierz z jedynkami na przekatnej?
if norm(S'*S - eye(size(S)), 'fro') < 1e-12
    fprintf("macierz jest ortagonalna");
else
    fprintf("Macierz nie jest ortagonalna");
end
pause();
x1 = 10*S(:,5);                                                 % sygnal #1
x2 = 20*S(:,10);                                                % sygnal #2
x3 = 30*sqrt(2/N)*cos(pi/N*(n' +1/2)*(10.5+1/2) );              % sygnal #3
x4 = 30*sqrt(2/N)*cos(pi/N*(n'+N/4+1/2)*(10 +1/2) );            % sygnal #4
x5 = randn(1,N);                                                % sygnal #5
x = x1;                                                  % wybor x1, x2, x3, x4, x1+x2, x1+x3, x1+x4
figure; plot(x,'bo-'); title('x(n)'); grid;                     % rysunek sygnalu wejsciowego
c = A*x;                                                        % analiza sygnalu: wyznaczenie wspolczynnikow transformacji
figure; stem(c); grid;                                          % pokazanie wspolczynnikow transformacji
%c(5) = 0;                                                      % opcjonalne usuniecie skladowej x3 z sygnalu
y = S*c;                                                        % synteza sygnalu: suma przeskalowanych funkcji bazowych
figure; plot(y,'bo-'); title('y(n)'); grid;                     % rysunek sygnalu wyjsciowego
error = max(abs(x.'-y));                                        % blad odtworzenia/rekonstrukcji sygnalu
pause();
Xs = {x1, x1+x2, x3, x4, x5};
Xs_title = {"x1","x1+x2","x3","x4","x5"};
Ys_title = {"y1","y1+y2","y3","y4","y5"};
Err = ones(5,1);
figure(4);
hold on; grid on;
for i = 0:length(Xs)-1
    subplot(5,3,i*3+1);
    plot(Xs{i+1},'bo-'); title(Xs_title{i+1}); grid;
    c = A*Xs{i+1}(:);  % (: ) konwertuje dowolny wektor do kolumny
    subplot(5,3,i*3+2);
    stem(c); grid; title("Widmo sygnału: "+Xs_title{i+1});
    y = S*c;
    subplot(5,3,i*3+3);
    plot(y,'bo-'); title(Ys_title{i+1}); grid;
    
    Err(i+1) = max(abs(Xs{i+1}(:) - y));  % (: ) konwertuje dowolny wektor na kolumnę
end
display(Err);
%Wnioski:
%{
    x1 - sygnał jest żywcem wyjęty z naszej macierzy, więc analiza widma
         pokazuje dosłownie, jeden nie zerowy punkt, współrzędne punktu
         x(5,10) wskazują na 5 kolumne naszej macierzy oraz że jej
         amplituda wynosi 10
    x1 + x2 - tutaj są aż dwa punkty nie zerowe, które odpowiednio nam
    podpowiadają że sygnał składa się z x1 oraz x2
    x3 - tutaj mamy trochę większy problem - ponieważ sygnał x3 nie
    występuije w naszej macierzy stąd "rozmycie"/"rozwarstwienie" (?)
    natomiast nasze punkty niezerowe, są największe w "okolicach"
    "częstotliwości" 10.5 - (nie jest idealnie po środku) ale możemy
    przypuszczać jak wygląda x3
    x4 - widmo przypomina widmo sygnału x3, ale z innego powodu,
    częstotliwość sygnału jest taka sama ja x2, ale jest przesunięta w
    faziem DCT nie ma możliwości "idealnego" owzorowania sygnału z dowolną
    fazą, (DCT "dopasowywuje" do sygnału z zerową fazą) - dlatego nasze
    widmo jest rozmyte
    x5 - szum, tutaj nie mamy żadnej stuktury
%}