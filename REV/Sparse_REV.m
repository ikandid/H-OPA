%%REV method for sparse array

%% Parameters
c = 3e8;
fc = 193e12;
lambda = c/fc;
k=2*pi/lambda;%wavenumber
theta_0=2.5; %theta steering angle
phi_0=0; %phi steering angle
theta_90=1; %0 for 0:90/ 1 for -90:90
ant = 0; %0 for isotropic antenna/ 1 for selected antenna
res=1; %resolution

%% Sparse array definition
pos_final = sparse_array_def();

figure
hold on
for i=1:length(pos_final)
    scatter(pos_final(1,i)/1e-6,pos_final(2,i)/1e-6,'filled','k')
end
xlabel('x(um)','Fontsize',14)
xlim([-100 100])
ylabel('y(um)','Fontsize',14)
ylim([-100 100])

%labels each element with an index
label = cellstr(num2str([1:length(pos_final)]'));
text(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,label);
