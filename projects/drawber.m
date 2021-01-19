function BER=drawber(No)
N=100; % Number of Samples
M=16; % Number bits per symbol
%-------------------Data Generation---------------------------%
data=randi([0 M-1],N,1);
%-----------Grey Encoding------------%
[datagrey,mapgrey] = bin2gray(data,'qam',M);
%-------------------16-QAM Modulation----------------------------%
consttable=[-3-3i, -3-1i, -3+3i, -3+1i,...
            -1-3i, -1-1i, -1+3i, -1+1i,...
             3-3i, 3-1i, 3+3i, 3+1i,...
             1-3i, 1-1i, 1+3i, 1+1i];
for k=1:length(datagrey)
    tx(k) = consttable(datagrey(k)+1);
end 
tx=tx(:);
% Rayleigh-Fading Channel Model
hr=normrnd(0,sqrt(0.5),1);
hi=normrnd(0,sqrt(0.5),1);
h=(hr+1i*hi)*ones(1,N);
h=h(:);
rx=tx.*h;
% AWGN Channel
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
% Correlator & Decision Model
consttable=[-3-3i, -3-1i, -3+3i, -3+1i, -1-3i, -1-1i, -1+3i, -1+1i, 3-3i, 3-1i, 3+3i, 3+1i, 1-3i, 1-1i, 1+3i, 1+1i];
for N = 1:length(yk)
     %compute the minimum distance for each symbol  
     [~, idx] = min(abs(yk(N) - consttable));
     datademod(N) = idx-1;
end
[datademodbin,mapbin] = gray2bin(datademod,'qam',M);
datademodbin=datademodbin(:);
% BER
BER=biterr(datademodbin,data)/(length(data)*log2(M));
end