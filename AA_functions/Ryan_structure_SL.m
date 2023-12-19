%Ryans structure
%position variables: x and y
%load the x and y position matrices into the function and calculates the
%SLL

function [SLL_real, BW_3dB_theta] = Ryan_structure_SL(x,y)
    
    %parameters
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    theta_0=0; %theta steering angle
    phi_0=0; %phi steering angle
    theta_90=1; %0 for 0:90/ 1 for -90:90
    ant = 0; %0 for isotropic antenna/ 1 for selected antenna
    figure_on_off = 1;
    ant1 = phased.IsotropicAntennaElement( ...
        'FrequencyRange',[183e12 203e12],'BackBaffled',true);
    
    %figure_on_off = 0 for off, 1 for on
    
   
    figure
    scatter(x/1e-6,y/1e-6,[],[0 0.4470 0.7410],'filled')
    xlabel('x(um)','Fontsize',14)
    ylabel('y(um)','Fontsize',14)

    
    %pos_final matrix
    pos_final=zeros(3,numel(x));

    for i=1:numel(x)
        pos_final(1,i) = x(i);
        pos_final(2,i) = y(i);
    end

    %AF_3D
    %define the AF and intensity distributions [Intensity_norm,Intensity_dB,u,v,theta,phi]=AF_general(A,B,C,D,pos_final,lambda,figure_on_off,theta_0,phi_0,ant,theta_90)
    [Intensity_norm,Intensity_dB,u,v,theta,phi,SLL]=AF_general(1,1,1,length(pos_final(1,:)),pos_final,lambda,1,theta_0,phi_0,ant,theta_90);


    %theta cut
    %cuts
    %resolution used for the theta cut. Keep at 100
 
    res = 100;
    SLL_theta = [];
    phi_cut = [0, 45, 90, 135];
    
    for i = 1:length(phi_cut)
        %[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,w]=theta_cut(A,B,C,D,resolution,p,pos_final,figure_on_off,theta_0,ant,theta_90)
        [Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta(i),SLL_theta(i)]=theta_cut(1,1,1,length(pos_final(1,:)),res,phi_cut(i),pos_final,1,theta_0,ant,theta_90);  
    end
    SLL_real=max([SLL,SLL_theta]);

end