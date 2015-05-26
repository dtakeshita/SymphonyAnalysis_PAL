function out = readIntensityMeasurement( exp_date )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if nargin==0%tst  purpose
        exp_date = [2015,1,27];
        
    end
    file_root = fullfile(getenv('HOME'),'Dropbox','AlaLaurila-Lab-Yoda');
    rig_folder = 'Patch rig';
    %file_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig';
    fname = 'IntensityMeasurements.xlsx';
    [ndata, text, table] = xlsread(fullfile(file_root,rig_folder,fname));
    field_names = get_field_names(table(1,:));
    values = table(2:end,:);
    values_map = containers.Map(field_names,mat2cell(values,size(values,1),ones(1,size(values,2))));
    date_str = datestr([exp_date 0 0 0]);
    idx_measured = find(cellfun( @(x)datetime(x,'ConvertFrom','excel')<=date_str,...
        table(2:end,1)),1,'last');
    try
    out.Voltage = get_value(values_map, 'Voltage', idx_measured);
    out.Power = get_value(values_map, 'Power', idx_measured);
    out.DiameterX = get_value(values_map, 'DiameterX', idx_measured);
    out.DiameterY = get_value(values_map, 'DiameterY', idx_measured);
    catch
        2;
    end
    
end

function value = get_value(values_map,key,idx)
    tmp = values_map(key);
    value = tmp(idx);
    value = value{:};
end

function field_names = get_field_names(field_names)
    for n=1:length(field_names)
        tmp = field_names{n};
        if any(isspace(tmp))
            field_names{n} = pick_str(tmp,tmp(1),' ',0,1);
        end     
    end
end
