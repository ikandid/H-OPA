%REV optimization
function REV_opt(Intensity_norm,Int_sum, x0, opt, nulls)  
    %% Parameters
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    k=2*pi/lambda;%wavenumber
    theta_0=0; %theta steering angle
    phi_0=0; %phi steering angle
    theta_90=1; %0 for 0:90/ 1 for -90:90
    ant = 0; %0 for isotropic antenna/ 1 for selected antenna
    res=1; %resolution
    pos_final = sparse_array_def();

    %% REV optimization
    phases = [-2, -1, 0, 1, 2];
    Intensity_ratio = [];
    x1 = x0;

    for i = 1:length(phases)
        x1(1) = x0(1);
        x1(1) = x1(1)+phases(i);
        %[Intensity_norm,Intensity_dB,Intensity_max,u,v,theta,phi]=AF_general(A,B,C,D,pos_final,lambda,figure_on_off,theta_0,phi_0,ant,theta_90,phase_off)
        [Intensity_norm,Intensity_dB,Intensity_max,Intensity_sum,u,v,theta,phi,SLL]=AF_general(1,1,1,length(pos_final),pos_final,lambda,0,theta_0,phi_0,ant,1,x1);
        Int_sum_REV = sum(sum(Intensity_norm(:,opt-nulls:opt+nulls)));
        Intensity_ratio(end+1) = Int_sum_REV/Int_sum;
    end
    
    
    f_v = fit(phases',Intensity_ratio','poly4'); %polynomial fit
    c = coeffvalues(f_v);
    
    %determine the maximum intensity point and corresponding phase
    numSamplePoints = 2000; % However many you need to get the resolution you want.
    %xFit = linspace(min(-1*pi), max(1*pi), numSamplePoints);
    xFit = linspace(min(phases), max(phases), numSamplePoints);
    yFit = polyval(c, xFit); % Evaluate the fit at the same x values.
    minFit = min(yFit); % Find min of fitted curve in the range we have fit it over.
    maxFit = max(yFit); % Find max of fitted curve in the range we have fit it over.
    minIndex=find(yFit==minFit);
    maxIndex=find(yFit==maxFit);
    maxPoint=xFit(maxIndex);
    minPoint=xFit(minIndex);
    

    figure
    plot(f_v,phases',Intensity_ratio')
    xlim([-1*pi, 1*pi]);
    hold on
    plot(f_v)
    plot(maxPoint,maxFit,'b*')
    xlabel('Phase shift (rad)')
    ylabel('Intensity(a.u.)')
end