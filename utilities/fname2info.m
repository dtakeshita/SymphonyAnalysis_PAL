function [rig, exp_yr, exp_date] = fname2info( fname )
%Get date and rig from the file name of Symphony
%   Detailed explanation goes here
    if nargin == 0
        fname = '/Users/dtakeshi/rawData/012715Ac1.h5';
    end
    [file_path, file_name, ext]=fileparts(fname);
    rig = file_name(end-2);
    str = file_name(1:end-3);
    if length(str)==6
        exp_date = str(1:4);
        exp_yr = str2num(exp_date(5:6))+2000;%Asuume no symphony before 2000:)
    end
end

