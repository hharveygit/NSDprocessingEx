% this script assembles the data (time series, bandpassed, eyetracker) into trials

pdiode = states.DigitalInput1;
stimCode = states.StimulusCode;

figure; hold on
plot(50*pdiode);
plot(stimCode);
hold off

t_trial = (window(1)*srate : window(2)*srate)/srate;
[dataTrials, ons, codes] = getTrials(data, pdiode, stimCode, [window(1)*srate, window(2)*srate]);
dataBand.alpha.trials = getTrials(dataBand.alpha.raw, pdiode, stimCode, [window(1)*srate, window(2)*srate]);
%dataBand.gamma.trials = getTrials(dataBand.gamma.raw, pdiode, stimCode, [window(1)*srate, window(2)*srate]);
dataBand.broad.trials = getTrials(dataBand.broad.raw, pdiode, stimCode, [window(1)*srate, window(2)*srate]);
eyesTrials = getTrials([states.EyetrackerLeftEyeGazeX, ... % per-trial data on eye positions
                       states.EyetrackerLeftEyeGazeY, ...
                       states.EyetrackerRightEyeGazeX, ...
                       states.EyetrackerRightEyeGazeY], pdiode, stimCode, [window(1)*srate, window(2)*srate]);