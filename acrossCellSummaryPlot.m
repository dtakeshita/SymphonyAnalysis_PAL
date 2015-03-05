function acrossCellSummaryPlot()
    close all;
    global ANALYSIS_FOLDER
    %save_path = fullfile(ANALYSIS_FOLDER,'SummaryPlots');
    cellName_set = uigetfile([ANALYSIS_FOLDER,'analysisTrees' filesep],'MultiSelect','on');
    if ~iscell(cellName_set)
       cellName_set = {cellName_set}; 
    end
    % get cell types
    num_cell = length(cellName_set);
    cellType_all = cell(num_cell,1);
    for nc = 1:num_cell
        load(fullfile(ANALYSIS_FOLDER,'cellData', cellName_set{nc}));
        cellType_all{nc} = cellData.cellType;
    end
    [cellType_unique, ~, cell_idx] = unique(cellType_all);
    n_cellType = length(cellType_unique);
    for nt = 1:n_cellType
        cnames_sametype = cellName_set(cell_idx==nt);
        %Across cell analysis
        for ncell = 1:length(cnames_sametype)
            %cellName = '012715Ac1';%012715c1:OFF, c2:ON
            try
            cellName = rm_ext(cnames_sametype{ncell});
            catch
                2;
            end
            load([ANALYSIS_FOLDER 'analysisTrees' filesep cellName]);%analysisTree is loaded
            tr = analysisTree;
            load([ANALYSIS_FOLDER 'cellData' filesep cellName]);%cellData is loaded
            cdat = cellData;

            analysis_class = 'LightStep';
            %idx = find(tr.treefun(@(x)~isempty(strfind(x.name,analysis_class))));
            idx = find(tr.treefun(@(x)~isempty(strfind(x.name,'LightStep_20'))));
            FH_prv = 0;
            for n=1:length(idx)
                %% Analysis over leaves (e.g. response vs R*, etc.) should be done here!
                cur_parent = tr.Node{idx(n)};
                [FH, ngph,fig_para, OFFcell] = plot_responses( cur_parent, FH_prv );
                [FH, ngph,fig_para, OFFcell] = plot_PSTHs( cur_parent, FH-1, ngph-1, fig_para, OFFcell, 0 ); %no smoothing
                clear fig_para.axis_prop;
                [FH, ngph,fig_para, OFFcell] = plot_PSTHs( cur_parent, FH-1, ngph-1, fig_para, OFFcell, 50 ); %Smoothing 50ms window (=5 data pts)
            end
        end
        sname = sprintf('SummaryPlot_%s.pdf',cellName);
%         Y = 20.984;X = 29.6774;
%         xMargin = 1;               %# left/right margins from page borders
%         yMargin = 1;               %# bottom/top margins from page borders
%         xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
%         ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
%         hFig = findobj('type','figure');
%         set(hFig, 'PaperUnits','centimeters')
%         set(hFig, 'PaperSize',[X Y])
%         set(hFig, 'PaperPosition',[xMargin yMargin xSize ySize])
%         set(hFig, 'PaperOrientation','Portrait')

        save_figs('', sname,save_path,'saveas');
    end
end