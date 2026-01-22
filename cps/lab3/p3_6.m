% cps03_trans.m
clear all; close all
% Orthogonal matrix for DCT-IV orthogonal transform
N = 100;                                    % wymiar macierzy kwadratowej, 25, 100
k = (0:N-1); n=(0:N-1);                     % k-kolumny/funkcje, n-wiersze/probki
S = sqrt(2/N)*cos(pi/N*(n'+1/2)*(k+1/2));   % macierz syntezy
A = S';                                     % macierz analizy: transpozycja i sprzezenie S
                                               % wybor x1, x2, x3, x4, x1+x2, x1+x3, x1+x4

%sprawdzenie ortogonalnosci oraz analiza poszczególnych sygnałów,
%zrobilśmy w poprzednim zadaniu, żeby się nie potrzebnie nie powtarzać,
%tutaj tego nie ma

figure;
k_values = [9, 9.5, 10, 10.25, 10.5, 10.75, 11];   % zakres z polecenia

for i = 1:length(k_values)
    kval = k_values(i);

    % sygnał z zadaną częstotliwością (zmieniamy k)
    xk = 30*sqrt(2/N) * cos(pi/N*(n' + 1/2)*(kval + 1/2));

    ck = A*xk;   % widmo DCT

    subplot(length(k_values),1,i);
    stem(ck,'filled');
    title("Widmo dla k = " + num2str(kval));
    grid on;
end

pause();

figure;
shift_values = [0, 0.5, 1, 10, N/4];   % zgodnie z poleceniem

for i = 1:length(shift_values)
    shift = shift_values(i);

    % nowy wektor n' przesunięty w czasie
    n_shifted = n' + shift;

    % sygnał o częstotliwości 10, ale z modyfikacją n'
    x_shift = 30*sqrt(2/N) * cos(pi/N * (n_shifted + 1/2) * (10 + 1/2));

    c_shift = A * x_shift;

    subplot(length(shift_values),1,i);
    stem(c_shift,'filled');
    title("Widmo dla n' = " + num2str(shift));
    grid on;
end
% Wnioski dla zmiennych częstotliwości:
%{
%   Dla całkowitych wartości k (np k 9 10 11) widmo DCT jest "ostre" i
%   energia sygnału skupia się w jednym współczynniku a dla wartości niecałkowitych
%   (np k 9.5 10.25 10.5 10.75) energia sygnału rozlewa się na kilka
%   współczynników -widmo staje się "rozmyte" DCT najlepiej reprezentuje
%   sygnały które idealnie pasują do jej bazy czyli w naszym przypadku "całkowitych" k
%}

% Wnioski:
%{
%   Dla n' =0 widmo DCT jest "ostre" bo sygnał idealnie trafia w bazę DCT
%   Każde przesunięcie (0.5 1 10 N/4) powoduje "rozmycie" bo zmienia się faza
%   i energia rozlewa się na wiele współczynników DCT nie radzi sobie idealnie
%   z sygnałami przesuniętymi w czasie ,im większe przesunięcie tym mniej
%   kompaktowe widmo
%}