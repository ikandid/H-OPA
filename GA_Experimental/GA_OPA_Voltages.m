clc;
clear;
close all;

%Problem definition
problem.CostFunction = @(x0) GA_FitFunc_OPA_Voltages(x0);
problem.nVar = 112;

%GA paramters 
params.nPop = 5;
params.nbits = 7;
params.MaxIt = 50;
params.beta = 1;
params.pC = 1; %percentage of crossover
params.mu = 0.05; %mutation percentage
%params.Nel = (problem.nVar-params.nbits*4)/params.nbits;


%Run GA 
Best_score = 300;
save('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\Temp_img\best_score.mat','Best_score')

tic
out = RunGA_OPA_Voltages(problem, params);
toc

%Results
figure;
plot(out.bestcost);
xlabel('Iterations')
ylabel('Best Cost')
grid on;