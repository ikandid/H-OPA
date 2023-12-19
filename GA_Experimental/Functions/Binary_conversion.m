function x = Binary_conversion(xhi,xlo,nbits, nvars, pop)
    
    %nbits: number of bits per chromosone
    %nvars: number of variables in a chromosone
 
    x=xlo+(xhi-xlo)*([2.^(-[1:nbits])]*reshape(pop,nbits,nvars));
   
end