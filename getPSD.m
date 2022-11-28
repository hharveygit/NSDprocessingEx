% This script plots the PSD for each channel and calculates the mean trial bandpower in each band from the PSD

pxxStim = zeros(size(dataStim, 1), srate/2 + 1, size(dataStim, 3));
pxxRest = zeros(size(dataRest, 1), srate/2 + 1, size(dataRest, 3));

pwelch_win = hann(srate/4);

for kk = 1:size(pxxStim, 1)
    [pxxStim(kk, :, :), f] = pwelch(squeeze(dataStim(kk, t_trial >= interval(1) & t_trial < interval(2), :)), pwelch_win, length(pwelch_win)/2, srate, srate);
end

for kk = 1:size(pxxRest, 1)
    [pxxRest(kk, :, :), f] = pwelch(squeeze(dataRest(kk, t_trial >= interval(1) & t_trial < interval(2), :)), pwelch_win, length(pwelch_win)/2, srate, srate);
end

toplot = squeeze(mean(log10(pxxStim)) - mean(log10(pxxRest)))';
if strcmp(ref, 'car'), toplot(bad_chans, :) = nan; end
figure('Position', [200, 200, 600, 1200]);
imagescNaN(f, 1:nchannels, toplot, 'CLim', clim.PSD); colormap(cm);
xlim([0, 200]);
if strcmp(ref, 'car')
    set(gca, 'YTick', 1:2:nchannels, 'YTickLabels', chNames(1:2:end));
elseif strcmp(ref, 'bipolar')
    set(gca, 'YTick', 1:nchannels, 'YTickLabels', bipolarChans);
end
xlabel('Frequency (Hz)');
ylabel('channels');
colorbar;

% power in band, trials x channels
dataBand.alpha.stimPower = zeros(size(pxxStim, 1), size(pxxStim, 3));
dataBand.gamma.stimPower = zeros(size(pxxStim, 1), size(pxxStim, 3));
dataBand.broad.stimPower = zeros(size(pxxStim, 1), size(pxxStim, 3));
dataBand.alpha.restPower = zeros(size(pxxRest, 1), size(pxxRest, 3));
dataBand.gamma.restPower = zeros(size(pxxRest, 1), size(pxxRest, 3));
dataBand.broad.restPower = zeros(size(pxxRest, 1), size(pxxRest, 3));

for ii = 1:size(pxxStim, 1)
    dataBand.alpha.stimPower(ii, :) = bandpower(squeeze(pxxStim(ii, :, :)), f, [8, 20], 'psd');
    dataBand.gamma.stimPower(ii, :) = bandpower(squeeze(pxxStim(ii, :, :)), f, [30, 50], 'psd');
    dataBand.broad.stimPower(ii, :) = bandpower(squeeze(pxxStim(ii, :, :)), f, [70, 170], 'psd');
end
for ii = 1:size(pxxRest, 1)
    dataBand.alpha.restPower(ii, :) = bandpower(squeeze(pxxRest(ii, :, :)), f, [8, 20], 'psd');
    dataBand.gamma.restPower(ii, :) = bandpower(squeeze(pxxRest(ii, :, :)), f, [30, 50], 'psd');
    dataBand.broad.restPower(ii, :) = bandpower(squeeze(pxxRest(ii, :, :)), f, [70, 170], 'psd');
end
