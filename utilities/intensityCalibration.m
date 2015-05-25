% Attempt to calculate photoisomerization rate
clear; 
close all;
plot_flag = false;
data_dir = '/Users/dtakeshi/Documents/MATLAB/PhotoIsomerizationRate/Patch rig/Test';
save_dir = 'F:\Data\LightIntensity\';
cd(data_dir);
file_list = uigetfile('*.txt','multiselect','off');%for the moment doesn't work for multiple measurements
if ~iscell(file_list)
    file_list = {file_list};
end
nfiles = length(file_list);
% Photodiode measurement
pd_Watt = 1.8e-6;%Watts
%pd_Watt = 5e-9;%From Cararo's note
% Parameters
r_stim = 570/2;%micro meters
area_stim = pi*(r_stim*10^-6)^2;
area_CC3 = 0.119459061*1.46;%in cm2--Need correction here as well?
rod_eff_area = 0.85;%um^2, collective area of rod (Naarendorp et al.(2010))
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
    ph_flux = ph*1e-12;%photons/um2
    ph_flux_str = sprintf('%s%e photons/um2/sec/V','photon flux=',sum(ph_flux))
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


