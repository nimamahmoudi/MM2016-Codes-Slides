%% Clear Workspace Variables
clc, clear all, close all

%% Add Paths
addpath('butterworthbpf');

%% Read Image
a = imread('lena.bmp');
b = a;
figure
imshow(b)

%% Perform FFT2 (2-Dimensional FFT)
% [xx,yy] = meshgrid(1:512,1:512);
% tmp = (-1).^(xx+yy);
% tmpImage = im2double(b).*tmp;
c=fft2(b);
c=fftshift(c);
figure
x=log(1+abs(c));
imshow(x/max(max(x)))

%%
r=60;
d=max(max(c));
for i=1:512
    for j=1:512
        if sqrt(((i-512/2)^2)+((j-512/2)^2))>r
            c(i,j)=0;
        end
    end
end
figure
imshow(log(abs(c)))
%%
figure
c = ifftshift(c);
e=ifft2(c);
e = real(e)/255;
imshow(e)
figure
%h=fspecial('gaussian',300)
h=butterworthbpf(b,60,Inf,1);