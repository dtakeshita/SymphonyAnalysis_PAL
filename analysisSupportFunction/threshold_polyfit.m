function out = threshold_polyfit(dat)
    if nargin==0
        close all;
       %WT-ON
%        mouse = 'WT-ON:030315Ac12';
%        dat.x = [
%                        0
%        0.099085199724431
%        0.297255599173293
%        0.709147878757237
%        1.526571291731537
%        3.039356996459430
%        5.722847866593350
%        ];
%        dat.y = 1.0e+02 *...
%        [
%        0.038000000000000
%        0.120000000000000
%        0.548000000000000
%        1.606000000000000
%        3.204000000000000
%        3.784000000000000
%        4.412000000000000
%        ];
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
       mouse = 'OPN-ON:022415Ac4';
       dat.x=[
           0
           0.099851310057327
       0.299553930171981
       0.714630892557262
       1.538374487806740
       3.062856800737198
       5.767095977273686
       ];
       dat.y = 1.0e+02 *...
       [
       -0.026000000000000
       0.003333333333333
       0.014000000000000
       0.066000000000000
       0.378000000000000
       1.302000000000000
       2.002000000000000
       ];
    %    %030315Ac4
%        mouse = 'OPN-ON:030315Ac4';
%        dat.x=[
%        0
%        0.099085199724431
%        0.297255599173293
%        0.709147878757237
%        1.526571291731537
%        3.039356996459430
%        5.722847866593350
%        ];
%         dat.y = 1.0e+02*...
%        [
%        0.128000000000000
%       -0.002000000000000
%        0.056000000000000
%        0.134000000000000
%        0.298000000000000
%        1.670000000000000
%        9.332000000000001
%        ];
    else
        mouse ='';
    end

    %para_init = [0 10 0.1 2]%y=y0 + a*(x-theta).^n
    para_init = [1 0.1 1];%y = a*(x-theta).^n

    npt = length(dat.x);
    npara = length(para_init);
    nfit = npt-npara+1;
    if nfit == 0
        out.x = []; out.y=[];
        out.thresh = NaN;
        return
    end
    err = zeros(nfit,1);
    ndat = err;
    optpara_set = zeros(nfit,npara);
    for n = npara:npt
        datfit_x = dat.x(1:n);datfit_y = dat.y(1:n);
        para_opt = fminsearch(@(p)threshold_polyfit_objfun(p, datfit_x, datfit_y),para_init);
        datfit_y_eval = eval_fit(datfit_x,para_opt);
        %store data
        ndat(n-npara+1) = n;
        err(n-npara+1) = norm(datfit_y-datfit_y_eval)/n;
        optpara_set(n-npara+1,:) = para_opt;
        if nargin==0
           xfit = 0:0.0001:max(datfit_x);
           yfit = eval_fit(xfit,para_opt);
           plot(xfit,yfit)
           hold on
           plot(datfit_x,datfit_y,'o')
           set(gca,'yscale','log')
        end
    end
    %[err_min,idx_min] = min(err);%consider:avoid negative value??
    %Avoid negative threshold
    th_set = get_thresh(optpara_set);
    idx_pos = find(th_set>0);
    [err_min,idx_min] = min(err(idx_pos));
    idx_min = idx_pos(idx_min);
    
    datfit_x = dat.x(1:ndat(idx_min));
    datfit_y = dat.y(1:ndat(idx_min));
    optpara = optpara_set(idx_min,:);
    xfit = 0:0.0001:max(datfit_x);
    yfit = eval_fit(xfit,optpara);
    
    out.x = xfit; out.y=yfit;
    out.thresh = get_thresh(optpara);
    
    if nargin==0
        figure
        plot(dat.x,dat.y,'bo','MarkerSize',6)
        hold on
        plot(xfit,yfit)
        set(gca,'xscale','linear','fontsize',15)
        if npara == 4
            theta = optpara(3);
        elseif npara == 3
            theta = optpara(2);
        end
        vlines(theta,gca,'r',ylim)
        xlabel('R*/rod');ylabel('Spike count');
        str_ttl = sprintf('%s Thresh=%g',mouse,theta);
        title(str_ttl)
    end
end
function th = get_thresh(para)
    [nset,npara] = size(para);
    if npara==4
        th = para(:,3);
    elseif npara==3
        th = para(:,2);
    else
        th = NaN*ones(nset,1);
    end
end
function yfit = eval_fit(x,para)
    yfit = zeros(size(x));
    if length(para)==4
        y0 = para(1);a=para(2);theta=para(3);n=para(4);
        yfit(x>theta) = y0 + a*(x(x>theta)-theta).^n;
    elseif length(para)==3
        a=para(1);theta=para(2);n=para(3);
        yfit(x>theta) = a*(x(x>theta)-theta).^n;
    end
end
