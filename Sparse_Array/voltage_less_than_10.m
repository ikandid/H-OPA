function tilt_ang = voltage_less_than_10()
    
    %parameters
    lambda = 1.55e-6;
    %Sparse array_def is a function that simulates the sparse array on the chip
    pos_final = sparse_array_def2();
    pos_final = pos_final(:,1:15);
    
    %labels each element with an index
    label = cellstr(num2str([length(pos_final):1]'));
    text(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,label);
    
    %mesh grid defintion
    tilt_ang = [];
    tilt = -5:0.05:5; %tilt angle
    for t = 1:length(tilt)
        x = -100:0.1:100;
        y = -100:0.1:100;
        [X,Y] = meshgrid(-100:0.1:100);
        Z = meshgrid(-100:0.1:100)*sind(tilt(t));
        
        %labels each element with an index
        label = cellstr(num2str([1:length(pos_final)]'));
        text(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,(label));
        
        %Determine the z height corresponds with emitter location
        z_loc = [];
        z_dist = [];
        for i = 1:length(pos_final)
            [z_val z_loc] = min(abs(x-pos_final(1,i)/1e-6)); %sind
            %[z_val z_loc] = min(abs(y-pos_final(2,i)/1e-6));  %cosd
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
        % for i = 1:length(z_phase2)
        %     if CurrentPower(i) > P_pi*2
        %         CurrentPower(i) = CurrentPower(i) - 2*P_pi; %Remap heater power w/ phases higher than 2pi back to 0-2pi
        %     end
        % end
        
        %Convert Current Power to Voltage
        load('f_vp.mat');
        Power2Voltage = [];
        desired_y = [];
        x = V_I(:,3);
        %x = linspace(0,300,100); %Voltage values
        %Pw = 1.69*x.^2 + 4.742.*x - 2.319; %Power function
        
        for i = 1:length(z_phase2)
            fun = @(x) CurrentPower(i) - f_vp(x);
            Power2Voltage(end+1) = fzero(fun,[0 13]);
            %Power2Voltage(end+1) = fzero(fun,0);
            desired_y(end+1) = f_vp(Power2Voltage(i));
        end
        
     lessthan = Power2Voltage < 11;
     if lessthan == 1
         tilt_ang = tilt(t);
     end
        
end