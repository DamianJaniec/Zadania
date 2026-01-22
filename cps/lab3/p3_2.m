close all;
clear all;
clc;

%x1 = [1 1 1 1];
%x2 = [1 -1 1 -1];
%x3 = [1 1 -1 -1];
%x4 = [1 -1 -1 1];

A = [ 1  1  1  1  1  1  1  1;
      1  1  1  1 -1 -1 -1 -1;
      1  1 -1 -1  1  1 -1 -1;
      1  1 -1 -1 -1 -1  1  1;
      1 -1  1 -1  1 -1 -1  1;
      1 -1  1 -1 -1  1  1 -1;
      1 -1 -1  1 -1  1 -1  1;
      1 -1 -1  1  1 -1  1 -1 ];

A = 1/sqrt(8)*A;

tol = 1e-12; %toleracja bledu, po operacjach matematycznych

fprintf("===========Ortagonalność============\n");
fprintf("Kolumny: \n");

for i = 1:7
    a = sum(A(:,i).*A(:,i+1));
    if abs(a) < tol
        fprintf("Wektor %d i wektor %d sa ortagonalne\n",i,i+1);
    else
        fprintf("Wektor %d i wektor %d NIE sa ortagonalne\n",i,i+1);
    end
end

fprintf("Wiersze \n");

for i = 1:7
    a = sum(A(i,:).*A(i+1,:));
    if abs(a) < tol
        fprintf("Wektor  %d i wektor %d sa ortagonalne\n",i,i+1);
    else
        fprintf("Wektor %d i wektor %d NIE sa ortagonalne\n",i,i+1);
    end
end
%wszędzie wychodzi zero, więc wektory są wzajmenie są ortagonalne

fprintf("============Unormowanie==============\n");
fprintf("Kolumny: \n");

for i = 1:8
    b = sum(A(:,i).*A(:,i));
    if abs(b - 1) < tol
        fprintf("Wektor %d jest unormowany\n",i);
    else
        fprintf("Wektor %d NIE jest unormowany\n",i);
    end
end

fprintf("Wiersze: \n");

for i = 1:8
    b = sum(A(i,:).*A(i,:));
    if abs(b - 1) < tol
        fprintf("Wektor %d jest unormowany\n",i);
    else
        fprintf("Wektor %d NIE jest unormowany\n",i);
    end
end
%wszedzie jest 1 wiec wektory sa unormowane



display(inv(A))
display(A')


if max(max(abs(inv(A) - A'))) < 1e-12
    fprintf("Macierz A' jest taka sama jak macierz inv(A)\n");
else
    fprintf("Macierz A' NIE jest taka sama jak macierz inv(A)\n");
end

%Znajd´z w sieci informacje dotycz ˛ace dyskretnej transformacji Haara, Hadamarda,
 %Walsha, ..


 %poczytałem

 % Transformacje Haar, Hadamarda i Walsha służą do zamiany sygnału lub obrazu na inną postać, ułatwiającą analizę lub kompresję. 
% Wykorzystują proste wzory z wartościami +1 i -1 zamiast sinusów jak w transformacji Fouriera.
