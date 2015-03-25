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
    epochID_out = epochID(exclude==true);
end

