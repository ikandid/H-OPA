%Minimal distance script 
function [distances,min_dist]=min_array_dist(M,pos_final)

for i = 1:3:length(pos_final)
    a = [pos_final(1,i),pos_final(2,i);pos_final(1,i+1),pos_final(2,i+1)];
    b = [pos_final(1,i),pos_final(2,i);pos_final(1,i+2),pos_final(2,i+2)];
    c = [pos_final(1,i+1),pos_final(2,+1);pos_final(1,i+2),pos_final(2,i+2)];
    
    d = [a,b,c];
    
    for j = 1:3
        d(end+1)=pdist()

label=cellstr(num2str([1:length(pos_final)]));
text(pos_final(1,:),pos_final(2,:),label,'VerticalAlignment','bottom','HorizontalAlignment','right');grid on;
X = [pos_final(1,1) pos_final(2,1)];
%Y = [pos_final(1,2:length(pos_final)) ;pos_final(2,2:length(pos_final))];
j=1;
for i = 1:length(pos_final)-1
    Y(i,1)=pos_final(1,i+1);
    Y(i,2)=pos_final(2,i+1);
end
[Idx,D] = knnsearch(X,Y,'K',3,'Distance','euclidean');
sqrt((165.75-140.25)^2+(0-14.7224)^2)*1e-6;