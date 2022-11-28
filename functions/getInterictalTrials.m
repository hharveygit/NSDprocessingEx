%% Returns logical vector corresponding to the interictal activity status of input trials
%   This function first creates small chunks of the input data and examines interictal activity on a chunk-by-chunk
%   basis. A chunk is flagged to have interictal activity ("bad") if it contains a positive AND negative sample diff
%   exceeding diffThresh, AND if it contains a sample magnitude exceeding absThresh. Then, all trials that intersect at
%   least one bad chunk in ANY channel (excluding optional list of bad channel inputs) are thus flagged as bad trials.
%
%   badTrials = getInterictalTrials(winTrials, signal, badChans);
%   [badTrials, interictalHm, badChunkSamps] = getInterictalTrials(winTrials, signal, badChans, diffThresh, absThresh, chunkSize);
%       winTrials =         nx2 num, each row = [start, end] samples of trial in <signal>. n trials.
%       signal =            txc double, signal data to find interictal activity on. Rows are samples and columns are
%                               channels. Signal needs to be highpassed to remove DC component, but ideally not rereferenced.
%       badChans =          mx1 num, list of numbers corresponding to columns (channel) in signal to not use for
%                               consideration of interictal activity. m < c. Input [] if all channels are to be used.
%       diffThresh =        Positive num (optional). Threshold for diff(signal), i.e. change in amplitude between 
%                               adjacent samples. A bad chunk must contain a positive AND negative change > |diffThresh|. 
%                               Default = 70.
%       absThresh =         Positive num (optional). Threshold for signal amplitude. A bad chunk must contain at least 
%                               one sample whose magnitude (positive or negative) exceeds absThresh. Default = 500.
%       chunkSize =         Positive num (optional). Number of samples to use per chunk. Default = 60, which corresponds
%                               to 50ms for signal with 1200Hz.
%
%   Returns:
%       badTrials =         nx2 logical, values determine whether the corresponding input trial contains interictal
%                               activity. True = interictal (bad), False = no interictal.
%       interictalHm =      hxc double. Heatmap of (bad) chunks that are flagged for interictal activity. h total chunks
%                               across c channels. 1 = interictal, 0 = no interictal
%       badChunkSamps =     hx2 double. [start, end] samples of bad chunks, in the same format as input <winTrials>.
%                               Each row has interval = <chunkSize>.
%
%   Dependency: intersectRanges.m, which returns a logical vector of ranges a that intersect ranges b.
%
%   HH 2021
%
function [badTrials, interictalHm, badChunkSamps] = getInterictalTrials(winTrials, signal, badChans, diffThresh, absThresh, chunkSize)
    
    if ~exist('diffThresh', 'var') || isempty(diffThresh), diffThresh = 70; end
    if ~exist('absThresh', 'var') || isempty(absThresh), absThresh = 500; end
    if ~exist('chunkSize', 'var') || isempty(chunkSize), chunkSize = 60; end
    
    assert(diffThresh >= 0 && absThresh >= 0 && chunkSize >= 0, 'All optional values must be strictly positive');
    
    interictalHm = zeros(floor(size(signal, 1)/chunkSize), size(signal, 2)); % floor: complete chunks only
    
    for ii = 1:size(interictalHm, 1) % assign for one chunk at a time, for all channels
        chunk = signal(((ii-1)*chunkSize+1) : ii*chunkSize, :); % across all channels
        interictalHm(ii, :) = any(diff(chunk, 1, 1) > diffThresh) & any(diff(chunk, 1, 1) < -diffThresh);
        interictalHm(ii, :) = interictalHm(ii, :) & any(chunk > absThresh | chunk < -absThresh);
    end
    interictalHm(:, badChans) = nan;

    % can optionally make this more lenient (e.g. >= 2 channels with interictal activity is bad chunk
    badChunks = find(sum(interictalHm, 2, 'omitnan') >= 1);
    badChunkSamps = [(badChunks - 1)*chunkSize + 1, badChunks*chunkSize]; % sample start, end of bad chunks
    badTrials = intersectRanges(winTrials, badChunkSamps); % which trials overlap bad chunks
    
end