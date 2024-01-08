%AF_general
%function that calculates the Array Factor
function [Intensity_norm,Intensity_dB,Intensity_max,Intensity_sum,u,v,theta,phi,SLL]=AF_general(A,B,C,D,pos_final,lambda,figure_on_off,theta_0,phi_0,ant,theta_90,phase_off)

%paramaters
res=1; %resolution
k=2*pi/lambda;%wavenumber

if theta_90 == 0
    theta=linspace(0,90,res*91);
elseif theta_90 == 1
    theta=linspace(-90,90,res*181);
end

phi=linspace(-180,180,res*361);

%u&v coordinates 
u=sind(theta).*cosd(transpose(phi));
v=sind(theta).*sind(transpose(phi));

%Steering paramters
u_0=sind(theta_0).*cosd(transpose(phi_0)); 
v_0=sind(theta_0).*sind(transpose(phi_0));

%AF definition
AF=0;
%[w,w_n]=weights_1_V2(A,B,C,D);

phase_steer = [];
for n=1:A*B*C*D
    phase_steer(end+1) = k*(pos_final(1,n)*u_0+pos_final(2,n)*v_0);
    AF=AF+exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v)-j*phase_steer(n)-j*phase_off(n));
end

%Intensity & Normalized Intensity

if ant == 0 %no antenna
    AF_mag=abs(AF);
    Intensity=AF_mag.^2;
    Intensity_max = max(max(Intensity));
    Intensity_norm=Intensity/max(max(Intensity));
    Intensity_dB=10.*log10(Intensity_norm);
elseif ant == 1 %w/ antenna
    AF_mag=abs(AF);
    FF = SK_ant.*AF_mag;
    Intensity=FF.^2;
    Intensity_norm=Intensity/max(max(Intensity));
    Intensity_dB=10.*log10(Intensity_norm);
end

%figures
if figure_on_off == 1
    figure
    surf(u,v,Intensity_norm)
    shading interp;
    colormap('default');
    xlabel('U')
    ylabel('V')
    %zlim([0 1])
    title('3D Response Pattern in u-v space','Fontsize',12)

    figure()
    surf(theta,phi,Intensity_norm)
    shading interp;
    colormap('default');
    xlabel('\theta')
    ylabel('\phi')
end



%Mainlobe removal
%u&v coordinates 
u_cut = 0;
v_cut = 90;
[max_loc_u,null_u] = null_location_u(A,B,C,D,res,u_cut,pos_final,theta_0,phi_0,ant,theta_90);
[max_loc_v,null_v] = null_location_v(A,B,C,D,res,v_cut,pos_final,theta_0,phi_0,ant,theta_90);

%filter out the mainlobe & calculate the SLL
if null_u >= null_v
    null = null_u;
else
    null = null_v;
end

Intensity_sum = sum(sum(Intensity_norm(:,max_loc_u(1)-null_u:max_loc_u(1)+null_u))); %Sum of the intensity points in the ML
Intensity_norm_SLL = Intensity_norm; %Dummy variable for calculating the SLL

if (max_loc_u(1) - null_u) <= 0 
    fprintf('Invalid array index')
    SLL = 0;
else
    Intensity_norm_SLL(:,max_loc_u(1)-null_u:max_loc_u(1)+null_u)=0;
    Intensity_dB=10.*log10(Intensity_norm_SLL);
    %Convert to dB
    pat_uv_dB = 10.*log10(Intensity_norm_SLL);
    SLL=max(max(pat_uv_dB));
end

% if figure_on_off == 1
%     figure
%     surf(u,v,Intensity_norm)
%     shading interp;
%     colormap('default');
%     xlabel('U')
%     ylabel('V')
%     zlim([0 1])
%     %title('3D Response Pattern in u-v space','Fontsize',12)
% end

% figure()
% surf(theta,phi,Intensity_norm)
% shading interp;
% colormap('default');
% xlabel('\theta')
% ylabel('\phi')

