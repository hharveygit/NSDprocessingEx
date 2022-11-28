% This script calculates R-squared values for stim vs rest for each frequency and for alpha, broadband

rsqHm = zeros(size(pxxStim, 3), size(pxxStim, 2)); % channel x trial
dataBand.alpha.rsq = zeros(size(dataBand.alpha.stimPower, 2), 1);
dataBand.gamma.rsq = zeros(size(dataBand.gamma.stimPower, 2), 1);
dataBand.broad.rsq = zeros(size(dataBand.broad.stimPower, 2), 1);

for ii = 1:size(rsqHm, 1)

    dataBand.alpha.rsq(ii) = mnl_rsq(dataBand.alpha.stimPower(:, ii), dataBand.alpha.restPower(:, ii));
    dataBand.gamma.rsq(ii) = mnl_rsq(dataBand.gamma.stimPower(:, ii), dataBand.gamma.restPower(:, ii));
    dataBand.broad.rsq(ii) = mnl_rsq(dataBand.broad.stimPower(:, ii), dataBand.broad.restPower(:, ii));
    for jj = 1:size(rsqHm, 2)
        rsqHm(ii, jj) = mnl_rsq(log10(squeeze(pxxStim(:, jj, ii))), log10(squeeze(pxxRest(:, jj, ii))));
    end
    
end

if strcmp(ref, 'car')
    rsqHm(bad_chans, :) = nan;
    dataBand.alpha.rsq(bad_chans) = nan;
    dataBand.gamma.rsq(bad_chans) = nan;
    dataBand.broad.rsq(bad_chans) = nan;
end
figure('Position', [200, 200, 600, 1200]);
imagescNaN(f, 1:nchannels, rsqHm, 'CLim', clim.Rsq); colormap(cm);
xlim([0, 200]);
if strcmp(ref, 'car')
    set(gca, 'YTick', 1:2:nchannels, 'YTickLabels', chNames(1:2:end));
elseif strcmp(ref, 'bipolar')
    set(gca, 'YTick', 1:nchannels, 'YTickLabels', bipolarChans);
end
xlabel('Frequency (Hz)');
ylabel('channels');
colorbar;

figure('Position', [200, 200, 1200, 600]); hold on
plot(dataBand.broad.rsq, '-o');
plot(dataBand.alpha.rsq, '-o');
xlabel('channel');
ylabel('R-squared in band');
ax = gca;
if strcmp(ref, 'car')
    set(ax, 'XTick', 1:2:nchannels, 'XTickLabels', chNames(1:2:end));
elseif strcmp(ref, 'bipolar')
    set(ax, 'XTick', 1:nchannels, 'XTickLabels', bipolarChans);
end
ax.XAxis.FontSize = 8;
xtickangle(90);
hold off
legend('Broadband', 'Alpha');
