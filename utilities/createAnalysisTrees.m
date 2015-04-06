function createAnalysisTrees()
%Create data sets based on the duration of light step.
%WARNING: This doesn't seem to be compatible with TreeBrowserGUI-FIX
%THIS!!!
%   Detailed explanation goes here
    global ANALYSIS_FOLDER
    cellName_set = uigetfile([ANALYSIS_FOLDER,'cellData' filesep],'MultiSelect','on');
    if ~iscell(cellName_set)
       cellName_set = {cellName_set}; 
    end
    num_cell = length(cellName_set);
    labData = LabData();
    for nc = 1:num_cell
        try
        cellname = cellName_set{nc};
        catch
            2;
        end
        labData.analyzeCells(cellname);
    end
end

