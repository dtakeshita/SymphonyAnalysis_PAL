function [ FH, fig_para ] = plot_across_celltype( dat, celltypeList, fig_para, splitter )
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
            try
            tmp_dat.x = [dat_plot{np}.x];%convert structure to array
            tmp_dat.y = [dat_plot{np}.y];
            catch
                2;
            end
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
                [fig_para.axis_prop.yscale, yscale_old] = change_axscale(tmp_dat.y, fig_para.axis_prop.yscale);
                yscale_changed = true;
            end
            [fig_para.ngph, FH, AH, LHs(np)] = tile_graph(tmp_dat,fig_para, 'holdOnScatter', fig_para.ngph, fig_para.FHoffset);
            fig_para.ngph = fig_para.ngph-1;%To superpose plots
            y_mean(np) = nanmean(tmp_dat.y);%Ignore NaN
        end
        str_legend = cellfun(@(x)x(5:7),celltype_plot,'uniformoutput',false);
        %legend(LHs,celltype_plot)
        legend( LHs,str_legend )
        if yscale_changed
            fig_para.axis_prop.yscale = yscale_old;%change back to the original axis property
        end
        fig_para.ngph = fig_para.ngph+1;%move on to the next graph
        y_ratio = y_mean(1:end-1)/y_mean(end);
        h_ttl = get(gca,'title');
        str_ttl = sprintf('%s, yratio:%4.2g',h_ttl.String, y_ratio);
        set(h_ttl,'string',str_ttl);
        
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