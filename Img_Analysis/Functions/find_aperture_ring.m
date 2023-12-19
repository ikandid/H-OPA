function [x_center,y_center,X,Y,radius] = find_aperture_ring(ff,fig_off_on)
    %ff image pre-phase shift
    %determine the aperture diameter and detect the aperture ring
    
%     %Call the background_image save function 
%     [pix_loc,avg_pix] = background_image_save_func(fig_off_on);
%     
%     ff = imread('H:\Research\2023\Honeywell - Ilyas\GA - Simulation\Background_img_save\background_ff.png');
%     ff = double(ff);

    if fig_off_on == 1
        figure()
        imshow(ff,[])
    end

    se = strel('disk',2);
    
    C = imdilate(ff,se);
    
    
    %// Here imfill is not necessary but you might find it useful in other situations.
    E = imfill(C,'holes');
    
    %// Detect edges
    F = edge(E);
    figure()
    imshow(F,[])
    
    %// Generate range of radii.
    radii = 100:1:150;
    
    h = circle_hough(F, radii,'same');
    [~,maxIndex] = max(h(:));
    [i,j,k] = ind2sub(size(h), maxIndex);
    radius = radii(k);
    center.x = j;
    center.y = i;
    
    %// Generate circle to overlay
    N = 200;
    
    theta=linspace(0,2*pi,N);
    rho=ones(1,N)*radius;
    
    %Cartesian coordinates
    [X,Y] = pol2cart(theta,rho); 
    
    if fig_off_on == 1
        figure()
        imshow(F,[]);hold on
        plot(center.x-X,center.y-Y,'r-','linewidth',2);
        title('Edge image + circle (F)','FontSize',16)
    end
    
    x_center = center.x;
    y_center = center.y;
end