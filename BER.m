% Performance simulation of MPAM with SRRC pulse shaping
clear; clc;

% Number of symbols to transmit
N = 10^5; 
F=100;
% SNRs for generating AWGN channel noise
EbN0dB = -5:1:20; 

% ---- Pulse shaping filter definitions -----
beta = 0.3; % Roll-off factor for SRRC filter
Nsym = 8;   % SRRC filter span in symbol durations
sps = 4;      % Oversampling factor (L samples per symbol period)

% Generate SRRC filter
[srrc_filt, t, filtDelay] = srrcFunction(beta, sps, Nsym);
% Calculate energy of the SRRC pulse
energy = sum(srrc_filt.^2);
% Normalize the SRRC filter coefficients
normalizedSRRC = srrc_filt / sqrt(energy);
% Initialize Symbol Error Rate (SER) placeholders
ber = zeros(1, length(EbN0dB)); 

% Simulate the system for each given SNR
for i = 1:length(EbN0dB)
    n=0;
    for k=1:F
    fprintf('EbN0dB = %f, frame = %d  \n', EbN0dB(i), k);
    % -------- Transmitter -------------------
    bits=randi([0 1], 1, N);
    BP_Data = 2 *bits -1 ;
    
    % Upsample the bipolar data and filter for pulse shaping
    UP_s = upfirdn(BP_Data, normalizedSRRC, sps, 1); 

    % -------- Channel -------------------
    % Add AWGN noise to the transmitted signal based on the current SNR
    ch = awgn(UP_s, EbN0dB(i)); 

    % -------- Receiver -------------------
    % Convolve received signal with SRRC filter to recover symbols
    rxFiltSignal = upfirdn(ch, normalizedSRRC, 1, sps);
    
    % Account for filter delay by trimming excess samples
    rxFiltSignal = rxFiltSignal(Nsym + 1:end - Nsym);
    
    out= rxFiltSignal > 0;
    % Calculate symbol error rate for this SNR value
    n=n+biterr(bits,out);
    end
    ber(i) = n/N/F; 
end

ebno = 10.^(EbN0dB/10);
EbN0dB_theory=qfunc(sqrt(ebno));
figure;
% Plot results: Symbol Error Rate vs. Eb/N0 in a semi-logarithmic scale
semilogy(EbN0dB, ber, 'r-d','LineWidth', 1.5);
hold on;
semilogy(EbN0dB, EbN0dB_theory, 'c','LineWidth', 1.2);
grid on;
title('BER');
xlabel('EbNo (dB)');   % X-axis labeled as time in seconds
ylabel('Amplitude');   % Y-axis labeled as amplitude in volts
legend('practical BER', 'Theoritical BER');