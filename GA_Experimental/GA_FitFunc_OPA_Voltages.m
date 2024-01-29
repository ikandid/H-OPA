
%define a fitness function that dtermines a set of voltages to improve
%the pixel ratio between the total pattern and aperture

function fitness_function_voltage = GA_FitFunc_OPA_Voltages(x0)
    DACRate=2000;
    timeon=2; %time DAC is kept on [sec]
    NptsDAC=DACRate*timeon; %keep on for x seconds 
    t=(0:1:(NptsDAC-1)).*(1/DACRate); %MAKE IT A BIT LONGER TO ACCOUNT FOR DELA B/W STARTING PT AND IMAGE  ACQUITION
    
    PT_settings = zeros(length(x0),NptsDAC);

    %PT settings does a N x M matrix, where each PT setting is a row mat 
    for ii=1:length(x0) 
        PT_settings(ii,:)=x0(ii)*ones(1,NptsDAC);
    end 
    %PT_settings(:,end+1)=0; %turn them off

    %-------save so that labview can have input------------
    save('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\PT_settings.mat','PT_settings');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

   Vmax=10; %max voltage each PT can be 
   Vmin=0;    %smallest voltage each PT can be 
   if (any(PT_settings>Vmax) | any(PT_settings<Vmin))
        error('DAC settings not in correct range') 
   end 

    %run capture image vi and get image into workspace 
    e=actxserver('LabVIEW.Application');
    vipath='H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\freqmod_DAC_and_CAM.vi';
    vi=invoke(e,'GetVIReference',vipath);
    vi.Run;
    
    %visualize real-time farfield image
    load('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\Temp_img\farfieldimg.mat')

    %this function would take in all phase shifter settings, apply them to OPA, and take a picture of resulting output
    %then get the pixel location at the location I want (xloc,yloc)
    range_X = 5; %half the size of aperture
    range_Y = 5;
    %range = 10;
    pattern_radius = 115;
    xloc = 134;
    yloc = 129;

    xloc_steering = 126;
    yloc_steering = 171;
    
    
    %pival=sum(sum(myimage((xloc-range_X):(xloc+range_X),(yloc-range_Y):(yloc+range_Y)))); %get pixel value in aperture;
    %piall=sum(sum(myimage((xloc-pattern_radius):(xloc+pattern_radius),(yloc-pattern_radius):(yloc+pattern_radius)))); %get pixel value in the entire pattern;

    pival=sum(sum(myimage((yloc_steering-range_Y):(yloc_steering+range_Y),(xloc_steering-range_X):(xloc_steering+range_X)))); %get pixel value in aperture;
    piall=sum(sum(myimage((yloc-pattern_radius):(yloc+pattern_radius),(xloc-pattern_radius):(xloc+pattern_radius)))); %get pixel value in the entire pattern;
    val=piall./pival;

    %disp(val)
    fitness_function_voltage = val;
    
    %Best score
    load('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\Temp_img\best_score.mat')

    %store the best performing 
    if val < Best_score
        Best_score = val;
        save('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\Temp_img\PT_settings.mat','PT_settings');
        save('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\Temp_img\best_score.mat','Best_score')
        save('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\Temp_img\best_farfieldimg.mat','myimage')
    end
        
   
   

end

