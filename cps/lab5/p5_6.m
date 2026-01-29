% cps_05_fft2.m

% Algorytm radix-2 DIT (decimation in time) FFT
 clear all; close all; clc;
 N=16;                       % liczba probek sygnalu (potega dwojki)
 x=0:N-1;                   % przykladowy analizowany sygnal, np. inny wybor x=randn(1,N)
 Nbits = log2(N);           % liczba bitow potrzebna na indeksy probek, dla N=8, Nbits=3

 %[0 1 2 3 4 5 6 7 ]

 % 0 -> 000 -> 000 -> 0
 % 1 -> 001 -> 100 -> 4
 % 2 -> 010 -> 010 -> 2
 % 3 -> 011 -> 110 -> 6
 % 4 -> 100 -> 001 -> 1
 % 5 -> 101 -> 101 -> 5
 % 6 -> 110 -> 011 -> 3
 % 7 -> 111 -> 111 -> 7

 % [0 4 2 6 1 5 3 7]
 

% Napisz swój własny program na zmian˛e kolejno´sci próbek
y = zeros(1, N);           % pusty wektor

for n = 0 : N-1
    bity = dec2bin(n, Nbits);      
    bity_odwr = bity(Nbits:-1:1);  
    m = bin2dec(bity_odwr);        
    y(m+1) = x(n+1);               
end

y

%tworzenie z listing 5.3
n = 0:N-1; % indeksy WSZYSTKICH probek
m = dec2bin(n); % bity tych indeksow
m = m(:,Nbits:-1:1); % odwrocone bity
m = bin2dec(m); % nowe indeksy WSZYSTKICH probek
y1(m+1) = x(n+1); % przestawianie danych wejsciowych
y1,


err = max(abs(y1-y))