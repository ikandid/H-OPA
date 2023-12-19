function [pix_loc,avg_pix] = background_image_save_func(fig_off_on)
    background = imread('H:\Research\2023\Honeywell - Ilyas\GA - Simulation\Background_img_save\background_1.png');
    background = double(background);
    if fig_off_on == 1
        figure()
        imshow(background,[])
    end
    
    %extract the image size
    pix_xlen = size(background,1);
    pix_ylen = size(background,2);
    
    %normalize the background image
    bg_norm = background/max(max(background));
    
    if fig_off_on == 1
        figure()
        img_x = linspace(1,pix_xlen,pix_xlen);
        img_y = linspace(1,pix_ylen,pix_ylen);
        surf(img_y,img_x,background)
        shading interp;
        colormap('default');
        xlabel('X')
        ylabel('Y')
    end
    
    %Find the average value of the pixels
    avg_pix = sum(background,'all')/numel(background);
    avg_pix_norm = sum(bg_norm,'all')/numel(bg_norm);
    
    %Find the locations of the pixels greater or less than the avg by a
    %large margin
    
    pix_loc = find(bg_norm>avg_pix_norm+0.15);
    pix_loc = [pix_loc; find(bg_norm<avg_pix_norm-0.15)];
    
    %Set the bad/dead pixels to the average pixel value
    for i=1:length(pix_loc)
        background(pix_loc(i)) = avg_pix;
    end
    
    %new background
    if fig_off_on == 1
        figure()
        img_x = linspace(1,pix_xlen,pix_xlen);
        img_y = linspace(1,pix_ylen,pix_ylen);
        surf(img_y,img_x,background)
        shading interp;
        colormap('default');
        xlabel('X')
        ylabel('Y')
    end
    %save('H:\Research\2023\Honeywell - Ilyas\GA - Simulation\Background_img_save\background_1.mat','background');
end