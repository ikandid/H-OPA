clc;
clear;
close all;

%Problem definition
problem.CostFunction = @(x0) GA_FitFunc_OPA(x0);
problem.nVar = 112;

%GA paramters 
params.nPop = 10;
params.nbits = 7;
params.MaxIt = 50;
params.beta = 1;
params.pC = 1; %percentage of crossover
params.mu = 0.05; %mutation percentage
%params.Nel = (problem.nVar-params.nbits*4)/params.nbits;


%Run GA 

tic
out = RunGA_OPA(problem, params);
toc
%Results

figure;
plot(out.bestcost);
xlabel('Iterations')
ylabel('Best Cost')
grid on;