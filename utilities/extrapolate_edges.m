%Get rid of "dark noise" by extrapolating both edges of power spectrum
function [pow_out_lin, pow_out_log]=extrapolate_edges(pow, lambda)
%% Test purpose
% close all;
% path = '/Users/dtakeshi/Documents/MATLAB/PhotoIsomerizationRate/Patch rig/Test';
% fname = 'spectrum_test.mat';
% load(fullfile(path,fname));%sp_pow & sp_lambda are loaded
% pow = sp_pow; lambda = sp_lambda;
%% funciton main
pow_log = log10(abs(pow));%Negative values (noise) are converted to positive for convenence
[val_max, idx_max] = max(log10(abs(pow)));
lambda_max = lambda(idx_max);
idx = find(pow_log>val_max-2 & pow_log<val_max-1 & ...
            lambda > lambda_max - 50 & lambda < lambda_max + 50 );
idx_L = idx(idx < idx_max);
idx_R = idx(idx > idx_max);
lambda_L = lambda(idx_L); pow_L = pow_log(idx_L);
lambda_R = lambda(idx_R); pow_R = pow_log(idx_R);
%% linear fit
p_L = polyfit(lambda_L, pow_L, 1);
p_R = polyfit(lambda_R, pow_R, 1);
pow_L = p_L(1)*lambda_L + p_L(2);
pow_R = p_R(1)*lambda_R + p_R(2);

%% extrapolation
lambda_Ext_L = lambda(1:idx_L-1);
lambda_Ext_R = lambda(idx_R+1:end);
pow_Ext_L = p_L(1)*lambda_Ext_L + p_L(2);
pow_Ext_R = p_R(1)*lambda_Ext_R + p_R(2);
lambda_out = lambda;pow_out_log = pow_log;
lambda_out(1:idx_L-1) = lambda_Ext_L;
lambda_out(idx_R+1:end) = lambda_Ext_R;
pow_out_log(1:idx_L-1) = pow_Ext_L;
pow_out_log(idx_R+1:end) = pow_Ext_R;
pow_out_lin = 10.^pow_out_log;

% plot(lambda, pow_log,'x')
% hold on
% plot(lambda_L,pow_L,'r')
% plot(lambda_R,pow_R,'r')
% plot(lambda_out, pow_out,'k')

