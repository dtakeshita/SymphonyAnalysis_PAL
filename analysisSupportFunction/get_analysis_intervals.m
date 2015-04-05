function [ idx_pre, idx_post, param] = get_analysis_intervals( xvalue, stim_duration, param )
%calculate indices for pre & post time intervals for analysis
%xvalue:time vector (sec), stim_duration: stimulus duration (sec)
%param:parameters. twindow:length of time window (msec),
%twindow_offset_pre: offset for pre time window (optional)
%   Detailed explanation goes here
    if nargin == 0;
       param.twindow = 1000;%msec
       param.twindow_offset_post = 1000;%msec
       param.twindow_offset_pre = 0;%msec
       stim_duration = 5;%sec
       xvalue = -5:0.01:5;
    end
    v2struct(param);
    %one could use inputperser in the future
    %convert from msec to sec, except for stimulus duration
    twindow = twindow/1000;
    if ~exist('twindow_offset_pre','var')
        twindow_offset_pre = 0;
    else
        twindow_offset_pre = twindow_offset_pre/1000;
    end
    if ~exist('twindow_offset_post','var')
        twindow_offset_post = 0;
    else
        twindow_offset_post = twindow_offset_post/1000;
    end
    
    if twindow > stim_duration
        t_st_pre = -twindow + twindow_offset_pre;
        t_st_post = stim_duration+twindow_offset_post;%stimulus offset
    else
        t_st_pre = -twindow + twindow_offset_pre;
        t_st_post = twindow_offset_post;%stimulus onset
    end
    idx_pre =   t_st_pre <= xvalue  & xvalue < t_st_pre + twindow;
    idx_post =  t_st_post <= xvalue  & xvalue < t_st_post + twindow;
    param.interval_pre = [t_st_pre t_st_pre + twindow];
    param.interval_post = [t_st_post t_st_post + twindow];
end

