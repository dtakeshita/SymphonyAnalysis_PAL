function acrossCellSummaryPlot_step5000()
    close all;
    %parameters
%     nrow = 3; ncol = 3;
%     fig_para = v2struct(nrow,ncol);
    global ANALYSIS_FOLDER
    save_path = fullfile(ANALYSIS_FOLDER,'SummaryPlots','AcrossCells');
    cellName_set = uigetfile([ANALYSIS_FOLDER,'analysisTrees' filesep],'MultiSelect','on');
    %cellName_set = {'022415Ac4'};%test purpose
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
    % for across celltype analysis
    spc_perR_max = cell(n_cellType,1);
    FOS_75 = spc_perR_max;
    FOS_85 = spc_perR_max;
    spc_measure = spc_perR_max;
    base_FR = spc_perR_max;
    %Set a loop for different stimuli??
    analysis_class = 'LightStep';
    %stimulus_type = 'LightStep_20';
    stimulus_type = 'LightStep_5000';
    splitter_strain = {'+/+','-/-'};
    for nt = 1:n_cellType
        celltype_name = cellType_unique{nt};
        if isempty(celltype_name)
            continue;
        end
        cnames_sametype = cellName_set(cell_idx==nt);
        n_cells_sametype = length(cnames_sametype);
%         if n_cells_sametype==0
%             continue;
%         end
        fig_para = param_tilefigs();
        %Across cell analysis
        fig_para.annotation.string = [stimulus_type,' ',celltype_name];
        %Across cell-type analysis
        %tmp_spc_perR_max = zeros(n_cells_sametype,1);
        tmp_spc_measure = struct([]);
        tmp_spc_perR_max = struct([]);
        tmp_FOS_75 = struct([]);
        tmp_FOS_85 = struct([]);
        tmp_baseFR = struct([]);
        ncell_nonempty = 1;
        for ncell = 1:length(cnames_sametype)
            fig_para.nTotalGraphs = 2*length(cnames_sametype);
            cellName = rm_ext(cnames_sametype{ncell});
            load([ANALYSIS_FOLDER 'analysisTrees' filesep cellName]);%analysisTree is loaded
            tr = analysisTree;
            load([ANALYSIS_FOLDER 'cellData' filesep cellName]);%cellData is loaded
            cdat = cellData;
            fig_para.title.string = cellName;
            %idx = find(tr.treefun(@(x)~isempty(strfind(x.name,analysis_class))));
            idx = find(tr.treefun(@(x)~isempty(strfind(x.name,stimulus_type))));
            if length(idx) > 1
                error('There should be only one DataSet with this name!');
            elseif isempty(idx)
                continue;
            end
            %% Analysis over leaves (e.g. response vs R*, etc.) should be done here!
            cur_tree = tr.subtree(idx);
            %% Calculate measures
            twindow_offset_post = 1000;
            %FOS
            param_FOS = get_param_FOS(stimulus_type);
            param_FOS.twindow_offset_post=twindow_offset_post;
            cur_tree = calcFOS( cur_tree, param_FOS);%should be done beforehand?
            %spike count difference
            param_diff = get_param_SPC(stimulus_type);
            param_diff.twindow_offset_post=twindow_offset_post;
            cur_tree = calcSpikeCountDiff(cur_tree, param_diff);
            cur_parent = cur_tree.get(1);
            %% Spike counts
            fig_para.axis_prop.xscale = 'linear';
            fig_para.axis_prop.yscale = 'linear';
            [FH, ngph,fig_para,~, spc_measures] = plot_spikecount( cur_parent, fig_para, celltype_name, stimulus_type );
            %Threshold in polynomial
            tmp_spc_measure(ncell_nonempty ).cellname = cellName;
            tmp_spc_measure(ncell_nonempty ).x = classify_names(celltype_name,splitter_strain);
            tmp_spc_measure(ncell_nonempty ).y = spc_measures.fit_result.thresh;
            %Log-linear plot
            fig_para.axis_prop.xscale = 'log';
            fig_para.axis_prop.yscale = 'linear';
            [FH, ngph,fig_para,~, spc_measures] = plot_spikecount( cur_parent, fig_para, celltype_name, stimulus_type );
            %baseline FR
            tmp_baseFR(ncell_nonempty ).cellname = cellName;
            tmp_baseFR(ncell_nonempty ).x = classify_names(celltype_name,splitter_strain);
            tmp_baseFR(ncell_nonempty ).y = spc_measures.baselineRate_all.mean;
            
            [FH, ngph,fig_para, ~, max_val] = plot_spikecount_per_R( cur_parent, fig_para, celltype_name );
            tmp_spc_perR_max(ncell_nonempty ).cellname = cellName;
            tmp_spc_perR_max(ncell_nonempty ).x = max_val.x; 
            tmp_spc_perR_max(ncell_nonempty ).y = max_val.y;
            %% FOS
%             [FH, fig_para, th] = plot_FOS(cur_tree.get(1), fig_para);
%             tmp_FOS_75(ncell_nonempty ).cellname = cellName;
%             tmp_FOS_75(ncell_nonempty ).y = th.x_75;
%             tmp_FOS_75(ncell_nonempty ).x = classify_names(celltype_name,splitter_strain);
%             
%             tmp_FOS_85(ncell_nonempty ).cellname = cellName;
%             tmp_FOS_85(ncell_nonempty ).y = th.x_85;
%             tmp_FOS_85(ncell_nonempty ).x = classify_names(celltype_name,splitter_strain);
            ncell_nonempty = ncell_nonempty +1;
        end
        %store meausred values for across cell-type analysis
        spc_perR_max{nt} = tmp_spc_perR_max;
%         FOS_75{nt} = tmp_FOS_75;
%         FOS_85{nt} = tmp_FOS_85;
        spc_measure{nt} = tmp_spc_measure;
        base_FR{nt} = tmp_baseFR;
        sname = sprintf('%s_%s_SummaryPlot.pdf',stimulus_type, celltype_name);
        sname(isspace(sname))='_';
        sname = strrep(sname,'-/-','MM');
        sname = strrep(sname,'+/+','PP');
        %sname = 'test.pdf';
        setFigureSize( );
        save_figs('', sname,save_path,'saveas');
    end
    %% Save Data temporary
    
    
    %% Do across cell-type analysis here!
    splitter = {'on alpha','off sustained alpha','off transient alpha'};
    clear fig_para;
    fig_para.ncol = 3; fig_para.nrow = 3;
    fig_para.FHoffset = 0; fig_para.ngph = 1;
    fig_para.nTotalGraphs = 3;fig_para.annotation.string = stimulus_type;
    %% Plot spike count/R* max vs
    fig_para.axis_prop.xscale = 'log';fig_para.axis_prop.yscale = 'log';
    fig_para.xlabel.string = 'R*@max';fig_para.ylabel.string = 'max(SPC/R*)';
    [FH, fig_para] = plot_across_celltype(spc_perR_max, cellType_unique, fig_para, splitter);
    %% Plot FOS threshold
%     fig_para.axis_prop.xscale = 'linear';fig_para.axis_prop.yscale = 'log';
%     fig_para.axis_prop.xlim = [0 3]; 
%     fig_para.xlabel.string = 'Strain';fig_para.ylabel.string = 'FOS 0.75';
%     [FH, fig_para] = plot_across_celltype(FOS_75, cellType_unique, fig_para, splitter);
%     fig_para.xlabel.string = 'Strain';fig_para.ylabel.string = 'FOS 0.85';
%     [FH, fig_para] = plot_across_celltype(FOS_85, cellType_unique, fig_para, splitter);
    %% Plot threshold determined from spike count
    fig_para.axis_prop.xscale = 'linear';fig_para.axis_prop.yscale = 'log';
    fig_para.xlabel.string = 'Strain';fig_para.ylabel.string = 'Threshold';
    fig_para.axis_prop.xlim = [0 3]; 
    [FH, fig_para] = plot_across_celltype(spc_measure, cellType_unique, fig_para, splitter);
    %% Plot baseline firing rate
    fig_para.axis_prop.xscale = 'linear';fig_para.axis_prop.yscale = 'linear';
    fig_para.xlabel.string = 'Strain';fig_para.ylabel.string = 'Intrinsic firing rate';
    [FH, fig_para] = plot_across_celltype(base_FR, cellType_unique, fig_para, splitter);
    %fig_para.axis_prop=rmfield(fig_para.axis_prop,'xlim');
%     %% Plot slope vs th_75?
%     slope_th75 = pairing_measures( FOS_75, spc_slope);
%     fig_para.axis_prop.xscale = 'log';fig_para.axis_prop.yscale = 'linear';
%     fig_para.xlabel.string = 'Th75';fig_para.ylabel.string = 'Slope';
%     [FH, fig_para] = plot_across_celltype(slope_th75, cellType_unique, fig_para, splitter);
    %% Plot threshold vs intrinsic-FR
    thresh_FR = pairing_measures( base_FR, spc_measure);
    fig_para.axis_prop.xscale = 'linear';fig_para.axis_prop.yscale = 'log';
    fig_para.xlabel.string = 'Intrinsic firing rate (Hz)';fig_para.ylabel.string = 'Threshold';
    [FH, fig_para] = plot_across_celltype(thresh_FR, cellType_unique, fig_para, splitter);
    
%     %% Plot th_75 vs intrinsic-FR
%     th75_FR = pairing_measures( base_FR, FOS_75);
%     fig_para.axis_prop.xscale = 'linear';fig_para.axis_prop.yscale = 'log';
%     fig_para.xlabel.string = 'Intrinsic firing rate (Hz)';fig_para.ylabel.string = 'Th75';
%     [FH, fig_para] = plot_across_celltype(th75_FR, cellType_unique, fig_para, splitter);
%     
    
    %% Save across cell summary
    sname = [stimulus_type,'_AcrossCelltypeSummary.pdf'];
    setFigureSize();
    save_figs('',sname,save_path,'saveas');

end

function dat_out = pairing_measures(x_set, y_set)
%correct x_set{:}.y & y_set{:}.y and store into 
    if length(x_set)~=length(y_set)
        error('x_set & y_set should have same size!!')
    end
    dat_out = cell(length(x_set),1);
    for n=1:length(x_set)
        s_x = x_set{n};s_y = y_set{n};%s_x & s_y are 
        if length(s_x)~=length(s_y)
            error('x_set & y_set should have same size!!')
        end
        dat_tmp = struct([]);
        for m=1:length(s_x)
            if ~strcmp(s_x(m).cellname, s_y(m).cellname)
                error(['x_set & y_set should be from the same cell!!'])
            end
            dat_tmp(m).cellname = s_x(m).cellname;
            dat_tmp(m).x = s_x(m).y;
            dat_tmp(m).y = s_y(m).y;
        end
        dat_out{n}= dat_tmp;
    end

end

function out = classify_names(name,splitter)
    out = find(cellfun(@(c)~isempty(strfind(name,c)),splitter));
    if length(out) > 1
        error(['cannot belong to more than one class!'])
    end
end