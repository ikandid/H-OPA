function [Yrot,Zrot,ang,Rot]=Rot_method_c(R_m,ang,y,z,M_SA_circle,N_SA_circle)

%reference centers
ref_center=zeros(3,M_SA_circle*N_SA_circle);

%define the position of the center of each SA
for i=1:M_SA_circle*N_SA_circle
    ref_center(2,i)=(min(y{1,i})+max(y{1,i}))/2;
    ref_center(3,i)=(min(z{1,i})+max(z{1,i}))/2;
end
Rot=[];
if R_m==2 %Rot#2
    for i=1:N_SA_circle*M_SA_circle  
    if i==1
        Rot(i)=0;
    else
    	Rot(length(Rot)+1)=i-1;
        Rot(i);
        
        %exit theloop once the length of Rot is equal to the number of unit %cells
        if length(Rot)==N_SA_circle*M_SA_circle;  
            break
        end
        Rot(length(Rot)+1)=-(i-1);
        Rot(i+1);
    end
end    
elseif R_m==3 %Rot#3
    for i=1:M_SA_circle
        if i==1
            Rot(i)=0;
        else
            %exit the loop once the length of Rot is equal to the number of unit cells
            if length(Rot)==M_SA_circle;
                break
            end
            
            Rot(length(Rot)+1)=i-1;
            
            
            Rot(length(Rot)+1)=-(i-1);
        end
    end
    
    n=1;
    for i=M_SA_circle+1:M_SA_circle*N_SA_circle
        Rot(i)=Rot(n);
        n=n+1;
        
        if n==M_SA_circle+1
            n=1;
        end      
    end
end
Rot=ang*Rot;

%rotation matrices for the element positions
Yrot={};
Zrot={};

for i=1:M_SA_circle*N_SA_circle
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