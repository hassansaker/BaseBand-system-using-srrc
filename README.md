# Pulse Shaping and Matched Filtering in Digital Communication

This project demonstrates how pulse shaping and matched filtering techniques are applied to optimize signal transmission and recovery in digital communication systems. Using a square-root raised cosine (SRRC) filter for pulse shaping and a matched filter for signal detection, the project shows how intersymbol interference (ISI) can be minimized, and the signal-to-noise ratio (SNR) can be maximized to improve the reliability of data transmission.

## Project Overview

In digital communication, pulse shaping and matched filtering are essential for reducing bandwidth usage and enhancing signal detection in noisy environments. This project simulates these processes, focusing on:

1. **Pulse Shaping**: Creating a square-root raised cosine filter to shape the transmitted signal and limit bandwidth.
2. **Noise Addition**: Modeling an additive white Gaussian noise (AWGN) channel to simulate real-world transmission conditions.
3. **Matched Filtering**: Applying a matched filter at the receiver to maximize SNR and improve detection accuracy.

## Key Features

- **Square-root Raised Cosine Filter** for bandwidth-efficient pulse shaping.
- **Additive White Gaussian Noise (AWGN) Channel** simulation.
- **Matched Filter** implementation to maximize detection efficiency.
- Comparison of transmitted and received signals to observe the effects of filtering and noise.

## Getting Started

### Prerequisites

- MATLAB or Octave for running the code.
- Signal Processing Toolbox (if using MATLAB).



### Running the Code

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/pulse-shaping-matched-filter.git
   cd pulse-shaping-matched-filter
