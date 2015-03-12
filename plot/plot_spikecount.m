function [FH, ngph, fig_para, OFFcell]  = plot_spikecount( cur_node, fig_para, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     fig_para.FHoffset = FHoffset;
%     %% plot spike count vs R*
%     fig_para.nrow = 2;
%     fig_para.ncol = 3;
%     fig_para.nTotalGraphs = 1;   
%     fig_para.annotation.string = cur_node.name;
if nargin >=3
    celltype_name = varargin{1};
else
    celltype_name = '';
end
if ~isfield(fig_para,'nTotalGraphs')
    fig_para.nTotalGraphs = Inf;
end

%     ngph_fig = nrow*ncol;
    dat.x = cur_node.RstarMean;
    dat.y = cur_node.spikeCount_poststim_baselineSubtracted.mean;
    dat.y_error = cur_node.spikeCount_poststim_baselineSubtracted.SEM;
    
    %% Determine OFF-cell or not
    [OFFcell, dat.y] = isOffCell( dat.y, celltype_name );
    %% Plots
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Spike Count (Post stim - Pre stim)';
    
    %Spike count (Log-log)
    fig_para.axis_prop.xscale = 'log';
    if ~isempty(dat.y(dat.y>0)) %If there is positive data (that's what you expect)
        fig_para.axis_prop.yscale = 'log';
    else %OFF-T may give negative spikes count difference due to rebound
        fig_para.axis_prop.yscale = 'linear';
    end
    %fig_para.title.string = 'Log-log';
    [fig_para.axis_prop.xlim, fig_para.axis_prop.ylim]=...
        get_axislim( dat, fig_para.axis_prop.xscale, fig_para.axis_prop.yscale);
    [fig_para.ngph, FH, ~] = tile_graph(dat,fig_para, @errorbar, fig_para.ngph, fig_para.FHoffset);
    ngph = fig_para.ngph;%legacy from the old code
    
    %Spike count/R
%     fig_para.axis_prop = struct([]);
%     dat.y = dat.y./dat.x;
%     fig_para.ylabel.string = 'Spike Count/R*';
%     fig_para.axis_prop(1).xscale = 'log';fig_para.axis_prop(1).yscale = 'linear';
%     fig_para.line_prop.marker = 'o';
%     [fig_para.ngph, FH, ~] = tile_graph(dat,fig_para, @plot, fig_para.ngph, fig_para.FHoffset);
     
end

