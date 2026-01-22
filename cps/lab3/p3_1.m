close all;
clear all;
clc;

%x1 = [1 1 1 1];
%x2 = [1 -1 1 -1];
%x3 = [1 1 -1 -1];
%x4 = [1 -1 -1 1];

A = [1 1 1 1;
     1 -1 1 -1;
     1 1 -1 -1;
     1 -1 -1 1];

A = 1/sqrt(4)*A;

fprintf("===========Ortagonalność============\n");
fprintf("Kolumny: \n");

for i = 1:3
    a = sum(A(:,i).*A(:,i+1));
    if(a==0)
        fprintf("Wektor %d i wektor %d sa ortagonalne\n",i,i+1);
    else
        fprintf("Wektor %d i wektor %d NIE sa ortagonalne\n",i,i+1);
    end
end

fprintf("Wiersze \n");

for i = 1:3
    a = sum(A(i,:).*A(i+1,:));
    if(a==0)
        fprintf("Wektor  %d i wektor %d sa ortagonalne\n",i,i+1);
    else
        fprintf("Wektor %d i wektor %d NIE sa ortagonalne\n",i,i+1);
    end
end
%wszędzie wychodzi zero, więc wektory są wzajmenie są ortagonalne

fprintf("============Unormowanie==============\n");
fprintf("Kolumny: \n");

for i = 1:4
    b = sum(A(:,i).*A(:,i));
    if(b==1)
        fprintf("Wektor %d jest unormowany\n",i);
    else
        fprintf("Wektor %d NIE jest unormowany\n",i);
    end
end

fprintf("Wiersze: \n");

for i = 1:4
    b = sum(A(i,:).*A(i,:));
    if(b==1)
        fprintf("Wektor %d jest unormowany\n",i);
    else
        fprintf("Wektor %d NIE jest unormowany\n",i);
    end
end
%wszedzie jest 1 wiec wektory sa unormowane



display(inv(A))
display(A')


if((A')==inv(A))
    fprintf("Macierz A' jest taka sama jak macierz inv(A)\n");
else
    fprintf("Macierz A' NIE jest taka sama jak macierz inv(A)\n");
end


