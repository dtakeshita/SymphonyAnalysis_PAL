function [FH, fig_para,th]  = plot_FOS( cur_node, fig_para, varargin )
if nargin >=3
    celltype_name = varargin{1};
else
    celltype_name = '';
end
if ~isfield(fig_para,'nTotalGraphs')
    fig_para.nTotalGraphs = Inf;
end
    %% Plots
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Pcorrect';
    fig_para.axis_prop.xscale = 'log';
    fig_para.axis_prop.yscale = 'linear';
    
    if ~isfield(cur_node,'FOS')
        th = struct([]);
        [fig_para.ngph, FH, ~] = tile_graph(struct([]),fig_para, 'doNothing', fig_para.ngph, fig_para.FHoffset);
        return;
    end
    dat.x = cur_node.FOS.xvalue;
    dat.y = cur_node.FOS.value;
    %dat.y_error = cur_node.spikeCount_poststim_baselineSubtracted.SEM;
    fig_para.line_prop_single.marker = 'o';
    [fig_para.axis_prop.xlim, fig_para.axis_prop.ylim]=...
        get_axislim( dat, fig_para.axis_prop.xscale, fig_para.axis_prop.yscale);
    fig_para.axis_prop.ylim = [0.5 1];
    %Get number of epochs
    n_epoch_set = unique(cur_node.FOS.Nepoch);
    if length(n_epoch_set)>1
        fig_para.title.string = sprintf('%s:N=%d-%d',fig_para.title.string, min(n_epoch_set),max(n_epoch_set));
    else
        fig_para.title.string = sprintf('%s:N=%d',fig_para.title.string, n_epoch_set);
    end
    [fig_para.ngph, FH, ~] = tile_graph(dat,fig_para, @plot, fig_para.ngph, fig_para.FHoffset);
    
    
    %calculate measure
    th.x_75 = calc_thresh(dat.x, dat.y,0.75);
    th.x_85 = calc_thresh(dat.x, dat.y,0.85);
end

function out = calc_thresh(x,y,th)
    %Note: one could use interpolation to get x_th
    if all(y>=th)
        out = x(1);
        return;
    elseif y(1)>y(2)
        x = x(2:end);
        y = y(2:end);
    end
    idx_above = find(y>th,1,'first');
    idx_below = find(y<th,1,'last');
    try
        out = interp1(y(idx_below:idx_above),x(idx_below:idx_above),th);
    catch
        out = NaN;%If interpolation doesn't work, something is wrong anyway.
    end
    %No interpolation
%     if all(y>th)
%         idx = 1;
%     elseif y(1) > y(2)%aovid the case where first intensity is affected by britest stimulus
%        idx = 1+find(y(2:end)>th,1,'first');
%     else
%        idx = find(y>th,1,'first');
%     end
%     out = x(idx);
end
