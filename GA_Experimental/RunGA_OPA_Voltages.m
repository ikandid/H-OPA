
function out = RunGA_OPA(problem, params)

    %Problem
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    
    %Params
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    nbits = params.nbits;
    beta = params.beta;
    pC = params.pC;  %offsprings
    nC = round(pC*nPop/2)*2; %# of crossovers (must be even)
    mu = params.mu;
    
    %Template for Empty Individuals
    empty_individual.Position = []; %Equivalent to a chromosone
    empty_individual.var = [];
    empty_individual.Cost = [];
    
    %Best Soln ever found
    bestsol.Cost = inf;
    
    %Initialization 
    pop = repmat(empty_individual, nPop, 1);

    %Voltages (0-10V) 
    xhi = 10;
    xlo = 0;
        
    for i = 1:nPop
        
        %Generate Random Solution
        pop(i).Position=randi([0, 1], 1, nVar);
        
        %Generate binary variables
        for m = 1:nVar/nbits
            pop(i).var(m,1:nbits) = pop(i).Position(1+nbits*(m-1):nbits+nbits*(m-1));
        end

        
        %Convert the binary variables to real numbers
        pop(i).var=nan;
        pop(i).var=repmat(pop(1).var, 1, nVar/nbits);
        pop(i).var = Binary_conversion(xhi,xlo,nbits, nVar/nbits, pop(i).Position);
        
        %Evaluate Solution
        pop(i).Cost = CostFunction(pop(i).var);
        
        %Check if a new best solution is found
        if pop(i).Cost < bestsol.Cost
            bestsol = pop(i);
        end
    end
    
    %Best cost of iterations
    bestcost = nan(MaxIt, 1);
   
    %Now the initial population is generated
    %Continue onwards to parent selection & crossover
    
    %Main Loop
    for it = 1:MaxIt
        
        %Selection Probabilities
        c = [pop.Cost];
        avgc = mean(c);
        if avgc ~= 0
            c = c/avgc;
        end
        probs = exp(-beta*c);
      
        %create an intial pop matrix for offsprings
        %We have two columns where each offspring is designated 1 col
        %This is why we divide nC/2
        popc = repmat(empty_individual, nC/2, 2);
        
        %Crossover
        for k = 1:nC/2
            
            %Select parents
            %q = randperm(nPop); %Random permutation list
            p1 = pop(RouletteWheelSelection(probs));
            p2 = pop(RouletteWheelSelection(probs));
            
            %Do crossover with parent 1 and 2
            [popc(k,1).Position, popc(k,2).Position] = ...
                SinglePointCrossover(p1.Position, p2.Position);
            
        end
        
        %Convert popc to single-column atrix
        popc = popc(:);
        
          
        %Mutation
        for l = 1:nC
            popc(l).Position = Mutate(popc(l).Position, mu);
            
            %Convert from binary to continous
            popc(l).var=nan;
            popc(l).var=repmat(popc(1).var, 1, nVar/nbits);
            popc(l).var = Binary_conversion(xhi,xlo,nbits, nVar/nbits, popc(l).Position);
            
            %Evaluate 
            popc(l).Cost = CostFunction(popc(l).var);
            
            %Check if a new best solution is found
            if popc(l).Cost < bestsol.Cost
                bestsol = popc(l);
            end
        end
        

        %Merge and sort the population
        pop = SortPopulation([pop; popc]);
        
        %Remove extra individuals from the pop
        %Only want to keep up to npop so any members that are unfit are
        %discarded
        pop = pop(1:nPop);

        %Update Best Cost of Iteration
        bestcost(it) = bestsol.Cost;
       
        %Display iteration information
        disp(['Iteration ' num2str(it) ':Best Cost = '  num2str(bestcost(it))]);
        
    end
        
    
    %Results
    out.pop = pop;
    out.bestsol = bestsol;
    out.bestcost = bestcost;
end