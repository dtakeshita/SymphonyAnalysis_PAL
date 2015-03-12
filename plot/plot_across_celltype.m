function [ output_args ] = plot_across_celltype(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    load(fullfile('/Users/dtakeshi/analysis/summaryPlots/AcrossCells','test.mat'));%cellType_unique & spc_perR_max are loaded
    dat = spc_perR_max;
    celltypeList = cellType_unique;
    splitter = {'on alpha','off sustained alpha','off transient alpha'};
    cl = {'k';'r'};
    for ns=1:length(splitter)
        celltypeName = splitter{ns}
        idx = cellfun(@(x)~isempty(strfind(lower(x),celltypeName)),celltypeList);
        celltype_plot = celltypeList(idx);
        dat_plot = dat(idx);
        figure;
        %do subplot
        hold on
        cellfun(@(celltype,dat,cl)plot_each_subset(celltype,dat,cl), celltype_plot, dat_plot, cl);
        title(celltypeName)
        legend(celltype_plot)
    end
end

function plot_each_subset(cell_type, s_dat,cl)
    dat.x = [s_dat.x];
    dat.y = [s_dat.y];
    plot(dat.x,dat.y,'linestyle','none','Marker','o','MarkerFaceColor',cl,...
            'MarkerEdgeColor',cl)
%     for ns=1:length(dat)
%        plot(dat(ns).x, dat(ns).y,'Marker','o','MarkerFaceColor',cl,...
%            'MarkerEdgeColor',cl)
%     end
    
end