function [FH, ngph, fig_para, OFFcell] = plot_PSTHs( cur_node, FHoffset, AHoffset, fig_para, OFFcell, smoothingWindow )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fig_para.FHoffset = FHoffset;
    ngph = AHoffset+1;
    ngph = mod_n(ngph,fig_para.nrow*fig_para.ncol);
    fig_para.line_prop.marker ='none';
    idx_nonzero = cellfun(@(x)any(x>0),cur_node.PSTH.value);
    x = cur_node.PSTH.xvalue(idx_nonzero);
    y = cur_node.PSTH.value(idx_nonzero);
    para = cur_node.RstarMean(idx_nonzero);
    dat = v2struct(x,y,para);
    dat.legend.string = cellstr(num2str(dat.para','%3.2g'));
    % smoothing
    [dat.y, smoothingWindow_pts] = cellfun(@(x,y)smoothPSTH(x,y,smoothingWindow),dat.x, dat.y,'uniformoutput',false);
    smoothingWindow_pts = unique(cell2mat(smoothingWindow_pts));
    %[dat.y, smoothingWindow_pts]  = smoothPSTH( dat.x, dat.y, smoothingWindow );
    if smoothingWindow_pts >0
        txt_smooth = sprintf(':%dpts smoothing',smoothingWindow_pts);
    else
        txt_smooth = sprintf(':no smoothing');
    end
    % Baseline subtraction
    PSTH_baseline_subtracted = cellfun(@(x,y) y-mean(y(x<0)), dat.x, dat.y,'uniformoutput',false);
    [PSTH_abspeaks, idx] = cellfun(@(x)max(abs(x(1:end-1))), PSTH_baseline_subtracted);
    linidx = 1:length(idx);
    PSTH_peakvals = arrayfun(@(n,i)PSTH_baseline_subtracted{n}(i),linidx,idx);
    
    if OFFcell
        dat.legend.location = 'Southwest';
    else
        dat.legend.location = 'Northwest';
    end
    fig_para.axis_prop.xscale = 'linear';fig_para.axis_prop.yscale = 'linear';
    fig_para.title.string = ['PSTH',txt_smooth];
    fig_para.xlabel.string = 'Time (sec)'; 
    fig_para.ylabel.string = 'Firing rate (Hz)';
    x_min = unique(cur_node.recordingOnset.value);x_max = unique(cur_node.recordingOffset.value);
    fig_para.axis_prop.xlim = [x_min x_max];
    [ngph, FH, ~, LH] = tile_graph(dat,fig_para,@plot, ngph, FHoffset);
    
    %PSTH peak (baseline subtracted)
    dat.y = PSTH_baseline_subtracted;
    %PSTH/R
    idx = 1:length(dat.y);
    dat.y = arrayfun(@(n)dat.y{n}/dat.para(n),idx,'uniformoutput',false);
    fig_para.title.string = ['PSTH/R*',txt_smooth];fig_para.ylabel.string = 'Firing rate/R* (Hz/R*)';
    [ngph, FH, ~, LH] = tile_graph(dat,fig_para,@plot, ngph, FHoffset);   
    
    %Peak value in abs(PSTH_subtacted)
    clear dat;
    fig_para.line_prop.marker ='o';
    dat.x = para;
    dat.y = PSTH_abspeaks;
    fig_para.title.string = ['Peak firing rate',txt_smooth];
    fig_para.xlabel.string = 'R*';
    fig_para.ylabel.string = 'Firing rate (Hz)';
    fig_para.axis_prop.xlim = [-Inf Inf];
    [ngph, FH, ~, LH] = tile_graph(dat,fig_para,@plot, ngph, FHoffset);
    
    %Peak value log-log
    fig_para.axis_prop.xscale = 'log';fig_para.axis_prop.yscale = 'log';
    fig_para.title.string = ['Peak firing rate log-log',txt_smooth];
    %Set axis lim
    [fig_para.axis_prop.xlim, fig_para.axis_prop.ylim]=...
        get_axislim( dat, fig_para.axis_prop.xscale, fig_para.axis_prop.yscale);
    [ngph, FH, ~, LH] = tile_graph(dat,fig_para, LH, ngph, FHoffset);
    
    %Peak value sensitivity
    dat.y = dat.y./dat.x;
    fig_para.axis_prop.xscale = 'linear';fig_para.axis_prop.yscale = 'linear';
    fig_para.title.string = ['Peak firing rate/R*',txt_smooth];
    fig_para.xlabel.string = 'R*';
    fig_para.ylabel.string = 'Firing rate/R* (Hz/R*)';
    fig_para.axis_prop.xlim = [-Inf Inf];
    fig_para.axis_prop.ylim = [-Inf Inf];
    [ngph, FH, ~, LH] = tile_graph(dat,fig_para,@plot, ngph, FHoffset);

end

