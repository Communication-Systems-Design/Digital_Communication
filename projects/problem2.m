%%%%%%%%%%%%%%%%%%%%%%%%%%??? ???? ?????? ??????%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
clear;clc
close all;
rng(867);
%% Transmitter Model
N = 100; %Number of Samples
T=4;%total period of bitstream
Tb = T-1; %bit period
fc = 1; %Carrier frequency
n1=[0:N-1];%Samples
n=[0:(N*(1+Tb))-1];%Time
t=(n/(Tb+1));
%Generate Bit Stream
data=sign(randn(1,N));
data(data<0)=0;
bk=[data;repmat(zeros(1,Tb)',1,N)];
bk=bk(:);

%Polar NRZ Encoding
xk=bk;
xk(xk==0)=-1;

%Carrier phi(t)
n2=(n1/N)*2*pi*fc;
phi1 = sqrt(2/Tb)*cos(n2);

n2=(n/(N*(Tb+1)))*2*pi*fc;
phi = sqrt(2/Tb)*cos(n2);

%Sent Signal S(t)
s=xk.*phi';

figure();
subplot(6,1,1);
stem(n1,data);
title('Data');
xlabel('Sample no.');

subplot(6,1,2);
stem(t,bk);
title('BitStream');
xlabel('Time')

subplot(6,1,3);
stem(t,xk);
title('Polar NRZ Level Encoder');
xlabel('Time')

subplot(6,1,4);
plot(n1,phi1);
title('Carrier');
xlabel('Sample no.');

subplot(6,1,5);
plot((n/(Tb+1)),phi);
title('Carrier');
xlabel('Time');

subplot(6,1,6);
plot((n/(Tb+1)),s);
title('Sent Signal S(t)');
xlabel('Time');

scatterplot(s);
title('Transmitter BPSK');

%% Channel Model
ah = raylrnd(N*(Tb+1),N*(Tb+1),1);
ncetah=[0:2*pi/(N*T):2*pi-2*pi/(N*T)];
cetah=(1/sum(cetah))*ones(N*T,1);

%Channel impulse response h(t)
h = ah.*exp(1j*cetah).*n';

figure();
subplot(3,1,1);
plot(t,ah);
title('ah');

subplot(3,1,2);
plot(ncetah/pi,cetah);
title('ceta')

subplot(3,1,3);
plot(t,abs(h));
title('Channel h(t)');

%% Receiver Model
R=conv(s,h);

%AWGN Noise
mu=0;
No=1;
variance=No/2;
sigma=sqrt(variance);
nc=normrnd(mu,sigma,[1,N*T]);
ns=normrnd(mu,sigma,[1,N*T]);
n=nc.*cos(n2)-1j*ns.*sin(n2);
yk=s+n';
scatterplot(yk)
%Channel Inversion


%Correlation



%Decision Device






