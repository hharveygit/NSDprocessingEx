% This script performs rereferencing for the highpassed data and returns time-varying alpha, gamma, broadband signals

data = data_hp;
switch ref
    case 'car'
        data = ieeg_car(data, chans2incl);
    case 'bipolar'
        [data, bipolarChans, excludedChans] = ieeg_bipolarSEEG(data(:, 1:length(chNames)), chNames, bad_chans);
    otherwise,  error('incorrect ref choice');
end

%spectopo(data(tpoints, chans2incl)', length(tpoints), srate); % check data PSD after car

%data = removeLineNoise_SpectrumEstimation(data', srate, 'NH = 3, LF = 60, HW = 3')';
data = ieeg_notch(data, srate, 60, 3);
warning('REMOVING LINE NOISE HERE');

nchannels = size(data, 2); % number of final channels to use

dataBand = struct();
dataBand.alpha.raw = ieeg_getHilbert(data, [8, 12], srate);
%dataBand.gamma.raw = ieeg_getHilbert(data, [30, 50], srate);
dataBand.broad.raw = ieeg_getHilbert(data, [70, 90; 90, 110; 130, 150; 150, 170], srate);