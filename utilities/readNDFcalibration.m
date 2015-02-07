function table = readNDFcalibration(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    file_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig';
    fname = 'NDFcalibration.xlsx';
    [ndata, text, table] = xlsread(fullfile(file_path,fname));
    
end

