function [ x_lim, y_lim ] = get_axislim( dat, xscale, yscale)
%Calculcate axis limits
%   Detailed explanation goes here
    switch lower(xscale)
        case 'log'
            x_tmp = dat.x(dat.y>0);
            if ~strcmpi(yscale,'log') || isempty(x_tmp)
               x_tmp = dat.x; 
            end
            x_left = 10^floor(log10(min(x_tmp)));
            x_right = 10^ceil(log10(max(x_tmp)));
        case 'linear'%Not done yet
            x_min = min(dat.x); x_max = max(dat.x);
            %% need to take care of negative values
            %% If x_min <0, take absolute value and ceil and invert the sign
            log_min = log10(min(dat.x));
            d = 10^floor(log_min);
            if log_min < 0
                x_left = floor(x_min*d)/d;
            elseif log_min > 0
                x_left = floor(x_min/d)*d;
            else %x=1
                x_left = 0;
            end
            
            
            log_max = log10(max(dat.x));
            d = 10^ceil(log_max);
            if log_max < 0
                x_right = ceil(x_max/d)*d;
            elseif log_max > 0
                x_right = ceil(x_max*d)/d;
            else %x=1
                x_right = 1;
            end
    end
    x_lim = [x_left x_right];
    switch lower(yscale)
        case 'log'
            y_tmp = dat.y(dat.y>0);
            if ~isempty(y_tmp)
                y_btm = 10^floor(log10(min(y_tmp)));
                y_top = 10^ceil(log10(max(y_tmp)));
            else
                y_btm = -Inf; y_top = Inf;
            end
        case 'linear'
            %to be completed-should be same as x case
            y_btm = -Inf; y_top = Inf;
    end
    y_lim = [y_btm y_top];
    

end

