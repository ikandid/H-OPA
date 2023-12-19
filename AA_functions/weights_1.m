function [w_n]=weights_1(w)
n=0;
m=1;
%get the length of w
w_len=length(w);
w_n=zeros(1,w_len);

%this matrix has duplications of each element so only iterate half times
for d=1:w_len/2
    w_loc=[];
    w_max=max(w); %get the max of w
    for i=1:w_len
        w(i)
        if round(w(i),2)==round(w_max,2) % we round to 2 decimal places due to some inconsistency in the elements
            w_loc(end+1)=i;
        end
    end
    w_n(w_len/2-n)=w(w_loc(1)); %start at the middle indicies and continue outwards from both sides 
    w_n(w_len/2+m)=w(w_loc(2)); %this is why one indicie moves forward while the other moves backwards
    w(w_loc(1))=0;
    w(w_loc(2))=0;
    n=n+1;
    m=m+1;
end

end