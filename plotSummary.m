% This script plots summary plots at a channel

dataStim_chan = squeeze(dataStim(:, :, chan));
dataRest_chan = squeeze(dataRest(:, :, chan));
pxxStim_chan = squeeze(pxxStim(:, :, chan));
pxxRest_chan = squeeze(pxxRest(:, :, chan));
dataBroadStim_chan = squeeze(dataBand.broad.trialsStim(:, :, chan));
dataBroadRest_chan = squeeze(dataBand.broad.trialsRest(:, :, chan));
dataAlphaStim_chan = squeeze(dataBand.alpha.trialsStim(:, :, chan));
dataAlphaRest_chan = squeeze(dataBand.alpha.trialsRest(:, :, chan));
dataBroadStim_chan = movmean(dataBroadStim_chan, 0.05*srate, 2);
dataBroadRest_chan = movmean(dataBroadRest_chan, 0.05*srate, 2);

figure('Position', [600, 300, 600, 1200]);
switch ref
    case 'car'
        sgtitle(sprintf('Ch%d - %s', chan, chNames{chan}));
    case 'bipolar'
        sgtitle(sprintf('Ch%d - %s', chan, bipolarChans{chan}));
end

subplot(4, 1, 1); % plot time series
hold on
plotCurvConf(t_trial, dataRest_chan, 'k', 0.3);
plotCurvConf(t_trial, dataStim_chan, 'r', 0.3);
plot(t_trial, mean(dataRest_chan), 'k', 'LineWidth', 1);
plot(t_trial, mean(dataStim_chan), 'r', 'LineWidth', 1);
xline(0, 'Color', [0.3 0.3 0.3]);
hold off
ylabel('V (uV)');
title('time series');
xlim([-0.2, 0.8]);

subplot(4, 1, 2); % time-varying broadband, plot 12-point (10 ms) moving average
hold on
plotCurvConf(t_trial, dataBroadRest_chan, 'k', 0.3);
plotCurvConf(t_trial, dataBroadStim_chan, 'r', 0.3);
plot(t_trial, mean(dataBroadRest_chan), 'k', 'LineWidth', 1);
plot(t_trial, mean(dataBroadStim_chan), 'r', 'LineWidth', 1);
xline(0, 'Color', [0.3 0.3 0.3]);
hold off
ylabel('Log_{10} Power');
title('Broadband (70 - 170 Hz)');
xlim([-0.2, 0.8]);

% Apply 10s moving mean to alpha
dataAlphaRest_chan = movmean(dataAlphaRest_chan, round(0.01*srate), 2);
dataAlphaStim_chan = movmean(dataAlphaStim_chan, round(0.01*srate), 2);
subplot(4, 1, 3); % time-varying alpha, plot 60-point (50 ms) moving average
hold on
plotCurvConf(t_trial, dataAlphaRest_chan, 'k', 0.3);
plotCurvConf(t_trial, dataAlphaStim_chan, 'r', 0.3);
plot(t_trial, mean(dataAlphaRest_chan), 'k', 'LineWidth', 1);
plot(t_trial, mean(dataAlphaStim_chan), 'r', 'LineWidth', 1);
xline(0, 'Color', [0.3 0.3 0.3]);
hold off
xlabel('time (s)');
ylabel('Log_{10} Power');
title('Alpha (8 - 12 Hz)');
xlim([-0.2, 0.8]);
  
subplot(4, 1, 4); hold on % PSD
plotCurvConf(f, log10(pxxRest_chan), 'k', 0.3);
plotCurvConf(f, log10(pxxStim_chan), 'r', 0.3);
plot(f, mean(log10(pxxRest_chan)), 'k', 'LineWidth', 1.5);
plot(f, mean(log10(pxxStim_chan)), 'r', 'LineWidth', 1.5);
xlabel('Frequency (Hz)'); ylabel('PSD');
xlim([0, 200]);
title('PSD');
hold off