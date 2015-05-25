function isorate_sum = intensity2Rstar(pd_Watt, diam_stim)
% Attempt to calculate photoisomerization rate
% Adapted from /Photoisomerization/IntensityCalibration.m

if nargin == 0
    clear; close all;
    plot_flag = false;
    % Photodiode measurement
    pd_Watt = 1.91;%micro Watts
    % Parameters
    diam_stim = 586;%micro meters
end
data_dir = '/Users/dtakeshi/Documents/MATLAB/PhotoIsomerizationRate/Patch rig/Test';
fname = 'blu5V_averaged.txt';
pd_Watt = pd_Watt * 1.0e-6;%Watts to micro watts
file_list = {fullfile(data_dir, fname)};
nfiles = length(file_list);
r_stim = diam_stim/2;
area_stim = pi*(r_stim*10^-6)^2;
area_CC3 = 0.119459061*1.46;%in cm2--Need correction here as well?
%rod_eff_area = 0.85;%um^2, collective area of rod (Naarendorp et al.(2010))
rod_eff_area = 0.5;%um^2, collective area of rod (Murphy & Rieke (2011))
lambdaMax = 497;%Toda et al. 1999
for nf = 1:nfiles
    % Load spectrum (right now the data has to be matrix format witout
    % comma. make this work for orignal spectrum files from spectrometer)
    sp = load(file_list{nf});
    sp_lambda = sp(:,1);
    sp_dlambda = diff(sp_lambda);%spacing is not uniform.On can interpolate
    sp_dlambda(end+1) = sp_dlambda(end);%assume last d(lambda) is the same as one before...
    sp_pow = sp(:,end);%assume last column is spectrum data
    % Angle correction
    sp_pow = angle_correction(sp_pow, sp_lambda);
    % Need to extrapolate the spectrumtrum
    sp_pow = extrapolate_edges(sp_pow, sp_lambda);
    % Integral of corrected spectrum (=light intensity per unit area)
    intsty = sum(sp_pow.*sp_dlambda);
    % Normalize power spec
    sp_normpow = sp_pow/sum(sp_pow.*sp_dlambda);
    % Convert to absolute intensity per unit area
    sp_abs = pd_Watt * sp_normpow;
    % convert to absolute intentisy-check angle correction for area
    % sp_int_abs = sp_abs*area_CC3;%should be in W/nm-unnecessary for
    % photodiode case??
    sp_int_perA = sp_abs/area_stim;% should be in W/nm/m2
    % Convert into photon flux
    ph = I2Photon(sp_int_perA, sp_lambda,sp_dlambda);
    % Rod absorbonce spetrum (normalized at lambdaMax)
    rod_abs = myGovardovskiiNomogram(sp_lambda,lambdaMax)';
    isorate = ph.*rod_abs*(rod_eff_area*1e-12);
    isorate_sum = sum(isorate);
    iso_str = sprintf('%s%e','R*/rod/sec=',isorate_sum);
    display(iso_str);
    
    %% calibration curve from photodiode
%     cd(pd_dir);
%     pd_data = load( filename_photodiodesensitivity );
%     pd_lambda = pd_data(:,1);
%     pd_AperW = pd_data(:,2);

    % loading size-vs-intensities file
    % intensity value in nW

end
% options.Interpreter = 'none';
% options.Default = 'No';
% % Create a TeX string for the question
% qstring = 'Save the results as an excel file?';
% choice = questdlg(qstring,'Save?','Yes','No',options);
% if strcmp(choice,'Yes')
%     cd(save_dir)
%     xlswrite('summary.xlsx',summary,date);
% end


