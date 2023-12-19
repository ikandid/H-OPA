function [y,z,dy,dz,N_r,N_c]=unit_cell_r_t(N_r,N_c,factor,r_t_c,figure_on_off)
%parameters
c = 3e8;
fc = 193e12;
lambda = c/fc;

if r_t_c==0 || r_t_c==1 %rect or triang unit cell defintion
    %Unit cell definition
    %dy = factor*2/sqrt(3)*lambda;           % Row spacing
    %dz = sqrt(3)*dy/2; % Column spacing
   
    dy =factor*lambda;
    dz =factor*lambda;
    
    %dy =factor*1e-6;
    %dz =factor*1e-6;
    %N_r; %Number of rows
    %N_c; %Number of columns
    rows = N_c*ones(N_r,1);
    stop = cumsum(rows);
    start = stop-rows+1;
    count = 0;
    p = 0;
    
    %create the rectangular/triangular lattice unit cell
    pos=zeros(3,N_r*N_c);
    for m = -N_r/2+1:N_r/2
        count = count+1;
        idx = start(count):stop(count);
        %disp(idx);
        if mod(p,2) ==0
            pos(2,idx) = (-(rows(count)-1)/2:(rows(count)-1)/2)*dy;
        else
            %if r_t=0,create a rect unit cell
            %if r_t=1,create a triang unit cell
            pos(2,idx) = (-(rows(count)-1)/2:(rows(count)-1)/2)*dy-dy/2*r_t_c;
        end
        pos(3,idx) = m*dz-dz/2;
        p = p+1;
    end
    
    %create the position matrix
    %global y z
    y={};
    z={};
    y{end+1}=pos(2,:)/1e-6;
    z{end+1}=pos(3,:)/1e-6;
    
    if figure_on_off==1
        figure
        scatter(y{1,1},z{1,1},'filled')
        xlabel('x(um)','FontSize',13)
        ylabel('y(um)','FontSize',13)
        xlim([-20 20])
        ylim([-20 20])
        %title([['Unit cell rectangular lattice ',num2str(N_r),'x',num2str(N_c),'']])
        %grid minor
    end
    
end