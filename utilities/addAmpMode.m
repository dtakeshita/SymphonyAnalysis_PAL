function addAmpMode(varargin)
% This add a tag 'ampMode', cellAttached to ALL epochs.
% One needs to modify this function when we get whole-cell recording
%   Detailed explanation goes here
    global ANALYSIS_FOLDER
    paramName = 'ampMode';
    paramVal = 'Cell attached';
    if nargin >= 1
        cellName_set = varargin{1};
    else
        cellName_set = uigetfile([ANALYSIS_FOLDER,'cellData' filesep],'MultiSelect','on');
    end
    if ~iscell(cellName_set)
       cellName_set = {cellName_set}; 
    end
    num_cell = length(cellName_set);
    for nc = 1:num_cell
        cellname = cellName_set{nc};
        load(fullfile(ANALYSIS_FOLDER,'cellData', cellname));
        nepochs = cellData.get('Nepochs');
        if isnan(nepochs)
            continue;
        end
        for ne = 1:nepochs
            curEpoch = cellData.epochs(ne);
            curEpoch.attributes(paramName) = paramVal;
        end
        %save(fullfile(ANALYSIS_FOLDER,'cellData', cellname),'cellData');
        saveAndSyncCellData(cellData);
    end
end

