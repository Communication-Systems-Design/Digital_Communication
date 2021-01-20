% No.of Carriers: 64
% coding used: Convolutional coding
% Single frame size: 96 bits
% Total no. of Frames: 100
% Modulation: 16-QAM
% No. of Pilots: 4
% Cylic Extension: 25%(16)

%% Initialization
close all;
clear;clc;

%% Generating and coding data
t_data=randint(9600,1)';
x=1;
si=1; %for BER rows

for d=1:100;
data=t_data(x:x+95);
x=x+96;
k=3;
n=6;
s1=size(data,2);  % Size of input matrix
j=s1/k;

%% Coding using Convolutional Encoding
constlen=7;
codegen = [171 133];    % Polynomial
trellis = poly2trellis(constlen, codegen);
codedata = convenc(data, trellis);



%% Interleaver
s2=size(codedata,2);
j=s2/4;
matrix=reshape(codedata,j,4);

intlvddata = matintrlv(matrix',2,2)'; % Interleave.
intlvddata=intlvddata';


%% Binary to decimal conversion
dec=bi2de(intlvddata','left-msb');

%% Mapper
y = qpskmod(dec);
scatterplot(y);


%% IFFT
ifft_sig=ifft(y,32);


%% Adding Cyclic Extension

cext_data=zeros(80,1);
cext_data(1:16)=ifft_sig(49:64);
for i=1:64
    
    cext_data(i+16)=ifft_sig(i);
    
end


%% Rayleigh-Flat Fading Channel

%% Selective Channel
%% AWGN Channel
ofdm_sig=awgn(cext_data,snr,'measured'); % Adding white Gaussian Noise

%% RECEIVER
% Removing Cyclic Extension

for i=1:64
    
    rxed_sig(i)=ofdm_sig(i+16);
    
end

% FFT
ff_sig=fft(rxed_sig,32);

% Pilot Synch
for i=1:52
    
    synched_sig1(i)=ff_sig(i+6);
    
end

k=1;

for i=(1:13:52)
        
    for j=(i+1:i+12);
        synched_sig(k)=synched_sig1(j);
        k=k+1;
    end
end

scatterplot(synched_sig)


% Demodulation
dem_data= qpskdemod(synched_sig);


% Decimal to binary conversion
bin=de2bi(dem_data','left-msb');
bin=bin';

% De-Interleaving
deintlvddata = matdeintrlv(bin,2,2); % De-Interleave
deintlvddata=deintlvddata';
deintlvddata=deintlvddata(:)';

%  Decoding data
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