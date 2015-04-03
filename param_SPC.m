function param = param_SPC( stimulus_name )
%Parameters for spike count
%   Detailed explanation goes here
    switch stimulus_name
        case 'LightStep_20'
            n_epoch_min=30;
            twindow = 400;
        case 'LightStep_5000'
            n_epoch_min=4;
            twindow = 400; %msec
            
    end

end

