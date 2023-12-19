function [SLL_real, BW_3dB] = Rect_SA_results(N_r,N_c,N_SA_r,N_SA_c,dx)

    %Rect unit/Rect SA
    %parameters
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    theta_0=0; %theta steering angle
    phi_0=0; %phi steering angle
    theta_90=1; %0 for 0:90/ 1 for -90:90
    ant = 0; %0 for isotropic antenna/ 1 for selected antenna
    
    %define unit cell [y,z,dy,dz,N_r,N_c]=unit_cell_r_t(N_r,N_c,factor,r_t_c,figure_on_off)
    [y,z,dy,dz,N_r,N_c]=unit_cell_r_t(N_r,N_c,dx,0,0);
    %define SA [y,z,N_SA_r,N_SA_c]=SA_r_t(N_SA_r,N_SA_c,r_t,y,z,dy,dz)
    [y,z,N_SA_r,N_SA_c]=SA_r_t(N_SA_r,N_SA_c,0,y,z,dy,dz);
    %define rotation method [Yrot,Zrot,Dy,Dz,ang]=Rot_method_r_t(R_m,ang,y,z,N_SA_r,N_SA_c)
    [Yrot,Zrot,Dy,Dz,ang]=Rot_method_r_t(2,10,y,z,N_SA_r,N_SA_c);
    %define the final structure [pos_final]=pos_final_def(A,B,C,D,Yrot,Zrot,ang,figure_on_off)
    [pos_final]=pos_final_def(N_r,N_c,N_SA_r,N_SA_c,Yrot,Zrot,ang,0);
    
    
    %define the AF and intensity distributions [Intensity_norm,Intensity_dB,u,v,theta,phi]=AF_general(A,B,C,D,pos_final,lambda,figure_on_off,theta_0,phi_0,ant,theta_90)
    [Intensity_norm,Intensity_dB,u,v,theta,phi, SLL]=AF_general(N_r,N_c,N_SA_r,N_SA_c,pos_final,lambda,0,theta_0,phi_0,ant,theta_90);
    
    
    %cuts
    res = 100;
    SLL_theta = [];
    BW_3dB_theta=[];
    phi_cut = [0, 45, 90, 135];
    
    for i=1:1
        %[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,w]=theta_cut(A,B,C,D,resolution,p,pos_final,figure_on_off,theta_0,ant,theta_90)
        [Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta(i),SLL_theta(i)]=theta_cut(N_r,N_c,N_SA_r,N_SA_c,res,phi_cut(i),pos_final,0,theta_0,ant,theta_90);
    end
    
    SLL_real=max([SLL, SLL_theta]);

    %parameters
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    resolution = res;

    if theta_90 == 0
        theta=linspace(0,90,resolution*91);
    elseif theta_90 == 1
        theta=linspace(-7.5,7.5,resolution*181);
    end
    k=2*pi/lambda;%wavenumber

    %u&v coordinates
    u=sind(theta).*cosd(transpose(p));
    v=sind(theta).*sind(transpose(p));

    %Steering paramters
    u_0=sind(theta_0).*cosd(transpose(p));
    v_0=sind(theta_0).*sind(transpose(p));

    %AF definition
    AF_theta=0;
    w=[];
    phase_offset = [];
    for n=1:length(pos_final)
        w(end+1)=1;
        phase_offset(end+1) = k*(pos_final(1,n)*u_0+pos_final(2,n)*v_0);
        AF_theta=AF_theta+w(n)*exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v)-j*phase_offset(n));
        %AF_theta=AF_theta+w(n)*exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v)+j*k*(pos_final(1,n)*u_0+pos_final(2,n)*v_0));
    end
    phase_offset = mod(phase_offset,2*pi);
    AF_mag=abs(AF_theta);

    %Intensity & Normalized Intensity

    if ant == 0 %no antenna
        Intensity_theta=AF_mag.^2;
        Intensity_norm_theta=Intensity_theta/max(max(Intensity_theta));
        Intensity_dB_theta=10.*log10(Intensity_norm_theta);
    elseif ant == 1 %w/ antenna
        FF = SK_ant(1,:).*AF_mag; %Total far-field pattern with antenna
        Intensity_theta=FF.^2;
        Intensity_norm_theta=Intensity_theta/max(max(Intensity_theta));
        Intensity_dB_theta=10.*log10(Intensity_norm_theta);
    end


    %calculate the -approx -3dB BW
    ang_res=-3;
    [c index] = min(abs(Intensity_dB_theta-ang_res));
    BW_3dB=2*abs(theta(index)-theta_0);
end