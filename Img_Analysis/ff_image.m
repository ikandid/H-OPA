close all;
clear all;

fig_off_on = 0;

%script to visualize the calibrated far field result
%load('H:\Research\2023\Honeywell - Ilyas\GA -Experimental\Testing\Temp_img\best_farfieldimg.mat');
%load('H:\Research\2023\Honeywell - Ilyas\Progress pics\December\12.11.23\GA runs\Run 2\best_farfieldimg.mat')

%%
[pix_loc,avg_pix] = background_image_save_func(fig_off_on);
ff = myimage;
ff = double(ff);

%Perform background subtraction
ff = ff - avg_pix;
ff_norm = ff/max(max(ff));

figure()
imshow(ff,[])

%extract the image size
pix_xlen = size(ff,2); %width
pix_ylen = size(ff,1); %height


figure()
img_x = linspace(1,pix_xlen,pix_xlen);
img_y = linspace(1,pix_ylen,pix_ylen);
surf(img_x,img_y,ff)
shading interp;
colormap('default');
xlabel('X')
ylabel('Y')

%find the aperture ring using findcircles()
%[x_center,y_center,X,Y,radius] = find_aperture_ring_v2(ff,0);

%Calculate the avg_pix of the total ff image and the max ff pix
%avg_ff_pix = sum(ff,'all')/numel(ff);
% sum_ff_pix=sum(sum(ff((x_center-radius):(x_center+radius),(y_center-radius):(y_center+radius)))); %get pixel value in the entire pattern;
% num_ff_pix = numel((ff((x_center-radius):(x_center+radius),(y_center-radius):(y_center+radius))));
% avg_ff_pix = sum_ff_pix/num_ff_pix;
% max_ff_pix = max(max((ff((x_center-radius):(x_center+radius),(y_center-radius):(y_center+radius)))));

%ML location
ML_loc_x = 127;
ML_loc_y = 135;
fig_off_on = 1;

[SLL_theta_x, SLL_theta_y, BW_3dB_theta_x, BW_3dB_theta_y] = measurements_cuts_OPA(ff, pix_xlen, pix_ylen, ML_loc_x, ML_loc_y,fig_off_on);



