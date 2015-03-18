function [FH, fig_para,th]  = plot_FOS( cur_node, fig_para, varargin )
if nargin >=3
    celltype_name = varargin{1};
else
    celltype_name = '';
end
if ~isfield(fig_para,'nTotalGraphs')
    fig_para.nTotalGraphs = Inf;
end
    if ~isfield(cur_node,'FOS')
        FH = [];
        th = struct([]);
        return;
    end
    dat.x = cur_node.FOS.xvalue;
    dat.y = cur_node.FOS.value;
    %dat.y_error = cur_node.spikeCount_poststim_baselineSubtracted.SEM;
    
    %% Plots
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Pcorrect';
    fig_para.axis_prop.xscale = 'log';
    fig_para.axis_prop.yscale = 'linear';
    %fig_para.title.string = 'Log-log';
    fig_para.line_prop_single.marker = 'o';
    [fig_para.axis_prop.xlim, fig_para.axis_prop.ylim]=...
        get_axislim( dat, fig_para.axis_prop.xscale, fig_para.axis_prop.yscale);
    [fig_para.ngph, FH, ~] = tile_graph(dat,fig_para, @plot, fig_para.ngph, fig_para.FHoffset);
    fig_para.title.string = 'FOS'; 
    
    %calculate measure
    th.x_75 = calc_thresh(dat.x, dat.y,0.75);
    th.x_85 = calc_thresh(dat.x, dat.y,0.85);
end

function out = calc_thresh(x,y,th)
    %Note: one could use interpolation to get x_th
    if all(y>th)
        idx = 1;
    elseif y(1) > y(2)%aovid the case where first intensity is affected by britest stimulus
       idx = 1+find(y(2:end)>th,1,'first');
    else
       idx = find(y>th,1,'first')
    end
    out = x(idx);
end