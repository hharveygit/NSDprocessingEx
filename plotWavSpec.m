% This script gets the wavelet spectrogram of stim trials and normalizes them by the rest period before each stim trial
% in log10 space. Spectrogram is calculated as the mean of all normalized log-10 spectrograms

dataStim_chan = squeeze(dataStim(:, :, chan));
dataRest_chan = squeeze(dataRest(:, :, chan));

[S, fspec] = getWaveletSpectrogram(dataStim_chan', srate, [1, 200]);
S_norm = log10(S) - mean(log10(S(:, t_trial>restIntervalSpec(1) & t_trial<restIntervalSpec(2), :)), 2);
S_norm = mean(S_norm, 3); % average across trials

figure('Position', [300, 300, 600, 600]);
uimagesc(t_trial, fspec, S_norm, clim.spec); colormap(cm);
axis xy; % so that frequencies are in ascending order
xlim([-0.2, 1]);
xlabel('time (s)');
ylabel('F (Hz)');
colorbar('southoutside');
title(sprintf('channel %d', chan));