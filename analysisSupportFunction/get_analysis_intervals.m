function [ idx_pre, idx_post ] = get_analysis_intervals( xvalue, stim_duration, param )
%calculate indices for pre & post time intervals for analysis
%   Detailed explanation goes here
    if nargin == 0;
       param.twindow = 1000;%msec
       param.twindow_offset_post = 1000;%msec
       param.twindow_offset_pre = 0;%msec
       stim_duration = 5;%sec
       xvalue = -5:0.01:5;
    end
    v2struct(param);
    %one could use inputperser
    if ~exist('twindow_offset_pre','var')
        twindow_offset_pre = 0;
    end
    if ~exist('twindow_offset_post','var')
        twindow_offset_post = 0;
    end
    
    if twindow > stim_duration
        t_st_pre = -twindow + twindow_offset_pre;
        t_st_post = stim_duration+twindow_offset_post;%stimulus offset
    else
        t_st_pre = -twindow + twindow_offset_pre;
        t_st_post = twindow_offset_post;%stimulus onset
    end
    t_st_pre = t_st_pre/1000;%to second
    t_st_post = t_st_post/1000;
    twindow = twindow/1000;
    idx_pre =   t_st_pre <= xvalue  & xvalue < t_st_pre + twindow;
    idx_post =  t_st_post <= xvalue  & xvalue < t_st_post + twindow;

end

