%Script to calculate the SLL and BW of the measured OPA 
function [SLL_theta_x, SLL_theta_y, BW_3dB_theta_x, BW_3dB_theta_y] = measurements_cuts_OPA(ff, pix_xlen, pix_ylen, ML_loc_x, ML_loc_y,fig_off_on)
%measurements_cuts_OPA(ff, pix_xlen, pix_ylen, 1)

%Convert pixels to angles
theta_x = linspace(-1*pix_xlen*0.0549/2,1*pix_xlen*0.0549/2,pix_xlen);
theta_y = linspace(-1*pix_ylen*0.0549/2,1*pix_ylen*0.0549/2,pix_ylen);

%Normalize the intensity
Intensity_norm = ff/max(max(ff));
Intensity_dB = 10.*log10(Intensity_norm);

Intensity_norm_theta_x = Intensity_norm(ML_loc_x,:);
Intensity_norm_theta_y = Intensity_norm(:,ML_loc_y);

Intensity_dB_theta_x = Intensity_dB(ML_loc_x,:);
Intensity_dB_theta_y = Intensity_dB(:,ML_loc_y);

ff_x = ff(ML_loc_x,:);
ff_y = ff(:,ML_loc_y);
% figure()
% surf(theta_x,theta_y,Intensity_dB)
% shading interp;
% colormap('default');
% xlabel('X')
% ylabel('Y')

%ML plotted along theta_x
if fig_off_on == 1
    figure
    plot(theta_x,ff_x)
    xlabel('\theta_x')
    ylabel('Normalized Intensity (dB)')
    %ylim([-10 0])
    
    %ML plotted along theta_y
    figure
    plot(theta_y,ff_y)
    xlabel('\theta_y')
    ylabel('Normalized Intensity (dB)')
    %ylim([-10 0])
end

%calculate the -approx -3dB Beamwidth
ang_res=-3;
pix_theta = 18; %1 degree corresponds with 18 pixels

%Take the 2 degree region around the ML
%[ML_value ML_Index_x] = max(Intensity_dB_theta_x);
ML_Index_x = ML_loc_x;
[c index] = min(abs(Intensity_dB_theta_x(1,ML_Index_x-pix_theta:ML_Index_x+pix_theta)-ang_res)); %Find the closest 3dB point
if c <= 0 %translate to the corresponding theta index where the 3dB point was found
    theta_index_x = find(Intensity_dB_theta_x == ang_res-c);
elseif c >= 0
    theta_index_x = find(Intensity_dB_theta_x == ang_res+c);
end

%Find the offset of the ML in degrees from zero degrees
theta_ML_x = theta_x(ML_loc_y);

BW_3dB_theta_x=2*abs(theta_x(theta_index_x) - theta_ML_x); %calcuates the 3dB beamwidth

%[ML_value ML_Index_y] = max(Intensity_dB_theta_y);
ML_Index_y= ML_loc_y;
[c index] = min(abs(Intensity_dB_theta_y(ML_Index_y-pix_theta/2:ML_Index_y+pix_theta/2,1)-ang_res));
if c <= 0 %translate to the corresponding theta index where the 3dB point was found
    theta_index_y = find(Intensity_dB_theta_y == ang_res-c); %The closest 3dB point is below 3
elseif c >= 0
    theta_index_y = find(Intensity_dB_theta_y == ang_res+c); %The closest 3dB point is above 3
end

%Find the offset of the ML in degrees from zero degrees
theta_ML_y = theta_y(ML_loc_x);

BW_3dB_theta_y=2*abs(theta_y(theta_index_y) - theta_ML_y); %calcuates the 3dB beamwidth

%Extract the SLL along theta_x 
[~, closestIndex] = min(abs(Intensity_dB_theta_x));
closestValue = Intensity_dB_theta_x(closestIndex);
neg_Intensity_dB_theta_x=-1*Intensity_dB_theta_x;
[pks,locs]=findpeaks(neg_Intensity_dB_theta_x);
max_loc=find(Intensity_dB_theta_x==closestValue);
[val,idx]=min(abs(max_loc(1)-locs));
Intensity_norm_theta_x(1,max_loc(1)-val:max_loc(1)+val)=0;
Intensity_dB_theta_x=10.*log10(Intensity_norm_theta_x);
SLL_theta_x=max(Intensity_dB_theta_x);  

%Extract the SLL along theta_y
[minValue closestIndex] = min(abs(Intensity_dB_theta_y));
closestValue = Intensity_dB_theta_y(closestIndex);
neg_Intensity_dB_theta_y=-1*Intensity_dB_theta_y;
[pks,locs]=findpeaks(neg_Intensity_dB_theta_y);
max_loc=find(Intensity_dB_theta_y==closestValue);
[val,idx]=min(abs(max_loc(1)-locs));
Intensity_norm_theta_y(max_loc(1)-val:max_loc(1)+val,1)=0;
Intensity_dB_theta_y=10.*log10(Intensity_norm_theta_y);
SLL_theta_y=max(Intensity_dB_theta_y);  