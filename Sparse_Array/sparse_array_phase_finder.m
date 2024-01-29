%Sparse array phase extracter
%close all;
clear all;

%parameters
c = 3e8;
fc = 193e12;
%lambda = c/fc;
lambda = 1.55e-6;
k=2*pi/lambda;%wavenumber
theta_0=0; %theta steering angle
phi_0=0; %phi steering angle
theta_90=1; %0 for 0:90/ 1 for -90:90
ant = 0; %0 for isotropic antenna/ 1 for selected antenna
res=1; %resolution

%Sparse array_def is a function that simulates the sparse array on the chip
pos_final = sparse_array_def();
pos_final = pos_final(:,1:15);
figure
hold on
for i=1:length(pos_final)
    scatter(pos_final(1,i)/1e-6,pos_final(2,i)/1e-6,'filled','k')
end
xlabel('x(um)','Fontsize',14)
xlim([-100 100])
ylabel('y(um)','Fontsize',14)
ylim([-100 100])
grid minor

%labels each element with an index
label = cellstr(num2str([length(pos_final):1]'));
text(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,label);

%mesh grid defintion
tilt = -1.5; %tilt angle
x = -100:0.1:100;
y = -100:0.1:100;
[X,Y] = meshgrid(-100:0.1:100);
Z = meshgrid(-100:0.1:100)*cosd(tilt);
figure
surf(X,Y,Z)
hold on
for i=1:length(pos_final)
    scatter(pos_final(1,i)/1e-6,pos_final(2,i)/1e-6,'filled','k')
end
shading interp;
colormap('default');
xlabel('x(um)')
ylabel('y(um)')
zlabel('z(um)')

%labels each element with an index
label = cellstr(num2str([1:length(pos_final)]'));
text(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,(label));

%Determine the z height corresponds with emitter location
z_loc = [];
z_dist = [];
for i = 1:length(pos_final)
    %[z_val z_loc] = min(abs(x-pos_final(1,i)/1e-6)); %sind
    [z_val z_loc] = min(abs(y-pos_final(2,i)/1e-6));  %cosd
    %z_loc(end+1) = find(round(x,3,'significant')==round(pos_final(1,i)/1e-6,2,'significant'));
    %z_dist(end+1) = abs((Z(1,z_loc)));
    z_dist(end+1) = Z(1,z_loc);
end

z_phase = z_dist*1e-6/lambda*2*pi;
z_phase2 = mod(z_phase,2*pi);
%z_phase2 = flip(z_phase2);

%% Phase2Power2Voltage
%Phase to Power
load("Currentdata.mat")
c_v = 1;
c_i = 3;

T = table2array(Currentdata);

V_I = [];
V_I(:,1) = double(T(:,c_v)); %Voltage
V_I(:,2) = double(T(:,c_i)); %Current
V_I(:,3) = V_I(:,1).*V_I(:,2); %Heater Power

P_pi = 67.9310; %Measured power for pi phase shift
Ph = pi/P_pi*V_I(:,3);

load('f_p.mat');
f_pp = f_p;
Phase2Power = [];
desired_y = [];
for i = 1:length(z_phase2)
    fun = @(Ph) z_phase2(i) - f_pp(Ph);
    Phase2Power(end+1) = fzero(fun,0);
    desired_y(end+1) = f_pp(Phase2Power(i));
end

%Calibrated Voltage2Power
load('f_vp.mat');
load('PT_settings.mat');
Voltage2Power = [];
for i = 1:length(z_phase2)
    Voltage2Power(end+1) = f_vp(PT_settings(i,1));
    if Voltage2Power(i) < 0
        Voltage2Power(i) = 0;
    end
end

%Calculate the Current Power
CurrentPower = Phase2Power + Voltage2Power;
for i = 1:length(z_phase2)
    if CurrentPower(i) > P_pi*2
        CurrentPower(i) = CurrentPower(i) - 2*P_pi; %Remap heater power w/ phases higher than 2pi back to 0-2pi
    end
end

%Convert Current Power to Voltage
load('f_vp.mat');
Power2Voltage = [];
desired_y = [];
x = V_I(:,3);
%x = linspace(0,300,100); %Voltage values
%Pw = 1.69*x.^2 + 4.742.*x - 2.319; %Power function

for i = 1:length(z_phase2)
    fun = @(x) CurrentPower(i) - f_vp(x);
    Power2Voltage(end+1) = fzero(fun,[0 10]);
    desired_y(end+1) = f_vp(Power2Voltage(i));
end

PT_settings = zeros(16,4000);
for i = 1:4000
    PT_settings(1:15,i) = transpose(Power2Voltage);
end

%%
% = [-.09578 3.077 -0.1692];
%phase = linspace(0,2*pi,10000);

%function for phase to voltage
f = p(1)*phase.^4 + p(2)*phase.^3 + p(3)*phase.^2 + p(4)*phase + p(5);

%fucntion for voltage to phase
g = 1./f;

figure
plot(phase,f)
xlabel('Phase(rad)')
ylabel('Voltage (V)')

%convert voltages to phase
calibrated_phase = [];
%PT_settings = load('H:\Research\2023\Honeywell - Ilyas\Applied voltages settings\0 degrees results (X,Y)\Run 1 (07.11.23)\PT_settings.mat');
PT_settings = load('H:\Research\2023\Honeywell - Ilyas\Progress pics\November\11.03.23\GA runs\Run 1\PT_settings_scaled.mat');
Calibrated_voltages = PT_settings.PT_settings(:,1);

%Phase to voltage
volt_Sm = load('H:\Research\2023\Honeywell - Ilyas\Mackenzie phase stuff\volt_Sm');
phase = linspace(0,2*pi,length(volt_Sm.volt_Sm(1:523)));
% 
% %Convert phase to voltage
% voltage_tilt= [];
% for i = 1:length(z_phase2)
%     [ph_val ph_loc] = min(abs(phase - z_phase2(i)));
%     voltage_tilt(end+1) = volt_Sm.volt_Sm(ph_loc);
% end
% 
% voltage_steered = Calibrated_voltages + transpose(voltage_tilt); 
% 
% %Convert to PT_settings for labview
% PT_settings = zeros(16,4000);
% for i = 1:4000
%     PT_settings(1:16,i) = transpose(voltage_steered);
% end



%Find the corresponding voltage to phase point
for i = 1:length(Calibrated_voltages)
    [vt_val vt_loc] = min(abs(Calibrated_voltages(i) - volt_Sm.volt_Sm(1:523)));
    calibrated_phase(end+1) = phase(vt_loc);
end

%Convert phase to voltage
phase_steered = calibrated_phase(2:16) + z_phase2;
phase_steered = mod(phase_steered,2*pi);

voltage_steered= [];
for i = 1:length(phase_steered)
    [ph_val ph_loc] = min(abs(phase - phase_steered(i)));
    voltage_steered(end+1) = volt_Sm.volt_Sm(ph_loc);
end

%If certain voltages are
for i = 1:length(voltage_steered)
    if voltage_steered(i) > 10
        %vt_overshoot = voltage_steered(i) - 10.371839925183663;
        %voltage_steered(i) = f(1) + vt_overshoot;
        voltage_steered(i) = 10;
    end
end
%Convert to PT_settings for labview
PT_settings = zeros(16,4000);
for i = 1:4000
    PT_settings(1:15,i) = transpose(voltage_steered);
end
%}


%x = linspace(0,15,100);
x = linspace(-25,25,100);
%x = V_I(:,3);
%y = 1.69*x.^2 + 4.7
%42.*x - 2.319;
figure
plot(x,f_vp(x))