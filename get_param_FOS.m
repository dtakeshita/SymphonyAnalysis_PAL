function param = get_param_FOS( stimulus_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    switch stimulus_name
        case 'LightStep_20'
            n_epoch_min=30;
            binwidth = 10;
            twindow = 400;
        case 'LightStep_5000'
            n_epoch_min=5;
            binwidth = 50;
            twindow = 4000;
            
    end
    param = v2struct(n_epoch_min,binwidth,twindow);
end

