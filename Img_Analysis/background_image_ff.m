%ff image pre-phase shift
close all;
clear all;

fig_off_on = 0;

%Call the background_image save function 
[pix_loc,avg_pix] = background_image_save_func(fig_off_on);
transpose_pix_loc = transpose(pix_loc);

%ff = imread('H:\Research\2023\Honeywell - Ilyas\GA - Simulation\Background_img_save\background_ff.png');
ff = imread('H:\Research\2023\Honeywell - Ilyas\GA - Simulation\Background_img_save\Initial OPA image (greyscale).png');
%ff = imread('H:\Research\2023\Honeywell - Ilyas\GA - Simulation\Background_img_save\Final OPA image (greyscale).png');
ff = double(ff);
figure()
imshow(ff,[])

%extract the image size
%% 
pix_xlen = size(ff,1);
pix_ylen = size(ff,2);

%normalize the background image
ff_norm = ff/max(max(ff));

%FF with bad/dead pixels
figure()
img_x = linspace(1,pix_xlen,pix_xlen);
img_y = linspace(1,pix_ylen,pix_ylen);
surf(img_y,img_x,ff)
shading interp;
colormap('default');
xlabel('X')
ylabel('Y')

%Set the bad/dead pixels to the average pixel value
for i=1:length(pix_loc)
   ff(pix_loc(i)) = avg_pix;
end

%Perform background subtraction
ff = ff - avg_pix;
ff_norm = ff/max(max(ff));

%FF w/o bad/dead pixels
figure()
surf(img_y,img_x,ff_norm)
shading interp;
colormap('default');
xlabel('X')
ylabel('Y')

%find the aperture ring using findcircles()
[x_center,y_center,X,Y,radius] = find_aperture_ring(ff,fig_off_on);
%radius = 116;
%x_center = 122;
%y_center = 122
%Calculate the avg_pix of the total ff image and the max ff pix
%avg_ff_pix = sum(ff,'all')/numel(ff);
% sum_ff_pix=sum(sum(ff((x_center-radius):(x_center+radius),(y_center-radius):(y_center+radius)))); %get pixel value in the entire pattern;
% num_ff_pix = numel((ff((x_center-radius):(x_center+radius),(y_center-radius):(y_center+radius))));
% avg_ff_pix = sum_ff_pix/num_ff_pix;
% max_ff_pix = max(max((ff((x_center-radius):(x_center+radius),(y_center-radius):(y_center+radius)))));

sum_ff_pix=sum(sum(ff((y_center-radius):(y_center+radius),(x_center-radius):(x_center+radius)))); %get pixel value in the entire pattern;
num_ff_pix = numel((ff((y_center-radius):(y_center+radius),(x_center-radius):(x_center+radius))));
avg_ff_pix = sum_ff_pix/num_ff_pix;
max_ff_pix = max(max((ff((y_center-radius):(y_center+radius),(x_center-radius):(x_center+radius)))));

%Set the aperture ring to the avg value
%ff(round(x_center-X),round(y_center-Y)) = avg_pix;

%FF w/o bad/dead pixels
figure()
surf(img_y,img_x,ff); hold on
plot(x_center-X,y_center-Y,'r-','linewidth',2);
shading interp;
colormap('default');
xlabel('X')
ylabel('Y')

%{
%ff-aperture ring finder
ring_xloc = round(x_center-X);
ring_yloc = round(y_center-Y);
ff(ring_xloc,ring_yloc) = avg_pix;

figure()
surf(img_y,img_x,ff)
shading interp;
colormap('default');
xlabel('X')
ylabel('Y')
%}
