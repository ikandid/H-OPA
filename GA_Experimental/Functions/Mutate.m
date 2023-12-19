function y = Mutate(x, mu)
    
    %Create an array that will raise a 1 wherever rand is smaller than mu
    flag = (rand(size(x)) < mu);
    
    y = x;
    y(flag) = 1-x(flag);
    
end