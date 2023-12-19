function [y,z,M_SA_circle,N_SA_circle,R_SA,dr_SA]=SA_c(M_SA_circle,N_SA_circle,N_r,N_c,dy,dz,y,z,increment,r_t_c,dr,N,R_unit)

if r_t_c==1
    %define the cell SA lattice
    %M_SA_circle =9; %Number of SAs elements
    %N_SA_circle=2; %Number of SA rings
    min_length_y=(max(y{1,1})-min(y{1,1}));
    min_length_z=(max(z{1,1})-min(z{1,1}));
    
    if min_length_y > min_length_z
        min_length=min_length_y;
    else
        min_length=min_length_z;
    end
    
    if min_length == 0
        min_length = dy/1e-6;
    end
    
    dr_SA=2*min_length*1e-6+increment*1e-6;%used as the incremental radius for each SA ring
    %dr_SA=6.0e-5;
    R_SA=[]; %rotation matrix
    %ang=0;%define the rotation angle
    %-------------------------------------------------------------------------%
    
    %scale factors for the radius depending on the unit cell size
    size_dz=0;
    size_dy=0;
    size_SA=0;
    
    if N_r>4
        size_dz=N_r-4;
    end
    
    if N_c>4
        size_dy=N_c-4;
    end
   
    %-------------------------define the radius-------------------------------%
    %define the angular positions for each SA
    %unit_cell_length=(max(y{1,1})-min(y{1,1}));
    I=(max(y{1,1})-min(y{1,1}))^2+(max(z{1,1})-min(z{1,1}))^2;
    I=sqrt(I);
    
    %shift_y(end+1)=I+dy/1e-6;
    %shift_z(end+1)=I+dz/1e-6;
    
    Min_dist=M_SA_circle*I;
    
    R_SA=1*(Min_dist/(2*pi)+dy/1e-6+dz/1e-6)*1e-6+size_dz*dz+size_dy*dy;
   
    %R_SA=7.5*1e-5;
    %R_SA=1.1*1e-4;
    
    %radius for each ring
    for i=1:N_SA_circle-1
        R_SA(end+1)=dr_SA*i+R_SA(1);
    end
    
elseif r_t_c==2
    %----------------------------SA defintions--------------------------------%
    %define the cell SA lattice
    %M_SA_circle =1; %Number of SAs elements
    %N_SA_circle=1; %Number of SA rings
    
    %increment*1e-6
    dr_SA=2*R_unit(N)+dr+increment*1e-6;%used as the incremental radius for each SA ring
    %dr_SA=9.0e-5;
    R_SA=[]; %radius matrix
    
    
    R_SA=M_SA_circle*R_unit(N)/2; %radius of the SA rings
    %R_SA=6.5e-5;
    %R_SA=1.0e-3;
    
    %radius for each ring
    for i=1:N_SA_circle-1
        R_SA(end+1)=dr_SA*i+R_SA(1);
        %R_SA(end+1)=R_SA(1);
    end
end
%-------------------------------------------------------------------------%
%define the angular positions for each SA
azang_SA = (0:M_SA_circle-1)*360/M_SA_circle;
pos_SA = [zeros(1,M_SA_circle);cosd(azang_SA);sind(azang_SA)];

%define the position matrix for the circular SA latticce 
elem_pos_SA=zeros(3,M_SA_circle*N_SA_circle);

n=0;
for i=1:N_SA_circle
    elem_pos_SA(1:3,1+M_SA_circle*n:M_SA_circle+M_SA_circle*n)=R_SA(i)*pos_SA;
    n=n+1;
end

%define the reference centers of each SA so it will be aligned with the
%position matrix of the SA circle lattice
ref_center=zeros(3,M_SA_circle*N_SA_circle);
ref_center(2,1)=(min(y{1,1})+max(y{1,1}))/2;
ref_center(3,1)=(min(z{1,1})+max(z{1,1}))/2;

%used to move the unit cell to each SA element position
shift_y=[];
shift_z=[];

%calculate the difference between ref. center and SA position matrix
shift_y(end+1)=elem_pos_SA(2,1)/1e-6-ref_center(2,1);
shift_z(end+1)=elem_pos_SA(3,1)/1e-6-ref_center(3,1);

%shift the unit cell to the 1st respective SA position
y{1,1}=y{1,1}+shift_y(1);
z{1,1}=z{1,1}+shift_z(1);

%define the unit cell positions along the SA lattice for remaining SAs
for i=1:M_SA_circle*N_SA_circle-1 %end at N_SA_circle-1 since the first SA is defined 
    shift_y(end+1)=elem_pos_SA(2,i+1)/1e-6-elem_pos_SA(2,i)/1e-6;
    shift_z(end+1)=elem_pos_SA(3,i+1)/1e-6-elem_pos_SA(3,i)/1e-6;
    
    %shift the unit cell to the respective SA position
    y{1,i+1}=y{1,i}+shift_y(i+1);
    z{1,i+1}=z{1,i}+shift_z(i+1);
end

end