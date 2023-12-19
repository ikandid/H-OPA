function [theta_0, SLL_real, BW_real] = steering_range()
    %[theta_0, SLL_real] = steering_range()
    %Script for calculating SLL vs. steering for each structure
    %Peak SLL vs. min element spacing


    %load('H:\Research\2023\Joint paper\Optimized GA structures\Optimized standard circ..mat'); %Standard circ.

    load('H:\Research\2023\Joint paper\Optimized GA structures\Optimized Circ. SA.mat'); %Circ. SA
    
    theta_0 = [];
    SLL_real = [];
    BW_real = [];
    phi_cut = [0, 45, 90, 135];

    for i = 1:1:90
        %cuts
        res = 100;
        SLL_theta = [];
        theta_0(end+1) = i-1;
        
        for j=1:4
            %[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,w]=theta_cut(A,B,C,D,resolution,p,pos_final,figure_on_off,theta_0,ant,theta_90)
            [Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta(j),SLL_theta(j)]=theta_cut(M,N,M_SA_circle,N_SA_circle,res,phi_cut(j),pos_final,0,theta_0(i),ant,theta_90);
        end
        SLL_real(end+1) = max(SLL_theta);
        BW_real(end+1) = max(BW_3dB_theta);
    end

    %two y-axis plot
%     figure
%     hold on
% 
%     yyaxis left
%     x = theta_0;
%     y = SLL_real;
%     xlabel('\theta_0 (^o)')
%     ylabel('Peak Sidelobe Level (dB)')
%     ylim([-17 -10])
%     plot(x,y);
% 
% 
%     yyaxis right
%     r = BW_real;
%     ylabel('\theta_{FWHM}(^o)')
%     plot(x,r);
    
    figure
    plot(theta_0, SLL_real)
    xlabel('\theta_0 (^o)')
    ylabel('Peak Sidelobe Level (dB)')
    ylim([-20 -10])
