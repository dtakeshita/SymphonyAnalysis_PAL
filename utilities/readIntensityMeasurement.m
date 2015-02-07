function table = readIntensityMeasurement( exp_date )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    file_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig';
    fname = 'IntensityMeasurements.xlsx';
    [ndata, text, table] = xlsread(fullfile(file_path,fname));
    
end

