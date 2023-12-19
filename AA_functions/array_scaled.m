function [distances, min_dist] =array_scaled(M,pos_final)
    
    %Used for the standarcd circular array since it is shifted, which changes the
    %max location
    pos_final = [];
    pos_final(1,:) = y_before{1,1}*1e-6;
    pos_final(2,:) = z_before{1,1}*1e-6;
    pos_final(3,:) = zeros(1,length(pos_final));

    %plot the element positions
    figure
    scatter(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,'filled','k');
    xlabel('x(um)','Fontsize',14)
    ylabel('y(um)','Fontsize',14)
    
    %labels each element with an index
    label = cellstr(num2str([1:length(pos_final)]'));
    text(pos_final(1,:)'/1e-6,pos_final(2,:)'/1e-6,label);grid on;
   
    %scale our array to a max of 250 um x 250 um
    max_x_val = max(pos_final(1,:));
    max_y_val = max(pos_final(2,:));
    max_val = max(max_x_val, max_y_val);

    %scale = 2.44e-4/max_val;
    %scale = 3.39e-4/max_val;
    scale = 1.2605;
    pos_final_scaled = scale*pos_final;

    figure
    scatter(pos_final_scaled(1,:)'/1e-6,pos_final_scaled(2,:)'/1e-6,'filled','k');
    xlabel('x(um)','Fontsize',14)
    ylabel('y(um)','Fontsize',14)
    %axis off

    %labels each element with an index
    %label = cellstr(num2str([1:length(pos_final)]'));
    %text(pos_final_scaled(1,:)'/1e-6,pos_final_scaled(2,:)'/1e-6,label);grid on;

    %define the AF and intensity distributions [Intensity_norm,Intensity_dB,u,v,theta,phi]=AF_general(A,B,C,D,pos_final,lambda,figure_on_off,theta_0,phi_0,ant,theta_90)
    [Intensity_norm,Intensity_dB,u,v,theta,phi,SLL]=AF_general(M,N,M_SA_circle,N_SA_circle,pos_final_scaled,lambda,1,theta_0,phi_0,ant,1);

    %cuts
    res = 100;
    SLL_theta = [];
    phi_cut = [0 45 90 135];

    for i=1:length(phi_cut)
        %[Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta,w]=theta_cut(A,B,C,D,resolution,p,pos_final,figure_on_off,theta_0,ant,theta_90)
        [Intensity_norm_theta,Intensity_dB_theta,p,theta,c,index,BW_3dB_theta,SLL_theta(i)]=theta_cut(M,N,M_SA_circle,N_SA_circle,res,phi_cut(i),pos_final_scaled,0,0,0,1);
    end

    SLL_real=max([SLL,SLL_theta]);