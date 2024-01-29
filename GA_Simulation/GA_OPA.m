clc;
clear;
close all;

%Problem definition
problem.CostFunction = @(x0) GA_FitFunc_OPA_Phases(x0);
problem.nVar = 150;

%GA paramters 
params.nPop = 10;
params.nbits = 10;
params.MaxIt = 400;
params.beta = 1;
params.pC = 1; %percentage of crossover
params.mu = 0.05; %mutation percentage
%params.Nel = (problem.nVar-params.nbits*4)/params.nbits;


%Run GA 

tic
out = RunGA_OPA(problem, params);
toc
%Results

figure;
plot(out.bestcost);
xlabel('Iterations')
ylabel('Best Cost')
grid on;

%plot phases
figure 
scatter(1:15,out.bestsol.var,'o','filled')
xlabel('Channel number')
ylabel('Phase (rad)')
ylim([-1*pi, 1*pi])

phase_corr = out.bestsol.var;

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

%Calculate AF for calibrated phase and plot intensity
theta_0 = 0;
[Intensity_norm,Intensity_dB,Intensity_max,Intensity_ratio,u,v,theta,phi,SLL]=AF_general(1,1,1,length(pos_final),pos_final,lambda,1,theta_0,phi_0,ant,1,phase_corr);
[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta]=theta_cut(1,1,1,length(pos_final),res,0,pos_final,1,theta_0,ant,theta_90,phase_corr);

%%Calculate Ratio
Ideal_Int_ratio = 10.521788643103532;
ML_ratio = Ideal_Int_ratio/Intensity_ratio;