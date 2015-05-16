function e = threshold_polyfit_objfun(param, x,y)
% The objective function to fit wiht y = y0 + a*(x-theta).^n
yfit = zeros(size(x));
if length(param)==4
    y0 = param(1);a=param(2);theta=param(3);n=param(4);
    yfit(x>theta) = y0 + a*(x(x>theta)-theta).^n;
elseif length(param)==3
    a=param(1);theta=param(2);n=param(3);
    yfit(x>theta) = a*(x(x>theta)-theta).^n;
end


%% Calculate RMS error
e = norm(y-yfit);





