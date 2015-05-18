function [FH, ngph, fig_para, OFFcell, measures]  = plot_spikecount( cur_node, fig_para, varargin )
if nargin >=3
    celltype_name = varargin{1};
else
    celltype_name = '';
end
if nargin >=4
    stim_type = varargin{2};
else
    stim_type = '';
end
if ~isfield(fig_para,'nTotalGraphs')
    fig_para.nTotalGraphs = Inf;
end
    
%     dat.x = cur_node.RstarMean;
%     dat.y = cur_node.spikeCount_poststim_baselineSubtracted.mean;
%     dat.y_error = cur_node.spikeCount_poststim_baselineSubtracted.SEM;
    dat.x = cur_node.spikecountdiff.xvalue;
    if ~isempty(cur_node.spikecountdiff.mean)
        dat.y = cur_node.spikecountdiff.mean;
        dat.y_error = cur_node.spikecountdiff.SEM;
    else
        if isempty(dat.x)
            dat.x = NaN;
        end
        dat.y = NaN;
        dat.y_error = [];
        measures.linfit.slope = NaN;
        measures.baselineRate_all.mean = NaN;
    end
    %% Determine OFF-cell or not
    [OFFcell, dat.y] = isOffCell( dat.y, celltype_name );
    %% Some data analysis
    %Analysis time window
    intvl_pre = cur_node.spikecountdiff.param.interval_pre;
    intvl_post = cur_node.spikecountdiff.param.interval_post;
    str_intvl = sprintf('pre:[%g %g],post:[%g %g]s',intvl_pre, intvl_post);
    %Calculate mean baseline rate
    baselineRate_all = calc_population_stat(cur_node.baselineRate);
    baselineRate_fano = baselineRate_all.var/baselineRate_all.mean;
    str_baselineRate = sprintf('%3.2g(%3.2g)Hz,F:%3.2g',baselineRate_all.mean,...
        baselineRate_all.SD,baselineRate_fano);
    
    %Fitting
    ttl_str_fit = '';fit_method='';
    if strcmp(stim_type, 'LightStep_20')
        %linear regression-slope in log-log plot
        fit_result = loglog_linfit(dat);
        if isempty(fit_result)
            ttl_str_fit = sprintf('slope:%4.2g',fit_result.slope);
            fit_method = 'linear';
        end
    elseif strcmp(stim_type, 'LightStep_5000')
        fit_result = threshold_polyfit(dat);
        fit_method = 'thresholdpolynom';
        ttl_str_fit = sprintf('thresh:%4.2g',fit_result.thresh);
    end
    
    %title
    ttl_str = fig_para.title.string;
%     if exist(fit_result,'var') && ~isempty(fit_result)
%         fig_para.title.string = sprintf('%s:%s,%s,slope:%4.2g',fig_para.title.string,str_baselineRate,str_intvl,fit_result.slope);
%         add_linfit = true;
%         
%     else
        fig_para.title.string = sprintf('%s:%s,%s,%s',fig_para.title.string,str_baselineRate,str_intvl, ttl_str_fit );
        add_linfit = false;
%     end
    %% Plots
    fig_para.xlabel.string = 'Rstar'; 
    fig_para.ylabel.string = 'Spike Count Difference';
    fig_para.line_prop_single.marker = 'x';
    %Spike count 
    if  ~isfield(fig_para,'axis_prop')||~isfield(fig_para.axis_prop,'yscale')||isempty(fig_para.axis_prop) 
        fig_para.axis_prop.xscale = 'log';
    end
    
    %Y-axis scale-if it's not specified, chosen below
    if ~isfield(fig_para,'axis_prop')||~isfield(fig_para.axis_prop,'yscale')||isempty(fig_para.axis_prop) 
        if ~isempty(dat.y(dat.y>0)) %If there is positive data (that's what you expect)
            fig_para.axis_prop.yscale = 'log';
        else %OFF-T may give negative spikes count difference due to rebound
            fig_para.axis_prop.yscale = 'linear';
        end
    end
    %fig_para.title.string = 'Log-log';
    [fig_para.axis_prop.xlim, fig_para.axis_prop.ylim]=...
        get_axislim( dat, fig_para.axis_prop.xscale, fig_para.axis_prop.yscale);    
    [fig_para.ngph, FH, ~] = tile_graph(dat,fig_para, @plot, fig_para.ngph, fig_para.FHoffset);
    %plot fitted line
    if ~isempty(fit_method)
        fig_para.line_prop_single.marker = 'none';
        fig_para.ngph = fig_para.ngph-1;
        [fig_para.ngph, FH, ~] = tile_graph(fit_result,fig_para, 'holdOnPlot', fig_para.ngph, fig_para.FHoffset);
    end
    %% Only for 
    
    %store measured values for output
    measures = v2struct(fit_result, baselineRate_all);
    %For the next plot
    fig_para.title.string = ttl_str;%put back to original string
    ngph = fig_para.ngph;%legacy from the old code     
end

