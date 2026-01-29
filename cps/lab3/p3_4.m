% problem 3.4 - macierze ortogonalne DST i Hartleya
clear all; close all; clc;

N = 25;
k = (0:N-1); 
n = (0:N-1);

%% macierz DST
A_DST = sqrt(2/(N+1)) * sin(pi*(k'+1)*(n+1)/(N+1));

%% macierz Hartleya
A_Hartley = sqrt(1/N) * (cos(2*pi/N*k'*n) + sin(2*pi/N*k'*n));

%% wyswietlenie wierszy macierzy DST
figure;
for k = 1:N
    subplot(5, 5, k);
    plot(A_DST(k, :), 'b-');
    title(['k=' num2str(k-1)]);
end
sgtitle('funkcje bazowe DST');
% widac sinusoidy o rosnacej czestotliwosci

%% wyswietlenie wierszy macierzy Hartleya
figure;
for k = 1:N
    subplot(5, 5, k);
    plot(A_Hartley(k, :), 'r-');
    title(['k=' num2str(k-1)]);
end
sgtitle('funkcje bazowe Hartleya');
% widac kombinacje sinusa i kosinusa

%% sprawdzenie ortogonalnosci wierszy DST
disp('=== DST ===');
disp('ortogonalnosc 5 losowych par wierszy:');
for i = 1:5
    idx = randperm(N, 2);
    iloczyn = dot(A_DST(idx(1), :), A_DST(idx(2), :));
    disp(['  wiersze ' num2str(idx(1)-1) ' i ' num2str(idx(2)-1) ': ' num2str(iloczyn)]);
end

%% sprawdzenie ortogonalnosci macierzy DST
disp(' ');
disp('ortogonalnosc macierzy DST:');
disp(['  max roznica inv(A)*A vs eye(N): ' num2str(max(max(abs(inv(A_DST)*A_DST - eye(N)))))]);
disp(['  max roznica A''*A vs eye(N): ' num2str(max(max(abs(A_DST'*A_DST - eye(N)))))]);

%% sprawdzenie ortogonalnosci wierszy Hartleya
disp(' ');
disp('=== HARTLEY ===');
disp('ortogonalnosc 5 losowych par wierszy:');
for i = 1:5
    idx = randperm(N, 2);
    iloczyn = dot(A_Hartley(idx(1), :), A_Hartley(idx(2), :));
    disp(['  wiersze ' num2str(idx(1)-1) ' i ' num2str(idx(2)-1) ': ' num2str(iloczyn)]);
end

%% sprawdzenie ortogonalnosci macierzy Hartleya
disp(' ');
disp('ortogonalnosc macierzy Hartleya:');
disp(['  max roznica inv(A)*A vs eye(N): ' num2str(max(max(abs(inv(A_Hartley)*A_Hartley - eye(N)))))]);
disp(['  max roznica A''*A vs eye(N): ' num2str(max(max(abs(A_Hartley'*A_Hartley - eye(N)))))]);
% obie macierze sa ortogonalne, wyniki bliskie zeru