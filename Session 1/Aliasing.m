fs=40000;
x=0:1:1/16*fs;
f=6200;
y0=sin((2*pi*f/fs)*x);
figure;plot(x,y0)
f=12400;
y1=sin((2*pi*f/fs)*x);
figure;
plot(x,y1)
y=y0+y1;
figure;plot(x,y0)
figure;spectrogram(y,[],[],[],40E3,'yaxis')
y2=downsample(y,4); %fs=10000Hz
figure;spectrogram(y2,[],[],[],10E3,'yaxis')
y3=downsample(y,8); %fs=5000Hz
figure;spectrogram(y3,[],[],[],5E3,'yaxis')
wavwrite(y,40000,'2sinus.wav')
wavwrite(y2,10000,'2sinus_alias10000.wav')
wavwrite(y3,5000,'2sinus_alias5000.wav')
wavplay(y,40000);
wavplay(y2,10000)
wavplay(y3,5000)