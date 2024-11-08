% Program to pass a signal through a square-root raised cosine filter for pulse shaping and matched filtering

% Clear workspace, close all figures, and clear command window
close all; 
clear; 

% Define key parameters for the square root raised cosine filter and modulation
beta = 0.3;        % Rolloff factor of the filter
span = 8;          % Filter span in symbols (duration of impulse response)
sps = 4;           % Samples per symbol
N=20;              % Number of bits
% Generate a random binary sequence of bits (0s and 1s) with length equal
% to N
bits=randi([0 1], 1, N);
% Generate a vector of NRZ-L
Data = 2 * bits - 1;

% Open a new figure for plotting
figure;

% Plot the polar NRZ encoded signal over time
stem(Data, 'b', 'LineWidth', 1.5);  

% Hold the current plot to overlay the bit stream
hold on;

% Plot the bit stream as discrete steps using a red line
stairs(bits, 'r', 'LineWidth', 2);  % Stepped plot for binary bit representation

% Add plot title and labels for clarity
title('polar NRZ Encoding with Bit Stream');
xlabel('Time (s)');   % X-axis labeled as time in seconds
ylabel('Amplitude (V)');   % Y-axis labeled as amplitude in volts
legend('polar NRZ Encoded Signal', 'Bit Stream');
grid on;    % Enable grid
axis([0 20 -1.1 1.1]); % Set axis limits for visualization

% Generate the square-root raised cosine (SRRC) filter coefficients
[srrc_filt, t, filtDelay] = srrcFunction(beta, sps, span);
% Calculate energy of the SRRC pulse
energy = sum(srrc_filt.^2);
% Normalize the SRRC filter coefficients
normalizedSRRC = srrc_filt / sqrt(energy);
% Visualize the SRRC filter using its impulse response
fvtool(srrc_filt, 'impulse');

% Upsample the bipolar data and filter for pulse shaping
UP_s = upfirdn(Data, normalizedSRRC, sps, 1);

snr = 50; % Eb/No value in dB

% Transmit the upsampled signal through an AWGN channel
rxSignal = awgn(UP_s, snr);

% Apply matched filtering (downsampling and filtering) to the received signal
rxFiltSignal = upfirdn(rxSignal, normalizedSRRC, 1, sps);

% Account for filter delay by trimming excess samples
rxFiltSignal = rxFiltSignal(span + 1:end - span);

% Plot the original bipolar data and the filtered received signal
figure;
stem(Data, 'filled'); % Plot original transmitted data
hold on;
plot(rxFiltSignal, 'r'); % Plot received signal after matched filtering
xlabel('Time'); 
ylabel('Amplitude');
grid on;
legend('Transmitted Data', 'Received Data');

% Plot the received signal through the AWGN channel
figure;
plot(rxSignal);
legend('Filtered Signal through AWGN Channel');
xlabel('Time');
ylabel('Amplitude');
grid on;


% h=conv(normalizedSRRC,normalizedSRRC,'same');
% plot(h);
% legend('convolution between two SRRC');
% xlabel('Time');
% ylabel('Amplitude');
% grid on;
%% Eye diagrm
% Define key parameters for the square root raised cosine filter and modulation
beta = [0.3 0.5 0.8 1];       % Rolloff factor of the filter
span = 8;                    % Filter span in symbols (duration of impulse response)
sps = 4;                     % Samples per symbol
N =1000;                     % Number of bits

% Generate a random binary sequence of bits (0s and 1s) with length equal
% to N
bits=randi([0 1], 1, N);
% Generate a vector of NRZ-L
Data = 2 * bits - 1;
figure('Name','EbNo=30dB','NumberTitle','off');
for i=1:length(beta)
% Generate the square-root raised cosine (SRRC) filter coefficients
[srrc_filt, t, filtDelay] = srrcFunction(beta(i), sps, span);
% Calculate energy of the SRRC pulse
energy = sum(srrc_filt.^2);
% Normalize the SRRC filter coefficients
normalizedSRRC = srrc_filt / sqrt(energy);
% Upsample the bipolar data and filter for pulse shaping
UP_s = upfirdn(Data, normalizedSRRC, sps, 1);
rxSignal = awgn(UP_s, 30);
subplot(2,2,i);
plotEyeDiagram(rxSignal,sps,4*sps,filtDelay-2,100);
title(['beta=', num2str(beta(i))]);
end