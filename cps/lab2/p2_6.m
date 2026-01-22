clear all; close all;
% --- ustawienia ogólne ---
fpr = 8000;            
Nx = 5 * fpr;          
dt = 1 / fpr;
t = (0:Nx-1) * dt;
N_krotkie = 4000;
t_krotkie = (0:N_krotkie)*dt;
function x = make_amfm(t,f0,kA,fA,kF,fF,A)
    mA = sin(2*pi*fA*t);          
    mF = sin(2*pi*fF*t);           
    A_t = A .* (1 + kA .* mA);      
    Phi = 2*pi*f0.*t + 2*pi*kF.*cumtrapz(t,mF); 
    x = A_t .* sin(Phi);
end


% 1) Wóz strażacki: 
f0_fire   = 600;   
kA_fire   = 0.5;   
fA_fire   = 2.0;   
kF_fire   = 400;   
fF_fire   = 1.2;   
A_base    = 1.0;

% 2) Karetka: 
f0_ambu   = 750;
kA_ambu   = 0.8;
fA_ambu   = 3.0;   
kF_ambu   = 200;
fF_ambu   = 2.0;

% 3) Policja: 
f0_pol    = 700;
kA_pol    = 0.35;
fA_pol    = 1.2;
kF_pol    = 500;   
fF_pol    = 3.0;   

% --- generacja sygnałów ---
x_fire  = make_amfm(t,f0_fire,kA_fire,fA_fire,kF_fire,fF_fire,A_base);
x_ambu  = make_amfm(t,f0_ambu,kA_ambu,fA_ambu,kF_ambu,fF_ambu,A_base);
x_pol   = make_amfm(t,f0_pol,kA_pol,fA_pol,kF_pol,fF_pol,A_base);

% --- normalizacja (zapobiega przesterom) ---
x_fire = 0.9 * x_fire / max(abs(x_fire));
x_ambu = 0.9 * x_ambu / max(abs(x_ambu));
x_pol  = 0.9 * x_pol  / max(abs(x_pol));

% --- złożenie sekwencji: fire -> 1s przerwy -> ambulance -> 1s przerwy -> police ---

display(t_krotkie);
kol = "-k";

figure(1);
subplot(3,1,1);
plot(t_krotkie,x_fire(1:N_krotkie+1),kol); grid; title('Sygnal wozu strażackiego w krotkim okresie'); xlabel('czas [s]'); ylabel('Amplituda');
sound(x_fire,fpr);
pause();

subplot(3,1,2);
plot(t_krotkie,x_ambu(1:N_krotkie+1),kol); grid; title('Sygnal ambulansu w krotkim okresie'); xlabel('czas [s]'); ylabel('Amplituda');
sound(x_ambu,fpr);
pause();

subplot(3,1,3);
plot(t_krotkie,x_pol(1:N_krotkie+1),kol); grid; title('Sygnal policji w krotkim okresie'); xlabel('czas [s]'); ylabel('Amplituda');
sound(x_pol,fpr);