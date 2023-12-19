function [Chromosones,Chromosones_1]=max_ch(Chromosones,Chromosones_1,num_elem,max_elem,xhi,xlo)

%find which chromosones have more than the max # of elements 
max=[]; %matrix used to store the positions of chromosones with element count > max_elem
for i=1:8
    num_elem(end+1)=Chromosones_1(i,1)*Chromosones_1(i,2)*Chromosones_1(i,3)*Chromosones_1(i,4);
    if num_elem(i)>max_elem
        max(end+1)=i; %store the position of the chromosones that has element count > max_elem
    end
end

%Using the max matrix, re-calculate chromosones to ensure the element count < max_elem
for i=1:length(max)
    while num_elem(max(i))>max_elem %loop until element count < max_elem
        Chromosones(max(i),:)=rand(1,4);
        for m=1:4
            Chromosones_1(max(i),m)=round(Chromosones(max(i),m)*(xhi(m)-xlo(m))+xlo(m));
        end
        
        num_elem(max(i))=Chromosones_1(max(i),1)*Chromosones_1(max(i),2)*Chromosones_1(max(i),3)*Chromosones_1(max(i),4);
    end
end


