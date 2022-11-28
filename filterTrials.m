% this script separates trial data into stim and rest trials, and removes bad trials

% Remove trials with interictal activity
winTrials = [ons, ons + window(2)*srate];
[badTrials, interictalHm] = getInterictalTrials(winTrials, data, bad_chans); % get bad trials from highpassed (pre-referenced) data
warning('Filtering right now on data (after CAR and line noise removal)');

figure('Position', [300, 300, 2000, 800]);
imagesc(interictalHm');
colormap gray; colorbar;
set(gca, 'YTick', 1:2:size(data_hp, 2));
xlabel('chunk'); ylabel('channel'); title('Interictal chunks');

% Stim trials (exclude attention pikachu, rest)
dataStim = dataTrials(stimBool & ~badTrials, :, :);
dataBand.alpha.trialsStim = dataBand.alpha.trials(stimBool & ~badTrials, :, :);
%dataBand.gamma.trialsStim = dataBand.gamma.trials(stimBool & ~badTrials, :, :);
dataBand.broad.trialsStim = dataBand.broad.trials(stimBool & ~badTrials, :, :);
eyes.stim = eyesTrials(stimBool & ~badTrials, :, :);

% rest trials, excluding ones that come after probes.
dataRest = dataTrials(restBool & ~badTrials, :, :);
dataBand.alpha.trialsRest = dataBand.alpha.trials(restBool & ~badTrials, :, :);
%dataBand.gamma.trialsRest = dataBand.gamma.trials(restBool & ~badTrials, :, :);
dataBand.broad.trialsRest = dataBand.broad.trials(restBool & ~badTrials, :, :);
eyes.rest = eyesTrials(restBool & ~badTrials, :, :);

% get ordered paths matching each code presentation. Manually list the size of each trial included
%pathStim = getPathStim(stims, codes, runLengths); 
%pathStim = pathStim(stimBool & ~badTrials); % filter for only stim trials