%% Initialization
clear;clc
close all;

%% Parameters
N=21;%Size of OFDM Symbol
m=16;%Number of OFDM Symbols
M=4;
L=1;%Up-Sampling Factor
PoQ=1;%Type of Mapping 1 PSK and 2 QAM
Phase_Offset=0;%Constellation Phase Offset
Symbol_Order=2;%Constellation Symbol Order
Ncp=0;%Size of cyclic prefix samples

%% Coding && InterLeaver && Mapper
% Creating Baseband modems Tx/Rx
% data generation
Data=randi([0 M-1], m, N/L);
% Mapping
Dmap=qpskmod(Data);
% Serial to Parallel
parallel=Dmap.';
% Oversampling 
upsampled=upsample(parallel,L);
%% 32-point IFFT
% Amplitude modulation (IDFT using fast version IFFT)
am=ifft(upsampled,N);

% Parallel to serial
serial=am.';

%% Add Cyclic extension
% Cyclic Prefixing
CP_part=serial(:,end-Ncp+1:end); % this is the Cyclic Prefix part to be appended.
cp=[CP_part serial];

%% Channel
% Adding Noise using AWGN
SNRstart=-4;
SNRincrement=2;
SNRend=16;
c=0;
r=zeros(size(SNRstart:SNRincrement:SNRend));
%% Receiver
for snr=SNRstart:SNRincrement:SNRend
    c=c+1;
    noisy=awgn(cp,snr,'measured');
% Remove cyclic prefix part
    cpr=ofdm.noisy(:,Ncp+1:N+Ncp); %remove the Cyclic prefix
% serial to parallel
    parallel=cpr.';
% Amplitude demodulation (DFT using fast version FFT)
    amdemod=fft(parallel,N);
% Down-Sampling
downsampled=downsample(amdemod,L);
% Parallel to serial
    rserial=downsampled.';
% Baseband demodulation (Un-mapping)
    hRx=qpskdemod(rserial);
    Umap=hRx;
% Calculating the Symbol Error Rate
    [n, r(c)]=symerr(DATA,Umap);
    disp(['SNR = ',num2str(snr),' step: ',num2str(c),' of ',num2str(length(r))]);
end
snr=SNRstart:SNRincrement:SNRend;
% Plotting SER vs SNR
semilogy(snr,r,'-ok','linewidth',2,'markerfacecolor','r','markersize',8,'markeredgecolor','b');grid;
title('OFDM Symbol Error Rate vs SNR');
ylabel('Symbol Error Rate');
xlabel('SNR [dB]');