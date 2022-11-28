function [dataTrials, ons, codes] = getTrials(data, pdiode, stimCode, samprange)
    
    assert(size(data, 1) > size(data, 2), 'Check that rows are samples and columns are channels');
    assert(all(floor(samprange) == samprange) && samprange(end) >= samprange(1), 'Invalid sample range')
    
    % samples where photodiode turns on
    ons = find(diff(pdiode) == 1) + 1;
    codes = stimCode(ons); % stimulus (or rest) presented when pdiode turns on
    
    % Remove elements when nothing shown (beginning & end)
    ons(codes == 0) = [];
    codes(codes == 0) = [];
    
    % Trials x samples x channels
    dataTrials = zeros(length(ons), samprange(end) - samprange(1) + 1, size(data, 2));
    for ii = 1:length(ons)
        dataTrials(ii, :, :) = data(ons(ii) + samprange(1) : ons(ii) + samprange(end), :);
    end
    
end