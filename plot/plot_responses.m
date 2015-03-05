function [FH, ngph, fig_para, OFFcell]  = plot_responses( cur_node, FHoffset )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fig_para.FHoffset = FHoffset;
    %% plot spike count vs R*
    fig_para.nrow = 2;
    fig_para.ncol = 3;
    fig_para.nTotalGraphs = 1; 
    
    fig_para.annotation.string = cur_node.name;
%     ngph_fig = nrow*ncol;
    dat.x = cur_node.RstarMean;
    dat.y = cur_node.spikeCount_poststim_baselineSubtracted.mean;
    dat.y_error = cur_node.spikeCount_poststim_baselineSubtracted.SEM;
    
    %% Some analysis-should be done before??
    OFFcell = false;
    if sum(dat.y<0) > sum(dat.y>0)
        dat.y = -dat.y;
        OFFcell = true;
    end
    %% Plots
    ngph = 1;
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Spike Count (Post stim - Pre stim)';
    %fig_para.line_prop.marker = 'o';-this doesn't work so far
    
    %Linear plot
    fig_para.title.string = 'Linear scale';
    [ngph, ~, ~, LH] = tile_graph(dat,fig_para, @errorbar, ngph, FHoffset);
    
    %Semi-log plot
    fig_para.axis_prop.xscale = 'log';
    fig_para.title.string = 'Semi-log';
    [ngph, ~, ~, LH] = tile_graph(dat,fig_para, LH, ngph, FHoffset);
    
    %Log-log plot
    fig_para.axis_prop.xscale = 'log';fig_para.axis_prop.yscale = 'log';
    fig_para.title.string = 'Log-log';
%     x_min = 10^floor(log10(min(dat.x(dat.y>0))));
%     x_max = 10^ceil(log10(max(dat.x(dat.y>0))));
%     fig_para.axis_prop.xlim = [x_min x_max];
    [fig_para.axis_prop.xlim, fig_para.axis_prop.ylim]=...
        get_axislim( dat, fig_para.axis_prop.xscale, fig_para.axis_prop.yscale);
    [ngph, FH, ~] = tile_graph(dat,fig_para, LH, ngph, FHoffset);
    
    %Spike count/R
    fig_para.axis_prop = struct([]);
    dat.y = dat.y./dat.x;
    fig_para.ylabel.string = 'Spike Count/R*';
    fig_para.title.string = 'Spike Count/R*';
    fig_para.axis_prop(1).xscale = 'linear';fig_para.axis_prop(1).yscale = 'linear';
    fig_para.line_prop.marker = 'o';
     [ngph, FH, ~] = tile_graph(dat,fig_para, @plot, ngph, FHoffset);

  
end

