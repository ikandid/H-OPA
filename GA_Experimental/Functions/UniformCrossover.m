function [y1, y2] = UniformCrossover(x1, x2)

    alpha = randi([0, 1], size(x1));
    
    
    %if alpha=1, then y1=x1 and likewise, if alpha=0, y1=x2
    y1 = alpha.*x1 + (1-alpha).*x2;
    y2 = alpha.*x2 + (1-alpha).*x1;

end