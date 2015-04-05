function [ output_args ] = add2CellData(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    global ANALYSIS_FOLDER
    data_path = fullfile(ANALYSIS_FOLDER,'cellData');
    cellname_set = uigetfile(data_path,'MultiSelect','on');
    if ~iscell(cellname_set)
       cellname_set = {cellname_set}; 
    end
    for ncell = 1:length(cellname_set)
       cellName = rm_ext(cellname_set{ncell});
       load(fullfile(data_path, cellName));%cellData is loaded
       if exist('Nepochs','var');
           clear Nepochs;
       end
       Nepochs = length(cellData.epochs);
       if Nepochs > 0
           cellData.epochs = addLEDVoltages( cellData.epochs );
           cellData.epochs = addRstarMean( cellData.epochs, cellName );      
           saveAndSyncCellData(cellData);
       end
    end
end

