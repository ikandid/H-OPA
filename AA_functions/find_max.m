function [max_val,loc_max]=find_max(list_max)

%initiliaze max variable
max_val=0;

%iterate through the list, changing the max where appropriate
for i=1:length(list_max)
    if (list_max(i)>max_val)
        max_val=list_max(i);
        loc_max=i;
    end
end

end