function [ngph, FH, LH] = tile_graph( dat, para_fig, h_plot, ngph, FHoffset)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    nrow = para_fig.nrow; ncol = para_fig.ncol;
    nTotalGraphs = para_fig.nTotalGraphs;
    ngph_fig = nrow*ncol;
    [FH,GH]=get_subplot_id(nrow,ncol,ngph);
    FH = FH + FHoffset;
    figure(FH);
    AH = subplot(nrow,ncol,GH);
    %plot
    if isa(h_plot,'function_handle')
        LH = execute_func(dat, h_plot);
    else %assume lind handle
        LH = copyobj(h_plot, AH);
    end
    %Set legend
    if isfield(dat,'legend')
        LH = legend(dat.legend.string);
        set(LH,dat.legend);
    end
    % formatting
    if isfield(para_fig,'axis_prop')
        axis_prop = para_fig.axis_prop;
    else
        axis_prop = struct([]);
    end
    if isfield(para_fig,'line_prop')
        line_prop = para_fig.line_prop;
    else
        line_prop = struct([]);
    end
    plot_format(axis_prop,line_prop,gcf,AH);%(axisProp,lineProp,FH,AH)
    % Set labels
    set_label(para_fig, 'xlabel');
    set_label(para_fig, 'ylabel');
    set_label(para_fig, 'title');
    
    % set figure title as annotation
    if isfield(para_fig, 'annotation')
       ann_txt = para_fig.annotation.string; 
    else
        ann_txt = '';
    end
    ngph = enlargeFigure(ngph, ngph_fig, nTotalGraphs,FH,ann_txt);

end

function set_label(p,name)
    if isfield(p,name)
        set(get(gca,name),p.(name));
    end

end

function LH = execute_func(dat, h_func)
    switch func2str(h_func)
        case 'plot'
            if ~iscell(dat.x)
                LH = h_func(dat.x, dat.y);
            else
                hold on
                LH = cellfun(@(x,y)plot(x,y),dat.x,dat.y,'UniformOutput',false)
            end
        case 'errorbar'
            LH = h_func(dat.x, dat.y, dat.y_error);
    end
end
