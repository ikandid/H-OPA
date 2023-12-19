function [d_0, SLL_real] = min_elem_spac()
    %Script for calculating SLL vs. min distances for each structure
    %Peak SLL vs. min element spacing

    structure = 1; %1-- Standard Circ array, 2-- Circ SA, 3-- Ryan's structure

    if structure == 1
        d_min = 14.48e-6;
        load('H:\Research\2023\Joint paper\Optimized GA structures\Optimized standard circ..mat'); %Standard circ.
    elseif structure == 2 
        d_min = 11.9e-6;
        load('H:\Research\2023\Joint paper\Optimized GA structures\Optimized Circ. SA.mat'); %Circ. SA
    elseif structure == 3
        d_min = 7.4096e-6;
        load('H:\Research\2023\Joint paper\Ryan''s structures\Ryan''s M=29,N=17 optimized structure.mat');
        M = 1;
        N = 1;
        M_SA_circle = 1;
        N_SA_circle = numel(pos_final(1,:));
    end

    %parameters
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    theta_0=0; %theta steering angle
    phi_0=0; %phi steering angle
    theta_90=1; %0 for 0:90/ 1 for -90:90
    ant = 0; %0 for isotropic antenna/ 1 for selected antenna
    


    SLL_real = [];
    scale = [];
    d_0 = [];
    %Calculate the peak SLL vs. min elem spacing where d_0 = 10um
    for i = 1:1:19
        d_0(end+1) = 10e-6+5e-6*(i-1);
        scale(end+1) = d_0(i)/d_min;
        pos_final_scaled = scale(i)*pos_final;

        %define the AF and intensity distributions [Intensity_norm,Intensity_dB,u,v,theta,phi]=AF_general(A,B,C,D,pos_final,lambda,figure_on_off,theta_0,phi_0,ant,theta_90)
        [Intensity_norm,Intensity_dB,u,v,theta,phi,SLL]=AF_general(M,N,M_SA_circle,N_SA_circle,pos_final_scaled,lambda,0,theta_0,phi_0,ant,1);

        %cuts
        res = 100;
        SLL_theta = [];
        phi_cut = [0 45 90 135];

        for i=1:length(phi_cut)
            %[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,w]=theta_cut(A,B,C,D,resolution,p,pos_final,figure_on_off,theta_0,ant,theta_90)
            [Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta(i)]=theta_cut(M,N,M_SA_circle,N_SA_circle,res,phi_cut(i),pos_final_scaled,0,theta_0,ant,theta_90);
        end

        SLL_real(end+1)=max([SLL_theta]);
    end

    figure
    plot(d_0/10e-6, SLL_real)
    xlabel('d_{min} / d_o')
    ylabel('Peak Sidelobe Level (dB)')
    %ylim([-17 -13])
    
    
%     figure 
%     hold on
%     load('H:\Research\2023\Joint paper\Optimized GA structures\Section 4 pics\Min_elem_spacing results\Steering angle (30, 45, 60)\Circ SA\d_0.mat');
%     load('H:\Research\2023\Joint paper\Optimized GA structures\Section 4 pics\Min_elem_spacing results\Steering angle (30, 45, 60)\Standard circular array\SLL_real (30 deg).mat');
%     for i = 1:2
%         plot(d_0/10e-6, SLL_real)
%          xlabel('d_{min} / d_o')
%          ylabel('Peak Sidelobe Level (dB)')
%          ylim([-20 -10])
%          box on
%          load('H:\Research\2023\Joint paper\Optimized GA structures\Section 4 pics\Min_elem_spacing results\Steering angle (30, 45, 60)\Standard circular array\SLL_real (60 deg).mat');
%     end
%     legend('\theta_0 (^o) = 30^o', '\theta_0 (^o) = 60^o')
    
    %legend('Standard circ.', 'Circ-SA')
    figure
    hold on
    load('H:\Research\2023\Joint paper\Joint paper pics\Section 4\Min_elem_spacing results\SLL_real (Standard circ).mat');
    for i=1:3
        if i == 3
            load('H:\Research\2023\Joint paper\Ryan''s structures\SLL_real.mat')
        end
        plot(d_0/10e-6, SLL_real)
        xlabel('d_{min} / d_o')
        ylabel('Peak Sidelobe Level (dB)')
        ylim([-19 -11])
        box on
        load('H:\Research\2023\Joint paper\Joint paper pics\Section 4\Min_elem_spacing results\SLL_real (Circ SA).mat');
    end
    legend('Standard circular array', 'Circular Subarray', 'Modified Circular array')