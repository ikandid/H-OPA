%U cut
function [SLL_U,BW_3dB_U]=U_cut(A,B,C,D,resolution,u_cut,pos_final,figure_on_off,theta_0,phi_0,ant,theta_90)

%parameters
c = 3e8;
fc = 193e12;
lambda = c/fc;

load('antenna_data(SK).mat') %load the antenna
SK_ant = imresize(pat_azel(:,181,20).',10); %increase the resolution

if theta_90 == 0
    theta=linspace(0,90,resolution*91);
elseif theta_90 == 1
    theta=linspace(-90,90,resolution*181);
end
k=2*pi/lambda;%wavenumber

%u&v coordinates 
u=sind(theta).*cosd(transpose(u_cut));
v=sind(theta).*sind(transpose(u_cut));

%Steering paramters
u_0=sind(-theta_0).*cosd(transpose(u_cut));
v_0=sind(-theta_0).*sind(transpose(u_cut));

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


%calculate the -approx -3dB BW
ang_res=-3;
[c index] = min(abs(Intensity_dB_theta-ang_res));
BW_3dB_U=abs(2*theta(index));

if figure_on_off == 1 
    figure
    plot(u,Intensity_dB_theta);
    ylabel('Normalized intensity (dB)','FontSize',14)
    ylim([-50 0])
    xlabel('U','FontSize',14);
%     if theta_90 == 0
%         set(gca,'XTick',0:15:90);
%         set(gca,'XTickLabel',{'0','15','30','45','60','75','90'},'Fontsize',10)
%     elseif theta_90 == 1
%        set(gca,'XTick',-90:30:90);
%        set(gca,'XTickLabel',{'-90','-60','-30','0','30','60','90'},'Fontsize',10)
%     end
    %title(['Steering to \theta = ',num2str(theta_0) char(176), ''])
    grid on
end


%Calculating SLL

if theta_90 == 0
    neg_Intensity_dB_theta=-1*Intensity_dB_theta;
    [pks,locs]=findpeaks(neg_Intensity_dB_theta);
    max_loc=find(Intensity_dB_theta==0);
    [val,idx]=min(abs(max_loc(1)-locs));  
    Intensity_norm_theta(1,max_loc(1)-val:max_loc(1)+val)=0;
    Intensity_dB_theta=10.*log10(Intensity_norm_theta);
    %figure
    %plot(neg_Intensity_dB_theta)
    SLL_U=max(Intensity_dB_theta);    
elseif theta_90 == 1 
    neg_Intensity_dB_theta=-1*Intensity_dB_theta;
    [pks,locs]=findpeaks(neg_Intensity_dB_theta);
    max_loc=find(Intensity_dB_theta==0);
    [val,idx]=min(abs(max_loc(1)-locs));

    if (max_loc(1) - val) <= 0
        fprintf('Invalid array index \n')
        SLL_U = 0;
    else
        Intensity_norm_theta(1,max_loc(1)-val:max_loc(1)+val)=0;
        Intensity_dB_theta=10.*log10(Intensity_norm_theta);
        SLL_U=max(Intensity_dB_theta);
    end

%     Intensity_norm_theta(1,max_loc(1)-val:max_loc(1)+val)=0;
%     Intensity_dB_theta=10.*log10(Intensity_norm_theta);
%     SLL_U=max(Intensity_dB_theta);
end











