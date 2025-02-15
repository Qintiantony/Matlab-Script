%Matlab script for DSP
fs=1E9;
fc=200E12;
fsignal=100E6;
%lowpass_freq=100000;
fs_r=10000E3;
FIRLPF=dsp.LowpassFilter('SampleRate',fs_r,'FilterType','FIR','PassbandFrequency',10E4,'StopbandFrequency',11E4);

fm=50E3;
A0=1;
mdepth_signal=5E-1;
mdepth_pump=15E-3;
mdepth_probe=4E-2;
t=0:1/fs:20000E-6;
t_r=0:1/fs_r:20000E-6;
freq_sweep=(-100E3:0.5E3:100E3)+fsignal;
N = length(t);
frame=0;
Rout=zeros(1,length(freq_sweep));
Rout_x=(freq_sweep-fsignal)/1000;

%Brillouin Gain
Gamma_B=10E3;
gain_0=1/Gamma_B*10;
Omega_B=2*pi*fsignal;
Omega=2*pi*(freq_sweep);
gain=-gain_0*(Gamma_B/2)^2./((Omega_B-Omega).^2+(Gamma_B/2)^2);

%Wave generation
for fprobe=freq_sweep
noise=randn(1,N)*100E3;
E_pump=2*exp(1i*2*pi*(fc+noise).*t);
E_pump=E_pump.*(1-mdepth_pump+mdepth_pump*sin(2*pi*fm*t));
noise2=randn(1,N)*20;
E_signal=0.6*exp(1i*2*pi*(fc+noise+noise2-fsignal).*t);
E_signal=E_signal.*(1-mdepth_signal+mdepth_signal*sin(2*pi*fm*t));
E_probe=E_pump.*(1-mdepth_probe-gain(frame+1)+(mdepth_probe+gain(frame+1)).*sin(2.*pi.*fprobe.*t));
E_total=E_probe+E_signal;
wave1=E_total.*conj(E_total);
figure;
%subplot(2,1,1);
%plot(t(1000:100000),E_total(1000:100000));

xdft = fft(wave1);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = (0:fs/N:fs/2)/1E6;

fstop=fsignal+100E3;
len_stop=round(N/fs*fstop);
fstart=fsignal-100E3;
len_start=round(N/fs*fstart)+1;
subplot(2,1,1);
plot(freq(len_start:len_stop),10*log10(psdx(len_start:len_stop)));
axis([fstart/1E6 fstop/1E6 -150 -20]);
grid on
title('Periodogram Using FFT')
xlabel('Frequency (MHz)')
ylabel('Power/Frequency (dB/Hz)')
frame=frame+1
%saveas(gcf,['E:\Matlab Script\image\freq',num2str(frame),'.jpg']);
%close;

%Lock-in amplifier
reference_signal1=cos(2*pi*fm*t);
wave_x=wave1.*reference_signal1;
%wave_x=resample(wave_x,fs_r,fs);
%wave_x=step(FIRLPF,wave_x);
reference_signal2=sin(2*pi*fm*t);
wave_y=wave1.*reference_signal2;
%wave_y=resample(wave_y,fs_r,fs);
%wave_y=step(FIRLPF,wave_y);
wave_R=(wave_x.^2+wave_y.^2).^0.5;
Rout(frame)=mean(wave_R);
if frame==1
    Rref=Rout(frame);
end
Rout(frame)=Rout(frame)-Rref;
%wave_theta=atan(wave_y./wave_x);
%figure;
%plot(t,wave_R);
subplot(2,1,2);
plot(Rout_x,Rout)
title('Output of Lock-in Amplifier')
xlabel('Frequency (kHz)')
ylabel('R')
%xlim([freq_sweep(1)-fsignal freq_sweep(length(freq_sweep))-fsignal]);
ylim([-10E-3 10E-3]);
saveas(gcf,[pwd,'\image\LIA',num2str(frame),'.jpg']);
close;
end

