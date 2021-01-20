function datademodbin=qpskdemod(yk)
% Correlator & Decision Model
consttable=[-1-1i,-1+1i,1-1i,1+1i];
for N = 1:length(yk)
     %compute the minimum distance for each symbol  
     [~, idx] = min(abs(yk(N) - consttable));
     datademod(N) = idx-1;
end
[datademodbin,mapbin] = gray2bin(datademod,'qam',M);
datademodbin=datademodbin(:);
end