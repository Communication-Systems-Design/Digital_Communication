%%%%%%%%%%%%%%%%%%%%%%%%%%??? ???? ?????? ??????%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Initialization
clear;clc
close all;
%% Execution Time for DFT Function
L=2048;
n=((0:L-1)/L)*2*pi;
x=cos(n);
N=L;
K=[0:N-1];
tic;
X = dft(x,L,N);
toc;
plot(n,x);
figure();
stem(K,abs(X));
%% Execution time of FFT Function
tic;
Z=fft(x,N);
toc;
figure();
stem(K,abs(Z));