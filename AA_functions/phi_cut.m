%phi cut
function [Intensity_norm_phi,Intensity_dB_phi,t,phi]=phi_cut(A,B,C,D,resolution,t,pos_final)

%parameters
c = 3e8;
fc = 193e12;
lambda = c/fc;

AF_phi=0;

RES=resolution*361;
%theta=linspace(0,180,181);
phi=linspace(90,-90,RES);
k=2*pi/lambda;%wavenumber

%u&v coordinates 
u=sind(t).*cosd(transpose(phi));
v=sind(t).*sind(transpose(phi));

%AF definition
AF_phi=0;
for n=1:A*B*C*D
    AF_phi=AF_phi+exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v));
end

AF_mag=abs(AF_phi);
AF_norm=AF_mag/max(max(AF_mag));

%Intensity & Normalized Intensity
Intensity_phi=AF_mag.^2;
Intensity_norm_phi=Intensity_phi/max(max(Intensity_phi));
Intensity_dB_phi=10.*log10(Intensity_norm_phi);

figure
plot(phi,Intensity_dB_phi);
ylim([-50 0])
ylabel('Normalized intensity (dB)')
xlabel('\phi (deg)');
set(gca,'XTick',-180:30:180);
set(gca,'XTickLabel',{'-180','-150','-120','-90','-60','-30','0','30','60','90','120','150','180'},'Fontsize',10)  
title(['Phi cut @ theta = ',num2str(t) char(176), ''])
grid on

%Calculating SLL

