function acrossCellSummaryPlot()
    close all;
    %parameters
    nrow = 3; ncol = 4;
    fig_para = v2struct(nrow,ncol);
    global ANALYSIS_FOLDER
    save_path = fullfile(ANALYSIS_FOLDER,'SummaryPlots');
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
    
    %Set a loop for different stimuli??
    for nt = 1:n_cellType
        celltype_name = cellType_unique{nt};
        if isempty(celltype_name)
            continue;
        end
        cnames_sametype = cellName_set(cell_idx==nt);
        %Across cell analysis
        fig_para.annotation.string = celltype_name;
        fig_para.ngph = 1;
        fig_para.FHoffset = 0;
        for ncell = 1:length(cnames_sametype)
            fig_para.nTotalGraphs = 2*length(cnames_sametype);
            cellName = rm_ext(cnames_sametype{ncell});
            load([ANALYSIS_FOLDER 'analysisTrees' filesep cellName]);%analysisTree is loaded
            tr = analysisTree;
            load([ANALYSIS_FOLDER 'cellData' filesep cellName]);%cellData is loaded
            cdat = cellData;
            fig_para.title.string = cellName;
            analysis_class = 'LightStep';
            %idx = find(tr.treefun(@(x)~isempty(strfind(x.name,analysis_class))));
            idx = find(tr.treefun(@(x)~isempty(strfind(x.name,'LightStep_20'))));
            for n=1:length(idx)
                %% Analysis over leaves (e.g. response vs R*, etc.) should be done here!
                cur_parent = tr.Node{idx(n)};
                [FH, ngph,fig_para, OFFcell] = plot_spikecount( cur_parent, fig_para );
                
%                 [FH, ngph,fig_para, OFFcell] = plot_PSTHs( cur_parent, FH-1, ngph-1, fig_para, OFFcell, 0 ); %no smoothing
%                 clear fig_para.axis_prop;
%                 [FH, ngph,fig_para, OFFcell] = plot_PSTHs( cur_parent, FH-1, ngph-1, fig_para, OFFcell, 50 ); %Smoothing 50ms window (=5 data pts)
            end
        end
        sname = sprintf('%s_SummaryPlot.pdf',celltype_name);
        sname(isspace(sname))='_';
        sname = strrep(sname,'-/-','MM');
        sname = strrep(sname,'+/+','PP');
        %sname = 'test.pdf';
        setFigureSize( );
        save_figs('', sname,save_path,'saveas');
    end
    
end