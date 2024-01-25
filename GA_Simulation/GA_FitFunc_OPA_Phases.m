function Intensity_ratio = GA_FitFunc_OPA_Phases(phase_off)
    
    %% Parameters
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    k=2*pi/lambda;%wavenumber
    theta_0=0; %theta steering angle
    phi_0=0; %phi steering angle
    theta_90=1; %0 for 0:90/ 1 for -90:90
    ant = 0; %0 for isotropic antenna/ 1 for selected antenna
    res=1; %resolution
    
    %% Sparse array definition
    pos_final = sparse_array_def();

    %% Random phase implementation 
    %x0 = 2*pi*rand(1,15); %random phase matrix between 0-2pi
    %x0 = -1*pi + 1*pi*(1--1)*rand(1,15); %random phase matrix between -pi-pi

    %Calculate AF for random phase and plot intensity
    [Intensity_norm,Intensity_dB,Intensity_max,Intensity_ratio,u,v,theta,phi,SLL]=AF_general(1,1,1,length(pos_final),pos_final,lambda,1,theta_0,phi_0,ant,1,x0);
    
end