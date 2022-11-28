% This script makes time series plots for all channels during stim and during rest

figure('Position', [200, 200, 1200, 1200]);
subplot(1, 2, 1);
toplot = squeeze(mean(dataStim, 1))';
if strcmp(ref, 'car'), toplot(bad_chans, :) = nan; end
imagescNaN(t_trial, 1:nchannels, toplot, 'CLim', clim.EP);
xlim([0, 1]);
if strcmp(ref, 'car')
    set(gca, 'YTick', 1:2:nchannels);
    set(gca, 'YTickLabels', chNames(1:2:end));
elseif strcmp(ref, 'bipolar')
    set(gca, 'YTick', 1:1:nchannels);
    set(gca, 'YTickLabels', bipolarChans);
end
title('Stim');
ylabel('channels');
xlabel('time (s)');
colormap(cm);

subplot(1, 2, 2);
toplot = squeeze(mean(dataRest, 1))';
if strcmp(ref, 'car'), toplot(bad_chans, :) = nan; end
imagescNaN(t_trial, 1:nchannels, toplot, 'CLim', clim.EP);
xlim([0, 1]);
if strcmp(ref, 'car')
    set(gca, 'YTick', 1:2:nchannels, 'YTickLabels', chNames(1:2:end));
elseif strcmp(ref, 'bipolar')
    set(gca, 'YTick', 1:nchannels, 'YTickLabels', bipolarChans);
end
title('Rest');
xlabel('time (s)');
colormap(cm);
colorbar;