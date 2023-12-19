function [max_loc_v,null_v] = null_location_v(A,B,C,D,resolution,v_cut,pos_final,theta_0,phi_0,ant,theta_90)

%parameters
c = 3e8;
fc = 193e12;
lambda = c/fc;


load('antenna_data(SK).mat') %load the antenna
SK_ant = imresize(pat_azel(:,181,20).',resolution); %increase the resolution

if theta_90 == 0
    theta=linspace(0,90,resolution*91);
elseif theta_90 == 1
    theta=linspace(-90,90,resolution*181);
end

k=2*pi/lambda;%wavenumber

%u&v coordinates 
u=sind(theta).*cosd(transpose(v_cut));
v=sind(theta).*sind(transpose(v_cut));

%Steering paramters
u_0=sind(-theta_0).*cosd(transpose(-phi_0));
v_0=sind(-theta_0).*sind(transpose(-phi_0));

%AF definition
AF_theta=0;
w=[];
for n=1:A*B*C*D
    %w(end+1)=abs((2*n-1)/(A*B*C*D)-1);
    w(end+1)=1;
    AF_theta=AF_theta+w(n)*exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v)+j*k*(pos_final(1,n)*u_0+pos_final(2,n)*v_0));
end

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

%Find the nulls along u
if theta_90 == 0
    neg_Intensity_dB_theta=-1*Intensity_dB_theta;
    [pks,locs]=findpeaks(neg_Intensity_dB_theta);
    max_loc=find(Intensity_dB_theta==0);
    [val_v,idx]=min(abs(max_loc(1)-locs));    
elseif theta_90 == 1 
    neg_Intensity_dB_theta=-1*Intensity_dB_theta;
    [pks,locs]=findpeaks(neg_Intensity_dB_theta);
    max_loc=find(Intensity_dB_theta==0);
    [val_v,idx]=min(abs(max_loc(1)-locs));
end

max_loc_v = max_loc;
null_v = val_v;