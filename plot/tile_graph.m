function [ngph, FH, AH, LH, GH] = tile_graph( dat, para_fig, h_plot, ngph, FHoffset, varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if nargin >= 6
        dat_extra = varargin{1};
    else
        dat_extra = '';
    end
    nrow = para_fig.nrow; ncol = para_fig.ncol;
    nTotalGraphs = para_fig.nTotalGraphs;
    ngph_fig = nrow*ncol;
    [FH,GH]=get_subplot_id(nrow,ncol,ngph);
    FH = FH + FHoffset;
    
    figure(FH);
    if isfield(para_fig, 'fig_prop')
       set(FH,para_fig.fig_prop);
    end
    AH = subplot(nrow,ncol,GH);
    %plot
    if isa(h_plot,'function_handle') 
        LH = execute_func(dat, h_plot, dat_extra);
    elseif ischar(h_plot)
        LH = eval_string(dat, h_plot, dat_extra);
    else %assume lind handle
        LH = copyobj(h_plot, AH);
    end
    %Set legend
    if isfield(dat,'legend')
        leg = legend(dat.legend.string);
        set(leg,dat.legend);
    end
    % formatting
    %axes and lines
    if isfield(para_fig,'axis_prop')
        axis_prop = para_fig.axis_prop;
    else
        axis_prop = struct([]);
    end
    if isfield(para_fig,'line_prop')%applied to all the line handles
        line_prop = para_fig.line_prop;
    else
        line_prop = struct([]);
    end
    if isfield(para_fig,'line_prop_single')
        set(LH,para_fig.line_prop_single);
    end
        
    plot_format(axis_prop,line_prop,gcf,AH);%(axisProp,lineProp,FH,AH)
    % Set labels
    try
    set_label(para_fig, 'xlabel');
    set_label(para_fig, 'ylabel');
    set_label(para_fig, 'title');
    catch
        2;
    end
    
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

function LH = eval_string(dat, h_func, dat_extra)
    switch lower(h_func)
        case 'holdonplot' %to superpose plots on previous graph
            hold on
            LH =  plot(dat.x, dat.y);
        case 'holdonscatter'
            hold on
            LH =  plot(dat.x, dat.y);
            set(LH,'LineStyle','none','Marker','o')
        case 'donothing'
            LH =[];
    end
end

function LH = execute_func(dat, h_func, dat_extra)
    switch lower(func2str(h_func))
        case 'plot'
            if ~iscell(dat.x)
                LH = h_func(dat.x, dat.y);
            else
                hold on
                LH = cellfun(@(x,y)plot(x,y),dat.x,dat.y,'UniformOutput',false);
            end
        case 'errorbar'
            LH = h_func(dat.x, dat.y, dat.y_error);
        case 'holdonplot'
            hold on
            LH =  plot(dat.x, dat.y)
        case 'plotepochdata'
            %dat is a structure
            LH = dat.analysisClass.plotEpochData(dat.currNode,dat.cellData,dat.device,dat.idx);
    end
end
