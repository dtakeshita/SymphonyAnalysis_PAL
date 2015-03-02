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
       try
       Nepochs = length(cellData.epochs);
       catch
           2;
       end
       for ne = 1:Nepochs
           tmp = cellData.epochs(ne);
           addLEDVoltages( tmp );
           addRstarMean( tmp, cellName );
           cellData.epochs(ne) = tmp;
       end
       %Save cell files
       save(fullfile(data_path, [cellName,'.mat']),'cellData');
    end
end

