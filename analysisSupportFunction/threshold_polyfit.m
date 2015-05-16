function threshold_polyfit(dat)
close all;
if nargin==0
   %WT-ON
   mouse = 'WT-ON:030315Ac12';
   dat.x = [
                   0
   0.099085199724431
   0.297255599173293
   0.709147878757237
%    1.526571291731537
%    3.039356996459430
%    5.722847866593350
   ];
   dat.y = 1.0e+02 *...
   [
   0.038000000000000
   0.120000000000000
   0.548000000000000
   1.606000000000000
%    3.204000000000000
%    3.784000000000000
%    4.412000000000000
   ];
   %WT-ON
%    mouse ='WT-ON:042315Ac13';
%    dat.x = [0.023745456137860
%    0.054999930236914
%    0.114951574254528
%    0.224516423517919
%    ];
%    dat.y = [3.666666666666667
%   15.600000000000000
%   22.600000000000001
%   48.200000000000003
%   ];
%    %OPNON-022415Ac4
%    mouse = 'OPN-ON:022415Ac4';
%    dat.x=[0
%        0.099851310057327
%    0.299553930171981
%    0.714630892557262
%    1.538374487806740
%    3.062856800737198
%    %5.767095977273686
%    ];
%    dat.y = 1.0e+02 *...
%    [-0.026000000000000
%    0.003333333333333
%    0.014000000000000
%    0.066000000000000
%    0.378000000000000
%    1.302000000000000
%    %2.002000000000000
%    ];
%    %030315Ac4
%    mouse = 'OPN-ON:030315Ac4';
%    dat.x=[
%    %0
%    0.099085199724431
%    0.297255599173293
%    0.709147878757237
%    1.526571291731537
%    %3.039356996459430
%    %5.722847866593350
%    ];
%     dat.y = 1.0e+02*...
%    [
%    %0.128000000000000
%   -0.002000000000000
%    0.056000000000000
%    0.134000000000000
%    0.298000000000000
%    %1.670000000000000
%    %9.332000000000001
%    ];
end
%para_init = [0 10 0.1 2]%y=y0 + a*(x-theta).^n
para_init = [1 0.1 1];%y = a*(x-theta).^n
para_opt = fminsearch(@(p)threshold_polyfit_objfun(p, dat.x,dat.y),para_init);

xfit = 0:0.0001:max(dat.x);
yfit = zeros(size(xfit));
if length(para_init)==4
    y0 = para_opt(1);a=para_opt(2);theta=para_opt(3);n=para_opt(4);
    yfit(xfit>theta) = y0 + a*(xfit(xfit>theta)-theta).^n;
elseif length(para_init)==3
    a=para_opt(1);theta=para_opt(2);n=para_opt(3);
    yfit(xfit>theta) = a*(xfit(xfit>theta)-theta).^n;
end
plot(dat.x,dat.y,'bo','MarkerSize',6)
hold on
plot(xfit,yfit)
set(gca,'xscale','linear','fontsize',15)
vlines(theta,gca,'r',ylim)
xlabel('R*/rod');ylabel('Spike count');
str_ttl = sprintf('%s Thresh=%g',mouse,theta);
title(str_ttl)

end