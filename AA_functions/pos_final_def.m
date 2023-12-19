%pos_final
function [pos_final]=pos_final_def(A,B,C,D,Yrot,Zrot,ang,figure_on_off)

%define the final structure
pos_final=zeros(3,A*B*C*D);
%create the final structure
m=0;
elem=A*B;
for i=1:length(Yrot)
    pos_final(1,1+m*elem:A*B+m*elem)=Yrot{1,i}*1e-6;
    pos_final(2,1+m*elem:A*B+m*elem)=Zrot{1,i}*1e-6; 
    m=m+1;
end

%pos_final(:,end+1) = [0; 0; 0];

if figure_on_off==1
    figure
    hold on
    for i=1:C*D
        scatter(Yrot{1,i},Zrot{1,i},'filled')
        %plot(Yrot{1,i},Zrot{1,i})
        %scatter(pos_final(1,i)/1e-6,pos_final(2,i)/1e-6,'filled');
    end
    %title(['Sequential rotated subarray lattice by ',num2str(ang) char(176),''])
    %title(['Rectangular lattice rotated by ',num2str(ang) char(176),''],'Fontsize',14)
    xlabel('x(um)','Fontsize',14)
    ylabel('y(um)','Fontsize',14)
    %axis off
%     pos_finalt = transpose(pos_final);
%     str=string(1:length(pos_finalt));
%     label=cellstr(num2str([1:length(pos_finalt)]));
%     %text(pos_finalt(1,:),pos_finalt(2,:),label,'VerticalAlignment','bottom','HorizontalAlignment','right');grid on;
%     figure
%     textscatter(pos_finalt(:,1),pos_finalt(:,2),str)
    %grid minor
end