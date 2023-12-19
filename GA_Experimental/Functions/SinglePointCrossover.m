function [y1, y2,j] = SinglePointCrossover(x1,x2)
    
    %Variable with length of parent 1
    nVar = numel(x1);
    
    %Pick a rand interger in the range from 1 to nVar-1
    %This will be the cutoff point for crossover
    j = randi([1, nVar-1]);
    
    %create the offsprings
    y1 = [x1(1:j) x2(j+1:end)];
    y2 = [x2(1:j) x1(j+1:end)];

end