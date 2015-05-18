function [ FH, fig_para ] = plot_across_celltype( dat, celltypeList, fig_para, splitter,varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 0 %test purpose
        close all;
        load(fullfile('/Users/dtakeshi/analysis/summaryPlots/AcrossCells','test.mat'));%cellType_unique & spc_perR_max are loaded
        dat = spc_perR_max;
        celltypeList = cellType_unique;
        splitter = {'on alpha','off sustained alpha','off transient alpha'};
        fig_para.ncol = 3; fig_para.nrow = 2;
        fig_para.FHoffset = 0; fig_para.ngph = 1;
        fig_para.nTotalGraphs = 3;
        fig_para.xlabel.string = 'R*';
        fig_para.ylabel.string = 'SPC/R* max';
        fig_para.axis_prop.xscale = 'log';fig_para.axis_prop.yscale = 'log';
    end
    if nargin >=5
        mean_opt = varargin{1};
    else
        mean_opt = 'arithmaticmean';
    end
    cl = {'r';'k'};%plot color
    FH = ''; %to avoid error when nothing is plotted
    for ns=1:length(splitter)
        celltypeName = lower(splitter{ns});
        idx = cellfun(@(x)~isempty(strfind(lower(x),celltypeName)),celltypeList);
        celltype_plot = celltypeList(idx);
        dat_plot = dat(idx);
        n_plot = length(dat_plot);
        LHs = zeros(n_plot,1);
        yscale_changed = false;
        y_mean = zeros(n_plot,1);
        for np=1:n_plot
%             tmp_dat.x = [dat_plot{np}.x];%convert structure to array
%             tmp_dat.y = [dat_plot{np}.y];
            [tmp_dat.x, tmp_dat.y] = datStruct2vec(dat_plot{np});
            tmp_celltype = celltype_plot{np};
            if ~isempty(strfind(tmp_celltype,'+/+'))
                fig_para.line_prop_single.MarkerFaceColor = cl{1};
            else
                fig_para.line_prop_single.MarkerFaceColor = cl{2};
            end
            fig_para.line_prop_single.MarkerEdgeColor = fig_para.line_prop_single.MarkerFaceColor;
            fig_para.title.string = celltypeName;
            %Temp hack-avoid log scale if thare are too many negative numbers
            if isfield(fig_para.axis_prop,'yscale')
                try
                [fig_para.axis_prop.yscale, yscale_old] = change_axscale(tmp_dat.y, fig_para.axis_prop.yscale);
                yscale_changed = true;
                catch
                    2;
                end
            end
            [fig_para.ngph, FH, AH, LHs(np)] = tile_graph(tmp_dat,fig_para, 'holdOnScatter', fig_para.ngph, fig_para.FHoffset);
            fig_para.ngph = fig_para.ngph-1;%To superpose plots
            if strcmp(mean_opt,'arithmaticmean')
                y_mean(np) = nanmean(tmp_dat.y);%Ignore NaN
            elseif strcmp(mean_opt,'geometricmean')
                y_mean(np) = geomean(tmp_dat.y(~isnan(tmp_dat.y)));
            end
        end
  
        str_legend = cellfun(@(x)x(5:7),celltype_plot,'uniformoutput',false);
%         LHs = LHs(LHs>0);%Choose actual handle
%         str_legend(LHs>0);
        try
            legend(LHs,celltype_plot)
            legend( LHs,str_legend )
        catch
            2;
        end
        if yscale_changed
            fig_para.axis_prop.yscale = yscale_old;%change back to the original axis property
        end
        fig_para.ngph = fig_para.ngph+1;%move on to the next graph
        y_ratio = y_mean(1:end-1)/y_mean(end);
        h_ttl = get(gca,'title');
        if strcmp(mean_opt,'arithmaticmean')
            str_ttl = sprintf('%s, yratio:%4.2g',h_ttl.String, y_ratio);
        elseif strcmp(mean_opt,'geometricmean')
            str_ttl = sprintf('%s,yratio(geomean):%4.2g',h_ttl.String, y_ratio);
        end
        set(h_ttl,'string',str_ttl);
    end
    %clear labels, axis & line properties for the next plot
    clear_props(fig_para,{'axis_prop','line_prop','line_prop_single'});
end

function [x,y] = datStruct2vec(dat)
    ndat = length(dat);
    x=NaN*ones(1,ndat); 
    y=x;
    for nd=1:ndat
        if isempty(dat(nd).x)||isempty(dat(nd).y)
            continue;
        else
           x(nd) = dat(nd).x;
           y(nd) = dat(nd).y;
        end
    end

end

function p = clear_props(p,f)
    for nf = 1:length(f)
        clear_prop(p,f{nf});
    end
end

function p = clear_prop(p,f)
    if isfield(p,f)
       p = rmfield(p,f); 
    end

end
function [scale_new, scale_old] = change_axscale(dat, opt)
    scale_old = opt;
    if strcmp(opt,'log') && (sum(dat<0) > sum(dat>0))
        scale_new = 'linear';
    else
        scale_new = opt;
    end
end
