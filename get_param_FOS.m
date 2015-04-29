function param = get_param_FOS( stimulus_name,varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if nargin==0
        stimulus_name = 'LightStep_5000';
    end
    switch stimulus_name
        case 'LightStep_20'
            def_n_epoch_min=30;
            def_binwidth = 10;
            def_twindow = 400;
            def_offset_post = 0;
        case 'LightStep_5000'
            def_n_epoch_min=5;
            def_binwidth = 50;
            def_twindow = 1000;
            def_offset_post = 0;
    end
    p = inputParser;
    addOptional(p,'twindow',def_twindow ,@isnumeric);
    addOptional(p,'offset_post',def_offset_post ,@isnumeric);
    addOptional(p,'n_epoch_min',def_n_epoch_min,@isnumeric);
    addOptional(p,'binwidth',def_binwidth,@isnumeric);
    parse(p,varargin{:});
    param = p.Results;
    %param = v2struct(n_epoch_min,binwidth,twindow);
end

