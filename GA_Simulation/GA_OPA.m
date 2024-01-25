clc;
clear;
close all;

%Problem definition
problem.CostFunction = @(x0) GA_FitFunc_OPA_Phases(x0);
problem.nVar = 105;

%GA paramters 
params.nPop = 10;
params.nbits = 7;
params.MaxIt = 25;
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

%plot phases
% figure 
% scatter(1:15,phase_corr,'o','filled')
% xlabel('Channel number')
% ylabel('Phase (rad)')
% ylim([-1*pi, 1*pi])