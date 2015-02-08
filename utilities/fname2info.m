function [rig, exp_date] = fname2info( fname )
%Get date and rig from the file name of Symphony
%   Detailed explanation goes here
    if nargin == 0
        fname = '/Users/dtakeshi/rawData/012715Ac1.h5';
    end
    [file_path, file_name, ext]=fileparts(fname);
    rig_idx = find(file_name>='A' & file_name<='Z');
    rig = file_name(rig_idx);
    str = file_name(1:rig_idx-1);
    if length(str)==6
        yr = str2num(str(5:6))+2000;%Asuume no symphony before 2000:)
        mth = str2num(str(1:2));
        dt = str2num(str(3:4)); 
    end
    try
    exp_date = [yr, mth, dt];
    catch
        2;
    end
end

