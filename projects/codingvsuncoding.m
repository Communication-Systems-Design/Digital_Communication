M = 16; % Alphabet size of modulation
L = 1; % Length of impulse response of channel
msg = [0:M-1 0]; % M-ary message sequence of length > M^L

modsig = qammod(msg',M); % Modulate data
Nsamp = 16;
modsig = rectpulse(modsig,Nsamp); % Use rectangular pulse shaping.

txsig = modsig; % No filter in this example

rxsig = txsig*exp(1i*pi/180); % Static phase offset of 1 degree

num = ones(Nsamp,1)/Nsamp;
den = 1;
EbNo = 0:20; % Range of Eb/No values under study
ber = semianalytic(txsig,rxsig,'qam',M,Nsamp,num,den,EbNo);

% For comparison, calculate theoretical BER.
coderate = 1/3; % Code rate
dspec.dfree = 10; % Minimum free distance of code
dspec.weight = [1 0 4 0 12 0 32 0 80 0 192 0 448 0 1024 ...
    0 2304 0 5120 0]; % Distance spectrum of code
berbound = bercoding(EbNo,'conv','soft',coderate,dspec);

% Plot computed BER and theoretical BER.
figure; semilogy(EbNo,ber,'k*');
hold on; semilogy(EbNo,berbound,'ro');
title('BER 16-QAM Coded vs Uncoded');
legend('UnCoded','Coded');
hold off;