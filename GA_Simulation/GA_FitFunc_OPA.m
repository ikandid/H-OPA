
function fitness_function_pixel = GA_FitFunc_OPA(x0)

    load('OPA_1ST_GEN_MEASURED_NOM_1550NM.mat')
    
    %parameters
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    theta_0=0; %theta steering angle
    phi_0=0; %phi steering angle
    k=2*pi/lambda;%wavenumber

    %Antenna defintion
    %Finding the index positions for a narrower theta
    index_1 = find(theta_x<=20&theta_x>=-20);
    index_2 = find(theta_y<=20&theta_y>=-20);
    narrow_theta_x = theta_x(index_1);
    narrow_theta_y = theta_y(index_2);
    narrow_farfield = farfield(index_2, index_1);

    %Antenna definition
    scaled_ant = imresize(narrow_farfield,[1024 1024]); %interpolating the data points of the antenna

    %U&V coordinates 
    len_narrow_theta_x = length(narrow_theta_x);
    narrow_theta_x = linspace(narrow_theta_x(1),narrow_theta_x(len_narrow_theta_x),1024);
    phi = linspace(-180,180,1024);
    u=sind(narrow_theta_x).*cosd(transpose(phi));
    v=sind(narrow_theta_x).*sind(transpose(phi));

    u_0=sind(-theta_0).*cosd(transpose(-phi_0)); %scanning variables
    v_0=sind(-theta_0).*sind(transpose(-phi_0));

    %Emitter position definition
    pos_final = sparse_array_def();
    
    
%     N1 = 69;%in outer ring 
%     R1 = 400e-6;
%     R2 = 115e-6;
%     
%     input = [N1 R1 R2];
%     lam = linspace(1545e-9,1555e-9,3); %can pick whch one we want after
%     c = physconst('lightspeed');%3e8;
%     freqVector = c./lam;
%     freqVector = flip(freqVector);
%     lam = flip(lam);
%     
%     
%     %2 ring structure far field 
%     shift = 0; %relative angular displacement b/w rings 
%     radius = [input(2) input(3)];
%     n1 = round(input(1));
%     n2 = 100 - n1;
%     n = [n1 n2];
%     Nelements = sum(n);
%     stop = cumsum(n);
%     start = stop - n + 1;
%     actual_pos = zeros(3, Nelements);
%     
%     %finds actual pos of dual ring in xy 
%     for idx = 1:length(n)
%         angles = (0:n(idx)-1)*360/n(idx);
%         angles = angles + shift;
%         %shift = sum(angles(1:2))/2;
%         pos = [zeros(1, length(angles));cosd(angles);sind(angles)];
%         actual_pos(:, start(idx):stop(idx)) = pos*radius(idx);
%     end
% 
%     %Manually input non-emitting emitter index
%     working_emitter_index = [];
%     defective_emitter_index = [6,8,11,19,31,33,38,40,41,43,53,61,69,73,85,87,90];
%     defective_phaseshifter_index = [46,63,64,65];%these ps needs assigning random phase values
%     defective_phaseshifter_count = length(defective_phaseshifter_index);
% 
%     defective_actual_pos = actual_pos;
%     defective_actual_pos(:,defective_emitter_index) = [];
%     defective_array_size = size(defective_actual_pos);
%     working_emitter_count = defective_array_size(2);
   
%     pos_final(1,:) = defective_actual_pos(2,:);
%     pos_final(2,:) = defective_actual_pos(3,:);
%     
%     figure
%     hold on
%     for i=1:length(defective_actual_pos)
%         scatter(pos_final(1,i)/1e-6,pos_final(2,i)/1e-6,'filled','k')
%     end
%     xlabel('x(um)','Fontsize',14)
%     %xlim([-100 100])
%     ylabel('y(um)','Fontsize',14)
%     %ylim([-100 100])
%     
    %define the AF and intensity distributions'
    
    %AF definition
    %x0 = [3.23976742401447,3.43611696486384,3.48520435007618,3.04341788316511,4.27060251347363,3.63246650571320,3.43611696486384,3.33794219443916,4.17242774304894,3.14159265358979,3.97607820219958,2.50345664582937,4.31968989868597,3.09250526837745,3.82881604656256,3.19068003880213];
    %x0 = zeros(1,16); %random phase matrix

    AF=0;
    for n=1:16 %16 emitters
        AF=AF+exp(j*k*(pos_final(1,n)*u+pos_final(2,n)*v)+j*k*(pos_final(1,n)*u_0+pos_final(2,n)*v_0))*exp(j*x0(n));
    end
    
    %Intensity distribution
    
    AF_mag=abs(AF);
    Intensity = scaled_ant.*AF_mag.^2;
    Intensity_norm=Intensity/max(max(Intensity));
    Intensity_dB=10.*log10(Intensity_norm);
   
     
    % figure
    % surf(u,v,Intensity)
    % shading interp;
    % colormap('default');
    % xlabel('U')
    % ylabel('V')
    
    
    %Camera/Image Defs **put more comments
    imageSizeX = 640;
    imageSizeY = 512;
    [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    % Next create the crop circle in the image.
    centerX = 320;
    centerY = 256;
    radius = 250;
    circlePixels = (rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 <= radius.^2;
    circlePixels = cast(circlePixels,"uint16");
    
    FAF_camera_size = zeros(1024, 1280);
    FAF_camera_size(:,129:1152) = Intensity_norm;
    [Y,E] = discretize(FAF_camera_size,2^14);
    Y = cast(Y,"uint16");
    Y = Y-1;
    Y_shrink = imresize(Y,0.5,"bilinear");
    
    %adding the round artifact
    farfield_with_round_artifact = Y_shrink.*circlePixels;
    
    %this function would take in all phase shifter settings, apply them to OPA, and take a picture of resulting output
    %then get the pixel location at the location I want (xloc,yloc)
    range=4; %half the size of aperture
    xloc = 256;
    yloc = 320;
    
    pival=sum(sum(farfield_with_round_artifact((xloc-range):(xloc+range),(yloc-range):(yloc+range)))); %get pixel value in aperture;
    piall=sum(sum(farfield_with_round_artifact))-pival;
    
    %val=65535-pival; %look at how far from maximum you are   > 0
    val=piall./pival;
    fitness_function_pixel = val;

end
