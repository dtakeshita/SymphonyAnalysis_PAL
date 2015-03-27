function epochID_out = getExcludedEpochs( cellname )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 0
       cellname = '032415Ac11';
    end
    global ANALYSIS_FOLDER
    load(fullfile(ANALYSIS_FOLDER,'cellData',cellname));
    exclude = cellData.epochs.get2('excluded');
    epochID = cellData.epochs.get2('epochNum');
    if iscell(exclude)%Does this happen when NaN & 0 are mixed??
        exclude = to_array(exclude);
    end
    epochID_out = epochID(exclude==true);
end

function out = to_array(exclude)
    out = zeros(size(exclude));
    for n=1:length(exclude)
       out(n) = exclude{n}; 
    end
end