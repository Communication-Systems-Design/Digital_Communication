% No.of Carriers: 32
% coding used: Convolutional coding
% Single frame size: 96 bits
% Total no. of Frames: 100
% Modulation: QPSK

%% Initialization
close all;
clear;clc;

%% Generating and coding data
N=21;
data=randi([0 3],N,1)';
codeddata=repmat(data,1,3);
codeddata=[0, codeddata];

%% Interleaver
interleavematrix=reshape(codeddata,8,8);

%% Binary to decimal conversion
dec=bi2de(interleavematrix,'left-msb');

%% Mapper
y = qpskmod(dec);
scatterplot(y);


%% IFFT
ifft_sig=ifft(y,32);


%% Adding Cyclic Extension

cext_data=zeros(80,1);
cext_data(1:16)=ifft_sig(25:32);
for i=1:32
    
    cext_data(i+16)=ifft_sig(i);
    
end


%% Rayleigh-Flat Fading Channel
hr=normrnd(0,sqrt(0.5),1);
hi=normrnd(0,sqrt(0.5),1);
h=(hr+1i*hi)*ones(1,N);
h=h(:);

%% Selective Channel
selhr=normrnd(0,sqrt(0.5),N);
selhi=normrnd(0,sqrt(0.5),N);
selh=selhr+1i*selhi;
selh=selh(:);

%% AWGN Channel
ofdm_sig=awgn(cext_data,snr,'measured'); % Adding white Gaussian Noise

%% RECEIVER
% Removing Cyclic Extension

for i=1:32
    
    rxed_sig(i)=ofdm_sig(i+16);
    
end

% FFT
ff_sig=fft(rxed_sig,32);


% Demodulation
dem_data= qpskdemod(ff_sig);


% Decimal to binary conversion
bin=de2bi(dem_data','left-msb');
bin=bin';

% De-Interleaving
deintlvddata = matdeintrlv(bin,2,2); % De-Interleave
deintlvddata=deintlvddata';
deintlvddata=deintlvddata(:)';

% Decoding data
n=6;
k=3;
decodedata =vitdec(deintlvddata,trellis,5,'trunc','hard');  % decoding datausing veterbi decoder
rxed_data=decodedata;

% Calculating BER
rxed_data=rxed_data(:)';
errors=0;
c=xor(data,rxed_data);
errors=nnz(c);
BER=errors/length(data);