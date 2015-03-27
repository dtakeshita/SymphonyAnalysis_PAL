function [FH, ngph, fig_para, OFFcell, max_val]  = plot_spikecount_per_R( cur_node, fig_para, varargin )
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
%     dat.x = cur_node.RstarMean;
%     dat.y = cur_node.spikeCount_poststim_baselineSubtracted.mean;
%     %dat.y_error = cur_node.spikeCount_poststim_baselineSubtracted.SEM;
    dat.x = cur_node.spikecountdiff.xvalue;
    dat.y = cur_node.spikecountdiff.mean;
    dat.y_error = cur_node.spikecountdiff.SEM;
    %% For OFF-cells, flip  
    [OFFcell, dat.y] = isOffCell( dat.y, celltype_name );
    %% Plots
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Spike Count/R*';
    
    %Spike count/R
    fig_para.axis_prop = struct([]);
    dat.y = dat.y./dat.x;
    fig_para.ylabel.string = 'Spike Count/R*';
    fig_para.axis_prop(1).xscale = 'log';fig_para.axis_prop(1).yscale = 'linear';
    fig_para.line_prop.marker = 'x';
    [fig_para.ngph, FH, ~] = tile_graph(dat,fig_para, @plot, fig_para.ngph, fig_para.FHoffset);

    %Calculate max value-avoid fist point
    [~, max_ind] = max(dat.y(2:end));
    fig_para.ngph = fig_para.ngph-1;
    fig_para = rmfield(fig_para,'line_prop');
    max_val.x = dat.x(max_ind+1);max_val.y = dat.y(max_ind+1);
    fig_para.line_prop_single.marker = 'o';
    [fig_para.ngph, FH, ~] = tile_graph(max_val,fig_para, 'holdOnPlot', fig_para.ngph, fig_para.FHoffset);
    
    fig_para = my_rmfield(fig_para,{'axis_prop','line_prop','line_prop_single'});
    ngph = fig_para.ngph;%To be compatible with old codes
end

