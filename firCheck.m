function [firWeights] = firCheck(firBand, firOrder, firTrans, eegRate, figureOn)

nyquistFreq = eegRate/2;
firAmp      = [0 0 1 1 0 0];
firFreq     = [0 (1-firTrans)*firBand(1) firBand(1) firBand(2) firBand(2)*(1+firTrans) nyquistFreq] / nyquistFreq;
firWeights  = firls(firOrder, firFreq, firAmp);

% Plot filter
figure;
subplot(211)
plot((1:firOrder+1)*(1000/eegRate),firWeights')
xlabel('Time (ms)')
title('Time-domain filter kernel')

firFFT = abs(fft(firWeights));
freqHz = linspace(0, nyquistFreq, floor(firOrder/2)+1);

subplot(212)
plot(freqHz, firFFT(:,1:length(freqHz)))
hold on;
plot([0 (1-firTrans)*firBand(1) firBand(1) firBand(2) firBand(2)*(1+firTrans) nyquistFreq], firAmp)
set(gca, 'xlim', [0 60], 'ylim', [-.1 1.2])
xlabel('Frequencies (Hz)')
title('Frequency-domain filter kernel')

if figureOn == 0
    close;
end

end