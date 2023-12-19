function [Yrot,Zrot,Dy,Dz,ang]=Rot_method_r_t(R_m,ang,y,z,N_SA_r,N_SA_c)

%define the rotation matrices for each subarray
bot_rot=[0 ang]; %represents the lower rotation angle row
top_rot=[-ang 2*ang]; %represents the higher rotation angle row

%integer multiples for even/odd rows
m=0;%odd row
n=1;%even row

%reference centers
ref_center=zeros(3,N_SA_c*N_SA_r);

%define the position of the center of each SA
for i=1:N_SA_c*N_SA_r
    ref_center(2,i)=(min(y{1,i})+max(y{1,i}))/2;
    ref_center(3,i)=(min(z{1,i})+max(z{1,i}))/2;
end


%case for either no SA rows/cols
if N_SA_r == 1
    Dy=0;
else
   Dy=ref_center(2,2)-ref_center(2,1);
end

if N_SA_c == 1
    Dz = 0;
else
    Dz=ref_center(3,1+N_SA_c)-ref_center(3,1); 
end

%Dy=ref_center(2,2)-ref_center(2,1);
%Dz=ref_center(3,1+N_SA_c)-ref_center(3,1);

%Dy=75;
%Dz=75;
%Rot#1
Rot=[];
if R_m ==1
    for i=1:N_SA_r
        if mod(i,2) == 0
            for p=1+N_SA_c*m:2:N_SA_c+N_SA_c*m
                Rot(p)=bot_rot(1);
                Rot(p+1)=bot_rot(2);
            end
            m=m+2;
        else
            for p=1+N_SA_c*n:2:N_SA_c+N_SA_c*n;
                Rot(p)=top_rot(1);
                Rot(p+1)=top_rot(2);
            end
            n=n+2;
        end
    end
elseif R_m==2 %Rot#2
    for i=1:N_SA_c*N_SA_r
        if i==1
            Rot(i)=0;
        else
            Rot(length(Rot)+1)=i-1;
            Rot(i);
            
            %exit theloop once the length of Rot is equal to the number of unit %cells
            if length(Rot)==N_SA_c*N_SA_r;
                break
            end
            Rot(length(Rot)+1)=-(i-1);
            Rot(i+1);
        end
    end
end
Rot=ang*Rot;

%rotation matrices for the element positions
Yrot={};
Zrot={};

for i=1:N_SA_c*N_SA_r
    % Shift Y/Z to the rotation center
    Yshift = y{1,i} - ref_center(2,i);
    Zshift = z{1,i} - ref_center(3,i);
    
    % Rotate the coordinates
    Ysrot =  Yshift*cosd(Rot(i)) - Zshift*sind(Rot(i));
    Zsrot = Yshift*sind(Rot(i)) + Zshift*cosd(Rot(i));
    
    % Shift the rotated coordinates back to the original reference center
    Yrot{end+1} = Ysrot + ref_center(2,i); %Xc=ref_center(2,2)
    Zrot{end+1} = Zsrot + ref_center(3,i);
end


end