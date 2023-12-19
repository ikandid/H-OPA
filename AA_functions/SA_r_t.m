function [y,z,N_SA_r,N_SA_c]=SA_r_t(N_SA_r,N_SA_c,r_t,y,z,dy,dz)

%[y,z,dy,dz]=unit_cell_r_t(4,4,1,1)
%define the cell SA lattice
%N_SA_r; %Number of rows
%N_SA_c;%Number of columns

%define the shift needed to duplicate a SA along the y axis & z axis with a
%spacing of dy and dz
shift_y=[];
shift_z=[];
shift_y(end+1)=max(y{1,1})-min(y{1,1})+dy/1e-6;
shift_z(end+1)=max(z{1,1})-min(z{1,1})+dz/1e-6;

%define the shift needed to duplicate a SA along the y axis & z axis with a
%spacing of dy and dz to ensure no overlap
I=(max(y{1,1})-min(y{1,1}))^2+(max(z{1,1})-min(z{1,1}))^2;
I=sqrt(I);

shift_y(end+1)=I+dy/1e-6;
shift_z(end+1)=I+dz/1e-6;

%shift_y(end+1)=60;
%shift_z(end+1)=60;

%define the SAs along y
for i=1:N_SA_c-1 
    y{end+1}=y{1,i}+shift_y(2);
    z{end+1}=z{1,i};
end

%define the SAs along z
for i=1:N_SA_c*N_SA_r-max(size(y))
    y{end+1}=y{1,i};
    z{end+1}=z{1,i}+shift_z(2);
end

%if r_t=1,create the triang. SA lattice
if r_t==1
    %integer multiples for even/odd rows
    m=0;
    n=1;
    for i=1:N_SA_r
        if mod(i,2) == 1
            for p=1+N_SA_c*m:N_SA_c+N_SA_c*m
                y{1,p}=y{1,p};
            end
            m=m+2;
        else
            for p=1+N_SA_c*n:N_SA_c+N_SA_c*n;
                y{1,p}=y{1,p}-shift_y(2)/2;
            end
            n=n+2;
        end
    end
end

end