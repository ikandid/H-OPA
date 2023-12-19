
function SLL = Ex_3_6(a, b)
    %Example from a comp. approach for antenna arrays
    c = 3e8;
    fc = 193e12;
    lambda = c/fc;
    k=2*pi/lambda;%wavenumber
    resolution=100;
    theta=linspace(-90,90,resolution*181);
    theta_0=0;

    %structural paramaters
    N_s=6; %Number of SAs
    N_e=12; %Number of elements in a SA
    elem_factor=1.5;
    d=elem_factor*lambda;

    %define the AF
    AF=0;
    a = [1 a];
    b = [1 b];
    for q=1:N_s
        %b(end+1)=1;
        for n=1:N_e
            %a(end+1)=1;
            AF=AF+b(q)*a(n)*cos(k*d*sind(theta)*(n-0.5+(q-1)*N_e));
        end
    end

    AF=2*AF;

    AF_mag=abs(AF);

    %Intensity & Normalized Intensity
    Intensity=AF_mag.^2;
    Intensity_norm=Intensity/max(max(Intensity));
    Intensity_dB=10.*log10(Intensity_norm);


    %Calculating SLL
    neg_Intensity_dB=-1*Intensity_dB;
    [pks,locs]=findpeaks(neg_Intensity_dB);
    max_loc=find(Intensity_dB==0);
    [val,idx]=min(abs(max_loc(1)-locs));

    Intensity_norm(1,max_loc(1)-val:max_loc(1)+val)=0;
    Intensity_dB=10.*log10(Intensity_norm);
    SLL=max(Intensity_dB);

end
