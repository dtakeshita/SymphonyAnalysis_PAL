global ANALYSIS_FOLDER
save_path = fullfile(ANALYSIS_FOLDER,'AnalysisTree');
%cellName_set = uigetfile([ANALYSIS_FOLDER,'analysisTrees' filesep],'MultiSelect','on');
cellName_set = {'012715Ac2','020315Ac13','031715Ac4','020315Ac14'};
if ~iscell(cellName_set)
   cellName_set = {cellName_set}; 
end
stimulus_type = 'LightStep_20';
param_FOS.n_epoch_min=30;
param_FOS.binwidth = 10;%Bin size for spike count histogram (in msec)
param_FOS.twindow = 400;%msec
for n=1:length(cellName_set)
    cellName = cellName_set{n};
    load([ANALYSIS_FOLDER 'analysisTrees' filesep cellName]);%analysisTree is loaded
    tr = analysisTree;
    load([ANALYSIS_FOLDER 'cellData' filesep cellName]);%cellData is loaded
    cell_type = cellData.cellType;
   idx = find(tr.treefun(@(x)~isempty(strfind(x.name,stimulus_type))));
    if length(idx) > 1
        error('There should be only one DataSet with this name!');
    end
    %% Analysis over leaves (e.g. response vs R*, etc.) should be done here!
    cur_tree = tr.subtree(idx);
    cur_parent = cur_tree.get(1); 
    cur_tree = calcFOS( cur_tree, param_FOS);%should be done beforehand?
    
    dat = [cur_tree.get(1).FOS.xvalue cur_tree.get(1).FOS.value]';
    
    %% save data
    sname = sprintf('FOS_%s_%s_%s.txt',stimulus_type, cell_type,cellName);
    sname(isspace(sname))='_';
    sname = strrep(sname,'-/-','MM');
    sname = strrep(sname,'+/+','PP');
    cell_type(isspace(cell_type)) = '_';
    fileID = fopen(sname,'w');
    fprintf(fileID,'%s%s\n',cell_type, cellName);
    fprintf(fileID,'%s %s\n','R*','FOS');
    fprintf(fileID,'%f %f\n',dat);
    fclose(fileID);
end