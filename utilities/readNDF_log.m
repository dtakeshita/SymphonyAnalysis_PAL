function [t_switch, NDF] = readNDF_log(rig, exp_yr, exp_date)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 0
        exp_yr = '2015';
        exp_date = '0127';
    end
    file_root = '/Users/dtakeshi/Documents/Data';
    rig_folder = ['Rig',upper(rig)];
    log_folder = 'NDF_log';
    fname = sprintf('NDFlog_%s_%s',exp_yr,exp_date);
    [ndata, text, alldata] = xlsread(fullfile(file_root,rig_folder,log_folder, fname));
    t_switch = ndata(:,1);%time when NDFs are switched
    NDF = alldata(2:end,2:end);
    %cellfun(@(x)~all(isnan(x)),NDF);
    NDF = cellfun(@num2str,NDF,'uniformoutput',false);%convert to string 
end

