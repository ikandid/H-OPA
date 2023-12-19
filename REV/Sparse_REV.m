%%REV method for sparse array

%% Parameters
c = 3e8;
fc = 193e12;
lambda = c/fc;
k=2*pi/lambda;%wavenumber
theta_0=2.5; %theta steering angle
phi_0=0; %phi steering angle
theta_90=1; %0 for 0:90/ 1 for -90:90
ant = 0; %0 for isotropic antenna/ 1 for selected antenna
res=1; %resolution
