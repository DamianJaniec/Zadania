% problem 3.3 - macierz ortogonalna transformacji DCT-IV
clear all; close all; clc;

%% generowanie macierzy DCT-IV dla N=25
N = 25;

for k = 0:N-1
    A(k+1, 1:N) = sqrt(2/N) * cos(pi/N * (k+1/2) * ((0:N-1)+1/2));
end

%% rysowanie wierszy macierzy w petli - funkcje bazowe
figure;
for k = 1:N
    subplot(5, 5, k);
    plot(A(k, :), 'b-');
    title(['k=' num2str(k-1)]);
    % widac rosnaca liczbe oscylacji kosinusa
end

%% sprawdzenie ortogonalnosci 5 losowych par wierszy
disp('ortogonalnosc 5 losowych par wierszy:');
for i = 1:5
    idx = randperm(N, 2);
    iloczyn = dot(A(idx(1), :), A(idx(2), :));
    disp(['  wiersze ' num2str(idx(1)-1) ' i ' num2str(idx(2)-1) ': ' num2str(iloczyn)]);
end
% wyniki bliskie zeru, wiec wiersze sa ortogonalne

%% czy wiersze sa ortogonalne same do siebie
disp(' ');
disp('wiersz z samym soba:');
disp(['  wiersz 0: ' num2str(dot(A(1,:), A(1,:)))]);
% wynik = 1, wiec NIE sa ortogonalne same do siebie, sa unormowane

%% porownanie inv(A) z A'
disp(' ');
disp('max roznica inv(A) vs A'':');
disp(['  ' num2str(max(max(abs(inv(A) - A'))))]);
% roznica bliska 0, wiec inv(A) = A'

%% porownanie inv(A)*A oraz A'*A
disp(' ');
disp('max roznica inv(A)*A vs eye(N):');
disp(['  ' num2str(max(max(abs(inv(A)*A - eye(N)))))]);

disp(' ');
disp('max roznica A''*A vs eye(N):');
disp(['  ' num2str(max(max(abs(A'*A - eye(N)))))]);
% oba wyniki bliskie 0, wiec otrzymujemy macierz identycznosciowa