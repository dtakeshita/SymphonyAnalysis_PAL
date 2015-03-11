function [FH, ngph, fig_para, OFFcell]  = plot_spikecount( cur_node, fig_para )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     fig_para.FHoffset = FHoffset;
%     %% plot spike count vs R*
%     fig_para.nrow = 2;
%     fig_para.ncol = 3;
%     fig_para.nTotalGraphs = 1;   
%     fig_para.annotation.string = cur_node.name;
if ~isfield(fig_para,'nTotalGraphs')
    fig_para.nTotalGraphs = Inf;
end

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
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Spike Count (Post stim - Pre stim)';
    
    %Spike count (Log-log)
    fig_para.axis_prop.xscale = 'log';fig_para.axis_prop.yscale = 'log';
    %fig_para.title.string = 'Log-log';
    [fig_para.axis_prop.xlim, fig_para.axis_prop.ylim]=...
        get_axislim( dat, fig_para.axis_prop.xscale, fig_para.axis_prop.yscale);
    [fig_para.ngph, FH, ~] = tile_graph(dat,fig_para, @errorbar, fig_para.ngph, fig_para.FHoffset);
    
    %Spike count/R
    fig_para.axis_prop = struct([]);
    dat.y = dat.y./dat.x;
    fig_para.ylabel.string = 'Spike Count/R*';
    fig_para.axis_prop(1).xscale = 'log';fig_para.axis_prop(1).yscale = 'linear';
    fig_para.line_prop.marker = 'o';
     [ngph, FH, ~] = tile_graph(dat,fig_para, @plot, fig_para.ngph, fig_para.FHoffset);
    fig_para.ngph = ngph;   
end

