function ph = I2Photon( I, lambda, d_lambda )
%I2Photon Convert intensity to # of photons
%   Detailed explanation goes here
    h = 6.63e-34;
    c = 3e+8;
    E = h*c./(lambda*10^-9);%energy of a single photon
    ph = (I.*d_lambda)./E;%Power in the wavelength in [lambda, lambda+d_lambda]/E;


end

