function i = RouletteWheelSelection(p)
    %Generate a random number 
    %Multiply by the sum(p) to ensure rand is within the range of our list
    r = rand*sum(p);
    c = cumsum(p);
    
    %find the first instance where rand is smaller than a point in c
    i = find(r <= c, 1, 'first');
    
end