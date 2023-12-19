function [y,z,R_unit,dr,M,N]=unit_cell_c(M,N,R_unit,dr,figure_on_off)

%circular unit cell defintion
%-------------------------Unit cell defintions----------------------------%
%circular lattice paramters
%M=41;                    % Number of elements on each ring
%N=20;                       % Number of circles
%R=[60e-6];                      %Radii matrix with the first ring at 20um
R_unit=R_unit*1e-6;

%dr=2*lambda;
dr=dr*1e-6;

for i=1:N-1
    R_unit(end+1)=dr*i+R_unit(1);
    %R(end+1)=9e-6*i+R(1);
end
    
azang = (0:M-1)*360/M;
pos = [zeros(1,M);cosd(azang);sind(azang)];

elem_pos=zeros(3,M*N);
n=0;
for i=1:N
    elem_pos(1:3,1+M*n:M+M*n)=R_unit(i)*pos;
    n=n+1;
end

y={};
z={};

y{end+1}=elem_pos(2,:)/1e-6;
z{end+1}=elem_pos(3,:)/1e-6;

if figure_on_off==1
    figure
    scatter(y{1,1},z{1,1},'filled')
    xlabel('x(um)','FontSize',12)
    ylabel('y(um)','FontSize',12)
    %axis off
    %title(['Circular unit cell ',num2str(M),' elements in ',num2str(N),' circles'])
    %grid minor
end
end