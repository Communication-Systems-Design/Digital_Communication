%% Initialization
clear;clc
close all;
%% Bpsk Transmitter Model
N=100; % Number of Samples
M=2; % Number bits per symbol
%-------------------Data Generation---------------------------%
data=randi([0 M-1],N,1);
%data=[0:M-1];
%-----------Grey Encoding------------%
[datagrey,mapgrey] = bin2gray(data,'qam',M);
%-------------------16-QAM Modulation----------------------------%
consttable=[1 -1];
for k=1:length(datagrey)
    tx(k) = consttable(datagrey(k)+1);
end 
tx=tx(:);
scatterplot(tx,1,0,'b*');
for k = 1:16
    text(real(tx(k))-0.3,imag(tx(k))+0.3,...
        dec2base(data(k),2,log2(M)));
    
    text(real(tx(k))-0.3,imag(tx(k))-0.3,...
        dec2base(datagrey(k),2,log2(M)),'Color',[1 0 0]);
end
title('Transmitted Symbols');

%% Rayleigh-Fading Channel Model
hr=normrnd(0,sqrt(0.5),1);
hi=normrnd(0,sqrt(0.5),1);
h=(hr+1i*hi)*ones(1,N);
h=h(:);
rx=tx.*h;
scatterplot(rx)
title('Rayleigh-Fading Channel Effect');

%% AWGN Channel
%AWGN Noise
mu=0;
No=0.1;
variance=No/2;
sigma=sqrt(variance);
nc=normrnd(mu,sigma,[1,N]);
ns=normrnd(mu,sigma,[1,N]);
n=nc+1i*ns;
n=n(:);
yk=rx+n;
scatterplot(yk);
title('AWGN Channel Effect');

%% Correlator & Decision Model
yk=yk./h;
consttable=[1 -1];
for N = 1:length(yk)
     %compute the minimum distance for each symbol  
     [~, idx] = min(abs(yk(N) - consttable));
     datademod(N) = idx-1;
end
[datademodbin,mapbin] = gray2bin(datademod,'qam',M);
datademodbin=datademodbin(:);

%% BER
%BER=biterr(datademodbin,data)/(length(data)*log2(M));
i=1;
for Es_N0_dB = [-4:0.1:16]
    for meannum=1:100
        meanv(meannum)=drawberbpsk(10^(-Es_N0_dB/10));
    end
    BER(i)=sum(meanv(:))/100;
    i=i+1;
end
Es_N0_dB = [-4:0.1:16];
plot(Es_N0_dB,1*log10(BER));

%% Repitition Code



