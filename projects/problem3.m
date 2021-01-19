%%%%%%%%%%%%%%%%%%%OFDM System Simulation%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
clear;clc
close all;

%% Coding Block
%Either no coding or rate 1/3 repition code are used.
%Adjust the number of input bits per OFDM Symbol when using repetition
%Code. For Example, if you use QPSK, only 21 data bits will be used 
%per symbol, a zero is added to the encoded data to have 64 bits at the 
%input of the mapper before IFFT block.
N=3;
