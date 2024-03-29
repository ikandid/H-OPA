%%REV method for sparse array
close all;
clear all;

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

figure
hold on
for i=1:length(pos_final)
    scatter(pos_final(1,i)/1e-6,pos_final(2,i)/1e-6,'filled','k')
end
xlabel('x(um)','Fontsize',14)
xlim([-100 100])
ylabel('y(um)','Fontsize',14)
ylim([-100 100])

%labels each element with an index
label = cellstr(num2str([1:length(pos_final)]'));
text(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,label);

%% 3D Array factor calculation

%Phase Offset
phase_off = zeros(1,length(pos_final)); %no phase offset
for i = 1:3:length(phase_off)
    phase_off(i) = 2*pi*rand;
end

load('rand2_phase_off.mat')
%phase_off = phase_steer;

%define the AF and Intensity distributions
%[Intensity_norm,Intensity_dB,Intensity_max,u,v,theta,phi]=AF_general(A,B,C,D,pos_final,lambda,figure_on_off,theta_0,phi_0,ant,theta_90,phase_off)
[Intensity_norm,Intensity_dB,Intensity_max,Intensity_ratio,u,v,theta,phi,SLL]=AF_general(1,1,1,length(pos_final),pos_final,lambda,1,theta_0,phi_0,ant,1,phase_off);

%% 2D Array factor caclulation
%theta cut
%[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,w]=theta_cut(A,B,C,D,resolution,p,pos_final,figure_on_off,theta_0,ant,theta_90,phase_off)
res = 1;
[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,nulls]=theta_cut(1,1,1,length(pos_final),res,0,pos_final,1,theta_0,ant,theta_90,phase_off);

%phase offset figure
u_0=sind(theta_0).*cosd(transpose(phi_0)); 
v_0=sind(theta_0).*sind(transpose(phi_0));
phase_steer = mod(k*(pos_final(1,:)*u_0+pos_final(2,:)*v_0),2*pi);
%phase_steer = rescale(phase_steer,-1*pi,pi);

figure
scatter(1:15,phase_steer,'o','filled')
xlabel('Channel number')
ylabel('Phase (rad)')

%% Random phase implementation 
%x0 = 2*pi*rand(1,15); %random phase matrix between 0-2pi
x0 = -1*pi + 1*pi*(1--1)*rand(1,15); %random phase matrix between -pi-pi
Int_ratio_ideal = Intensity_ratio;

figure 
scatter(1:15,x0,'o','filled')
xlabel('Channel number')
ylabel('Phase (rad)')

%Calculate AF for random phase and plot intensity
[Intensity_norm,Intensity_dB,Intensity_max,Intensity_ratio,u,v,theta,phi,SLL]=AF_general(1,1,1,length(pos_final),pos_final,lambda,1,theta_0,phi_0,ant,1,x0);
[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta]=theta_cut(1,1,1,length(pos_final),res,0,pos_final,1,theta_0,ant,theta_90,x0);


%% Determine the optimization point
opt_x = find(theta == 0);
opt_y = find(phi == 0);

[minInt, minPhase] = REV_opt(Intensity_norm, Int_ratio_ideal, x0, opt_x, nulls);


%% Correst phases
phase_corr = minPhase;
Calibrated_Intensity_Ratio = min(minInt);
Ideal_vs_Calibrated = Int_ratio_ideal/Calibrated_Intensity_Ratio;

%Calculate AF for calibrated phase and plot intensity
theta_0 = 15;
[Intensity_norm,Intensity_dB,Intensity_max,Intensity_sum,u,v,theta,phi,SLL]=AF_general(1,1,1,length(pos_final),pos_final,lambda,1,theta_0,phi_0,ant,1,phase_corr);
[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta]=theta_cut(1,1,1,length(pos_final),res,0,pos_final,1,theta_0,ant,theta_90,phase_corr);

%plot phases
figure 
scatter(1:15,phase_corr,'o','filled')
xlabel('Channel number')
ylabel('Phase (rad)')
ylim([-1*pi, 1*pi])
