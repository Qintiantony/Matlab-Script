%Matlab script for DSP
f_c=2E12;
Wave_Pump=dsp.SineWave();
Fs=2E9;
Wave1=dsp.SineWave();
Wave1.SamplesPerFrame=1000;
y=Wave1();
plot(y);