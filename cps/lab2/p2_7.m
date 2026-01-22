function f = nuta(k, m)
    % k = oktawa
    % m = nuta 0..11
    fA = 27.5 * 2^k;     % częstotliwość A_k
    f  = fA * 2^(m/12);  % przesunięcie o m półtonów
end

fs = 44100;
t = 0:1/fs:(2/3);   % bo przy 90 BPM – 2/3 sekundy na nutę

x = [];

% Oktawy
k_values = [4 4 4 4 4 4 4 ...
            3 3 3 ...
            3 3 3 ...
            4 4 4 4 4 4 4 ...
            3 3 3 3 3];

% Nuty (m_values)
m_values = [7 9 7 5 4 5 7 ...
            2 4 5 4 5 7 ...
            7 9 7 5 4 5 7 ...
            2 7 4 0];

for i = 1:length(m_values)
    f1 = nuta(k_values(i), m_values(i));
    x = [x sin(2*pi*f1*t)];
end

sound(x, fs);


