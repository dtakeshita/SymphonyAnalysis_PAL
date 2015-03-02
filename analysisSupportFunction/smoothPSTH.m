function [psth, smoothingWindow_pts]  = smoothPSTH( x, psth, smoothingWindow )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if smoothingWindow % in msec
        binWidth = x(2)-x(1);%Should be in sec
        smoothingWindow_pts = round(smoothingWindow*1e-3/binWidth ); %for psth
        %counts = filter(ones(1,smoothingWindow_pts)/smoothingWindow_pts,1,counts,[],2);
        w = gausswin(smoothingWindow_pts);
        w = w/sum(w);
        psth = conv(psth,w,'same');
    else
        smoothingWindow_pts = 0;%no smoothing
    end
end

