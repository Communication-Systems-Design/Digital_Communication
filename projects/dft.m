function [X] = dft( x, L, N)
%DFT Summary of this function goes here
%   Detailed explanation goes here%% Implementing DFT Function
n=[0:L-1];
for K=0:N-1
    X(K+1)=sum(x.*exp((-1j*(2*pi*n*K))/N));
end
end

