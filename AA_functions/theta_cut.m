%theta cut
function [Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,nulls]=theta_cut(A,B,C,D,resolution,p,pos_final,figure_on_off,theta_0,ant,theta_90,phase_off)

%parameters
c = 3e8;
fc = 193e12;
lambda = c/fc;

if theta_90 == 0
    theta=linspace(0,90,resolution*91);
elseif theta_90 == 1
    theta=linspace(-90,90,resolution*181);
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
%[w,w_n]=weights_1_V2(A,B,C,D);

phase_steer = [];
for n=1:A*B*C*D
    %w(end+1)=1;
    phase_steer(end+1) = k*(pos_final(1,n)*u_0+pos_final(2,n)*v_0);
    AF_theta=AF_theta+exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v)-j*phase_steer(n)-j*phase_off(n));
    %AF_theta=AF_theta+w(n)*exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v)+j*k*(pos_final(1,n)*u_0+pos_final(2,n)*v_0));
end
phase_steer = mod(phase_steer,2*pi);
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
BW_3dB_theta=2*abs(theta(index)-theta_0);

if figure_on_off == 1 
    figure
    plot(theta,Intensity_dB_theta);
    grid off
    ylabel('|AF(\theta,\phi)|^2 (dB)','FontSize',12)
    ylim([-50 0])
    xlabel('\theta (degrees)','FontSize',12);
end

if theta_90 == 0
    neg_Intensity_dB_theta=-1*Intensity_dB_theta;
    [pks,locs]=findpeaks(neg_Intensity_dB_theta);
    max_loc=find(Intensity_dB_theta==0);
    [val,idx]=min(abs(max_loc(1)-locs));  
    Intensity_norm_theta(1,max_loc(1)-val:max_loc(1)+val)=0;
    Intensity_dB_theta=10.*log10(Intensity_norm_theta);
    %figure
    %plot(neg_Intensity_dB_theta)
    SLL_theta=max(Intensity_dB_theta);    
elseif theta_90 == 1 
    neg_Intensity_dB_theta=-1*Intensity_dB_theta;
    [pks,locs]=findpeaks(neg_Intensity_dB_theta);
    max_loc=find(Intensity_dB_theta==0);
    [val,idx]=sort((abs(max_loc(1)-locs)),'ascend'); %find the nulls;
    nulls = val(1:2); %extract the nulls
    if (max_loc(1) - max(nulls)) <= 0 
        fprintf('Invalid array index');
        SLL_theta = 0;
    else   
        Intensity_norm_theta(1,max_loc(1)-max(nulls):max_loc(1)+max(nulls))=0;
        Intensity_dB_theta=10.*log10(Intensity_norm_theta);
        SLL_theta=max(Intensity_dB_theta);
        sort(Intensity_dB_theta,'ascend');
    end
end

%SLL_theta = 0;








