function out = loglog_linfit( dat )
%Linear regression in log-log plot
%   Detailed explanation goes here
    global ANALYSIS_FOLDER
    if nargin == 0
        cellname = '012715Ac2';
        load(fullfile(ANALYSIS_FOLDER,'analysisTrees', cellname));
        tr = analysisTree;
        stimulus_type = 'LightStep_20';
        idx = find(tr.treefun(@(x)~isempty(strfind(x.name,stimulus_type))));
        cur_tree = tr.subtree(idx);
        param_FOS.n_epoch_min=30;
        param_FOS.binwidth = 10;%Bin size for spike count histogram (in msec)
        param_FOS.twindow = 400;%msec
        cur_tree = calcFOS( cur_tree, param_FOS);%should be done beforehand?
        param_diff.n_epoch_min = 10; param_diff.twindow = 400; %msec
        cur_tree = calcSpikeCountDiff(cur_tree, param_diff);
        cur_node = cur_tree.get(1);
        dat.x = cur_node.spikecountdiff.xvalue;
        dat.y = cur_node.spikecountdiff.mean;
       %From 012715Ac2
%        dat.x = [0.1480 0.3087 0.5903 1.0595 1.8279 3.0349];
%        %dat.y = [0 0.2787 1.9032 8.3548 18.3387 26.0645 ];
%        dat.y = [0 0.2787 1.9032 4.3548 18.3387 26.0645 ];
    end
    if isempty(dat.x) || isempty(dat.y)
       out.x = [];out.y=[];
       out.slope = NaN;
       return;
    end
    %avoid non-positive data
    st = find(dat.y<=0,1,'last');
    if isempty(st)
        st = 1;
    else
        st = st+1;
    end
    X = log10(dat.x(st:end));
    Y = log10(dat.y(st:end));
    try
    slopes = get_slopes(X,Y);
    catch
        2;
    end
    [~,idx_max] = max(slopes);
    ndat = length(slopes);
    %% So far, obtain 3 consecutive points of largest slope
    if idx_max==1
        idx = 1:3;
    elseif idx_max == ndat
        idx = ndat-1:ndat+1;
    else
        try
       if slopes(idx_max-1) < slopes(idx_max+1)
           idx = idx_max:idx_max+2;
       else
           idx = idx_max-1:idx_max+1;
       end
        catch
            2;
        end
    end
    try
    X0 = X(idx); Y0 = Y(idx);
    [X0, Y0] = trim_points(X0,Y0);
    catch
        2;
    end
    %% Note one could trim points here (finish trim_points below)
    p = polyfit(X0,Y0,1);
    Yfit = p(1)*X0 + p(2);
    out.x = 10.^X0; out.y = 10.^Yfit;
    out.slope = p(1);
    %plot-test purpose
%     figure
%     plot(X,Y,'o')
%     hold on
%     plot(X0, Yfit,'k')
end

function [Xnew, Ynew]=trim_points(X,Y)%Finish this!!
    slopes = get_slopes(X,Y);
    [~,idx_max] = max(slopes);
    above = slopes/max(slopes) > 0.5;
    for n=idx_max:length(slopes)
       if above(n)==false
           n = n-1;
           break;
       end
    end
    for m=idx_max:-1:1
       if above(m)==false
           m = n+1;
           break;
       end
    end
    idx_new = union(m:idx_max, idx_max:n);
    idx_new = [idx_new idx_new(end)+1];
    Xnew = X(idx_new); Ynew = Y(idx_new);
end

function slopes = get_slopes(X,Y)
    slopes = (Y(2:end)-Y(1:end-1))./(X(2:end)-X(1:end-1));
end
