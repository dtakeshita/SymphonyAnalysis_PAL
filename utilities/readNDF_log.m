function [t_switch, NDF] = readNDF_log(rig, exp_date)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 0
        rig = 'a';
        exp_date = [2015,1,27];
    end
    file_root = '/Users/dtakeshi/Documents/Data';
    rig_folder = ['Rig',upper(rig)];
    log_folder = 'NDF_log';
    fname = sprintf('NDFlog_%d_%02i%02i',exp_date);
    [ndata, text, alldata] = xlsread(fullfile(file_root,rig_folder,log_folder, fname));
    t_switch = ndata(:,1);%time when NDFs are switched
    NDF = alldata(2:end,2:end);
    %cellfun(@(x)~all(isnan(x)),NDF);
    NDF = cellfun(@num2str,NDF,'uniformoutput',false);%convert to string 
end

