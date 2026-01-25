function Y = myRecIFFT(x, dir, do_normalize)
% Uniwersalna funkcja FFT/IFFT z algorytmem Radix-2 DIT
% x   - wektor wejściowy
% dir = -1  -> FFT
% dir = +1  -> IFFT

%% Przy pierwszym wywołaniu (2 argumenty) - ustawiamy normalizację
if nargin < 3 %"nargin" = "nargin of argument input"
    do_normalize = (dir == 1);  % Normalizujemy tylko dla IFFT
end

N = length(x);

if (N == 2)
    Y(1) = x(1) + x(2);
    Y(2) = x(1) - x(2);
else
    % Rekurencja bez normalizacji (do_normalize = false)
    Y1 = myRecIFFT(x(1:2:N), dir, false);
    Y2 = myRecIFFT(x(2:2:N), dir, false);
    W = exp(dir * j * 2 * pi / N * (0:N-1));
    Y = [Y1, Y1] + W .* [Y2, Y2];
end

%% Normalizacja TYLKO raz, na końcu pierwszego wywołania
if do_normalize
    Y = Y / N;
end
end