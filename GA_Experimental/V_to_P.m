%%Voltage-Phase Script
clear all;
close all;
%Initialization for Voltage/Current Matrix 
%Column for voltage and current
load("Currentdata.mat")
c_v = 1;
c_i = 3;

T = table2array(Currentdata);

V_I = [];
V_I(:,1) = double(T(:,c_v)); %Voltage
V_I(:,2) = double(T(:,c_i)); %Current
V_I(:,3) = V_I(:,1).*V_I(:,2); %Heater Power

%% Calculate Phase
P_pi = 67.9310; %Measured power for pi phase shift
Ph = pi/P_pi*V_I(:,3);


f_vi = fit(V_I(:,1),V_I(:,2),'poly2');
figure
%scatter(V_I(:,2),V_I(:,1),'o')
plot(f_vi,V_I(:,1),V_I(:,2))
ylabel('Current (mA)')
xlabel('Voltage (V)')

%f_vi(PT_settings(1,1))
figure 
scatter(V_I(:,3), Ph, 'o')
xlabel('Heater Power (mW)')
ylabel('Phase (rad)')

figure 
scatter(V_I(:,1), Ph, 'o')
xlabel('Voltage (V)')
ylabel('Phase (rad)')

%Polynomial fit for heater power
f_p = fit(V_I(:,3),Ph,'poly1');
figure
plot(f_p,V_I(:,3), Ph)
xlabel('Heater Power (mW)')
ylabel('Phase (rad)')

%Polynomial fit for voltage
f_v = fit(V_I(:,1),Ph,'poly3');
figure
plot(f_v,V_I(:,1), Ph)
xlabel('Voltage (V)')
ylabel('Phase (rad)')
