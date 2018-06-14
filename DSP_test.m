%Matlab script for DSP
close all
figure;
fs=10E9;
fc=200E12;
fprobe=180E6;
fsignal=200E6;

fm=50E3;
A0=1;
mdepth_signal=1E-1;
mdepth_pump=1E-3;
mdepth_probe=1E-2;
t=0:1/fs:1000E-6;
N = length(t);
noise=randn(1,N)*100;

E_pump=2*exp(1i*2*pi*(fc+noise).*t);
E_pump=E_pump.*(1-mdepth_pump+mdepth_pump*sin(2*pi*fm*t));
E_signal=0.01*exp(1i*2*pi*(fc+noise*10+fsignal).*t);
E_signal=E_signal.*(1-mdepth_signal+mdepth_signal*sin(2*pi*fm*t));
E_probe=E_pump.*(1-mdepth_probe+mdepth_probe*sin(2*pi*fprobe*t));
E_total=E_probe+E_signal;
wave1=E_total.*conj(E_total);
subplot(2,1,1);
plot(t(1000:100000),E_total(1000:100000));

xdft = fft(wave1);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = (0:fs/N:fs/2)/1E6;

fstop=400E6;
len_stop=round(N/fs*fstop);
fstart=1;
len_start=round(N/fs*fstart)+1;
subplot(2,1,2);
plot(freq(len_start:len_stop),10*log10(psdx(len_start:len_stop)));
grid on
title('Periodogram Using FFT')
xlabel('Frequency (MHz)')
ylabel('Power/Frequency (dB/Hz)')

%Lock-in amplifier
reference_signal=sin(2*pi*fm*t);
wave_out=wave1.*reference_signal;
plot(t,wave_out);

