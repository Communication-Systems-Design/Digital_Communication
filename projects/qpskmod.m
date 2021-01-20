function tx=qpskmod(data)
%% Bpsk Transmitter Model
N=100; % Number of Samples
M=4; % Number bits per symbol
%-----------Grey Encoding------------%
[datagrey,mapgrey] = bin2gray(data,'qam',M);
%-------------------QPSK Modulation----------------------------%
consttable=[-1-1i,-1+1i,1-1i,1+1i];
for k=1:length(datagrey)
    tx(k) = consttable(datagrey(k)+1);
end 
tx=tx(:);
end