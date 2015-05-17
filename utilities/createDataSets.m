function createDataSets()
%Create data sets based on the duration of light step.
%WARNING: So far, it assumes every epoch 
%   Detailed explanation goes here
    global ANALYSIS_FOLDER
    analysis_class = 'LightStep';
    %filter_cond = {'stimTime',20, 'stimTime',500, 'stimTime',5000};
    %n_filter = length(filter_cond)/2;
    
    filter_cond = {{'preTime',500, 'stimTime',20, 'tailTime', 500};%Flash
                   {'preTime',500, 'stimTime',500};%500ms step
                    {'preTime',5000,'stimTime',5000}};%Background step
    n_filter = size(filter_cond,1);
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
            %filter_str = sprintf('M.get(''%s'')==%g',filter_cond{2*nf-1},filter_cond{2*nf});
            filter_str = sprintf('M.get(''%s'')==%g && ',filter_cond{nf}{:});
            filter_str = filter_str(1:end-4);%get rid of the last &&
            idx = cellData.filterEpochs(filter_str);
            if ~isempty(idx)
                %saveName = sprintf('%s_%d',analysis_class, filter_cond{2*nf});
                stimTime_idx = find(strcmp(filter_cond{nf},'stimTime'));
                saveName = sprintf('%s_%d',analysis_class,...
                    filter_cond{nf}{stimTime_idx+1});%stimTime is used
                cellData.savedDataSets(saveName) = idx;
            end
        end
        %save(fullfile(ANALYSIS_FOLDER,'cellData', cellname),'cellData');
        saveAndSyncCellData(cellData);
    end
end

