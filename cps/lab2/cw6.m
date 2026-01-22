% 1. Wprowadzenie danych
% Kolumna 'mm' - zmienna niezależna (X)
mm = [ -10.0; -9.5; -9.0; -8.5; -8.0; -7.5; -7.0; -6.5; -6.0; -5.5; -5.0; -4.5; -4.0; -3.5; -3.0; -2.5; -2.0; -1.5; -1.0; -0.5; 0.0; 0.5; 1.0; 1.5; 2.0; 2.5; 3.0; 3.5; 4.0; 4.5; 5.0; 5.5; 6.0; 6.5; 7.0; 7.5; 8.0; 8.5; 9.0; 9.5; 10.0 ];

% Kolumna 'mV' - zmienna zależna (Y)
mV = [ -1038; -987; -934; -883; -830; -779; -727; -674; -622; -598.7; -544.4; -490.4; -436; -381.5; -327.1; -272.9; -218.2; -163; -109.8; -55.3; 0; 57; 113.6; 160.8; 226.5; 283.1; 340.3; 395.8; 451.4; 507.8; 563.6; 620.2; 644; 699; 754; 808; 862; 916; 969; 1023; 1077 ];

% 2. Aproksymacja liniowa (wielomian 1. stopnia)
% p(1) to współczynnik kierunkowy, p(2) to wyraz wolny (przecięcie z osią Y)
p = polyfit(mm, mV, 1);

% 3. Obliczenie wartości prostej dla zakresu danych X
% Aproksymowana prosta to y_fit = p(1)*x + p(2)
y_fit = polyval(p, mm);

% 4. Wyświetlenie wykresu
figure; % Otwarcie nowego okna wykresu
hold on; % Utrzymanie wykresu do dodania kolejnych elementów

% Wykres danych (punkty)
plot(mm, mV, 'o', 'MarkerSize', 5, 'DisplayName', 'Dane pomiarowe');

% Wykres dopasowanej prostej (linia)
plot(mm, y_fit, '-', 'LineWidth', 2, 'DisplayName', sprintf('Aproksymacja liniowa: y = %.2f*x + %.2f', p(1), p(2)));

% Ustawienia wykresu dla lepszej czytelności
title('Aproksymacja Liniowa Danych');
xlabel('Położenie [mm]');
ylabel('Napięcie [mV]');
legend('show', 'Location', 'northwest');
grid on;
hold off;