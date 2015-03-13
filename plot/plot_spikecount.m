function [FH, ngph, fig_para, OFFcell]  = plot_spikecount( cur_node, fig_para, varargin )
if nargin >=3
    celltype_name = varargin{1};
else
    celltype_name = '';
end
if ~isfield(fig_para,'nTotalGraphs')
    fig_para.nTotalGraphs = Inf;
end
    
    dat.x = cur_node.RstarMean;
    dat.y = cur_node.spikeCount_poststim_baselineSubtracted.mean;
    dat.y_error = cur_node.spikeCount_poststim_baselineSubtracted.SEM;
    %Calculate mean baseline rate
    baselineRate_all = calc_population_stat(cur_node.baselineRate);
    baselineRate_fano = baselineRate_all.var/baselineRate_all.mean;
    str_baselineRate = sprintf('%3.2g(%3.2g)Hz,F:%3.2g',baselineRate_all.mean,...
        baselineRate_all.SD,baselineRate_fano);
    ttl_str = fig_para.title.string;
    fig_para.title.string = sprintf('%s:%s',fig_para.title.string,str_baselineRate);
    %% Determine OFF-cell or not
    [OFFcell, dat.y] = isOffCell( dat.y, celltype_name );
    %% Plots
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Spike Count Difference';
    
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
    fig_para.title.string = ttl_str;%put back to original string
    ngph = fig_para.ngph;%legacy from the old code     
end

