%BS gain
Gamma_B=10E3;
gain_0=1/Gamma_B*10;
Omega_B=2*pi*fsignal;
Omega=2*pi*(freq_sweep);
gain=gain_0*(Gamma_B/2)^2./((Omega_B-Omega).^2+(Gamma_B/2)^2);
plot(freq_sweep,gain);

% Omega_m=2*pi*fsignal;
% Omega=2*pi*(freq_sweep);
% Gamma_m=10E3;
% Gain=1./(Omega_m^2-Omega.^2+1i*Gamma_m*Omega);
% plot(freq_sweep,Gain)
