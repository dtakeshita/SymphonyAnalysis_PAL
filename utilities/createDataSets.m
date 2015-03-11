function createDataSets()
%Create data sets based on the duration of light step.
%WARNING: So far, it assumes every epoch 
%   Detailed explanation goes here
    global ANALYSIS_FOLDER
    analysis_class = 'LightStep';
    filter_cond = {'stimTime',20, 'stimTime',500, 'stimTime',5000};
    n_filter = length(filter_cond)/2;
    cellName_set = uigetfile([ANALYSIS_FOLDER,'cellData' filesep],'MultiSelect','on');
    if ~iscell(cellName_set)
       cellName_set = {cellName_set}; 
    end
    %add ampMode == Cell attached (change the function below when starting 
    addAmpMode(cellName_set);
    num_cell = length(cellName_set);
    for nc = 1:num_cell
        try
        cellname = cellName_set{nc};
        catch
            2;
        end
        load(fullfile(ANALYSIS_FOLDER,'cellData', cellname));
        if isnan(cellData.get('Nepochs'))
            continue;
        end
        for nf = 1:n_filter
            filter_str = sprintf('M.get(''%s'')==%g',filter_cond{2*nf-1},filter_cond{2*nf});
            idx = cellData.filterEpochs(filter_str);
            if ~isempty(idx)
                saveName = sprintf('%s_%d',analysis_class, filter_cond{2*nf});
                cellData.savedDataSets(saveName) = idx;
            end
        end
        %save(fullfile(ANALYSIS_FOLDER,'cellData', cellname),'cellData');
        saveAndSyncCellData(cellData);
    end
end

