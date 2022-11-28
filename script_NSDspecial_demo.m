%% Data and paths

addpath('functions');
addpath('summaryScripts');
addpath(genpath('mnl_ieegbasics'));
addpath('mnl_seegview');

[data_raw, states, params] = load_bcidat(dataSets{:});
nsamps = size(data_raw, 1);
srate = params.SamplingRate.NumericValue;

channels = readtableRmHyphens('channels.tsv');
chNames = channels.name;

data_raw(:, length(chNames)+1:end) = []; 

fprintf('length of recording: %.2fs (%d samples)\n', nsamps/srate, nsamps);


%% Data preprocessing (1, filtering)

data_hp = double(data_raw); data_hp(isnan(data_hp)) = 0; % remove nans for ieeg_highpass
data_hp = ieeg_highpass(data_hp, srate);

%% Check for bad channels, after highpass

tpoints = 60*srate:120*srate+srate; % some timepoints to make the checks quicker
figure; spectopo(data_hp(tpoints, :)',0, srate);

%% Define bad channels

bad_chans = [];
chsNR = getChsNR(channels, 'electrodes.tsv');
bad_chans = union(bad_chans, chsNR);

chans2incl = setdiff(1:size(data_hp, 2), bad_chans);

figure; spectopo(data_hp(tpoints, chans2incl)', 0, srate);

%% Data preprocessing (2, referencing)

ref = 'car';
preprocess2; % : data, dataBand.__.raw, nchannels
fprintf('preprocess2\n');

%% Organize data into trials (trials x samples x channels), remove trials with interictal activity

disp('Assembling and filtering stim, rest trials');
window = [-1, 1.5]; % window around onset to define for each trial
assembleTrials; % : pdiode, stimCode, ons, codes, dataTrials, dataBand.__.trials, eyesTrials

restBool = codes == 1; % trials that correspond to rest
stimBool = codes >= 3; % trials that correspond to stim
      
runLengths = [307, 307, 307, 307]; % number of trials including rests and probes
filterTrials; % remove interictal trials if any

%% Median time series for all channels

% Robust ERPs in LPT 1-5
clim.EP = [-50, 50];
plotTimeSeries;

%% PSDs for all channels

% Broadband changes for LPT 1-5 and LD1 (ch46)
interval = [0, 0.8]; % interval to calculate PSD on for stim and rest

clim.PSD = [-0.2, 0.2]; % for PSD log fold change (stim - rest)
getPSD; % : pxxStim, dataBand.__.stimPower, pxxRest, dataBand.__.restPower

%% R-squareds for all channels at all frequencies & for alpha/broadband vs rest

clim.Rsq = [-0.2, 0.2];
plotRsq; % : rsqHm, dataBand.__.rsq

%% Visualize R-squared of broadband on brain

% Load SORTED electrodes (use miscFuncs/sortElectrodes.m)
electrodes = readtableRmHyphens('');
electrodes = electrodes(1:height(channels), :);

niiPath = '';
giiPath = '';

viewAng = [90, 0]; % 90 for R, -90 for L
renderRsq;

%% Instantaneous broadband and alpha power vs. time for all channels

restInterval = [0, 0.8]; % interval (s) of rest trials to use as normalizing background
clim.Band = [-0.4, 0.4];
plotHilbert;

%% Summary at a channel: time series, alpha/broadband vs time, PSD

%chan = 146; % LPT1
chan = 148; % LPT3, reversed ERP
%chan = 46; % LD1

plotSummary;

%% Look at broadband trace for one channel

tt = (0:size(data, 1)-1)/srate;
figure; plot(tt, dataBand.broad.raw(:, chan));
hold on;
y = zeros(size(ons));
plot(ons(codes==1)/srate, y(codes==1), 'ko');
plot(ons(codes>=3)/srate, y(codes>=3), 'ro');
yline(0, 'Color', [0.5, 0.5, 0.5]);
xlim([120, 130]);
xlabel('Time (s)'); ylabel('Voltage (\muV)');

%% Spectrograms at a channel

chan = 185;

clim.spec = [-0.5, 0.5];
restIntervalSpec = [-0.7, -0.05]; % rest interval to use relative to the stim trials
plotWavSpec;
