% This script plots the hilbert-transform instantaneous broadband and alpha envelopes vs time

figure('Position', [200, 200, 600, 1200]); % use only second half of rest trial as background because signal has come up
toplot = squeeze(mean(dataBand.broad.trialsStim, 1) - mean(mean(dataBand.broad.trialsRest(:, t_trial >= restInterval(1) & t_trial < restInterval(2), :), 2), 1))';
if strcmp(ref, 'car'), toplot(bad_chans, :) = nan; end
imagescNaN(t_trial, 1:nchannels, toplot, 'CLim', clim.Band); colormap(cm);
colorbar;
xlim([0, 1]);
if strcmp(ref, 'car')
    set(gca, 'YTick', 1:2:nchannels, 'YTickLabels', chNames(1:2:end));
elseif strcmp(ref, 'bipolar')
    set(gca, 'YTick', 1:nchannels, 'YTickLabels', bipolarChans);
end
title('Broadband')
ylabel('channels');
xlabel('time (s)');

figure('Position', [200, 200, 600, 1200]); % use only second half of rest trial as background because signal has come up
toplot = squeeze(mean(dataBand.alpha.trialsStim, 1) - mean(mean(dataBand.alpha.trialsRest(:, t_trial >= restInterval(1) & t_trial < restInterval(2), :), 2), 1))';
if strcmp(ref, 'car'), toplot(bad_chans, :) = nan; end
imagescNaN(t_trial, 1:nchannels, toplot, 'CLim', clim.Band); colormap(cm);
colorbar;
xlim([0, 1]);
if strcmp(ref, 'car')
    set(gca, 'YTick', 1:2:nchannels, 'YTickLabels', chNames(1:2:end));
elseif strcmp(ref, 'bipolar')
    set(gca, 'YTick', 1:nchannels, 'YTickLabels', bipolarChans);
end
title('Alpha')
ylabel('channels');
xlabel('time (s)');