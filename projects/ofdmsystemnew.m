hMod = comm.OFDMModulator;
hMod.FFTLength = 128;
hMod.NumSymbols = 2;
disp(hMod)
showResourceMapping(hMod)