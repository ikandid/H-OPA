%get the length of w
function[w,w_n]=weights_1_V2(A,B,C,D)
w=[];
%weights defintion
for n=1:A*B*C*D
    w(end+1)=abs((2*n-1)/(A*B*C*D)-1);
end
w_len=length(w);
w_n=zeros(1,w_len);

n=0; 
m=1;%indicies for new weight matrix

%reconstruct weight list from highest in the middle and smalles weights at
%the edges
for d=1:w_len
    [w_max,loc_max]=find_max(w); %get the max of w
    if mod(d,2)==1
        w_n(w_len/2-n)=w_max;
        n=n+1;
    else
        w_n(w_len/2+m)=w_max;
        m=m+1;
    end
    
    w(loc_max)=0;
end
