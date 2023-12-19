function[SLL,SLL_az,SLL_el,SLL_real,BW1_3dB,BW2_3dB]=SLL_calc(SLL,SLL_az,SLL_el,SLL_real,uta_final,BW1_3dB,BW2_3dB,sv,fc,l_h,count)

% SLL={};
% SLL_real={};
% SLL_az={};
% SLL_el={};
% BW1_3dB=[];
% BW2_3dB=[];

if l_h==0
    res=-1:0.01:1;%lower res
elseif l_h==1
    res=-0.2:0.001:0.2;%higher res
end

[pat_uv,az_uv,el_uv] = pattern(uta_final,fc,res,res,'CoordinateSystem','uv',...
    'PropagationSpeed',physconst('Lightspeed'),'Type','power','Weights',sv);

%find the index of the mainlobe
pat_uv_max=max(max(pat_uv));
[u,v]=find(pat_uv==pat_uv_max);
pat_uv_az=pat_uv(u,:);
pat_uv_el=pat_uv(:,v);

%convert to dB
pat_uv_az_dB=10.*log10(pat_uv_az);
pat_uv_el_dB=10.*log10(pat_uv_el);

pat_uv_az_dB=-1*pat_uv_az_dB;
pat_uv_el_dB=-1*pat_uv_el_dB;

[pks,locs]=findpeaks(pat_uv_az_dB);

%find the index of the first SL for az
[val_az,idx]=min(abs(u-locs));
minVal=locs(idx);


[pks_el,locs_el]=findpeaks(pat_uv_el_dB);

%find the index of the first SL for el
[val_el,idx_el]=min(abs(v-locs_el));
minVal_el=locs_el(idx_el);

if val_az<val_el
    val=val_el;
else
    val=val_az;
end
%filter out the mainlobe & calculate the SLL
pat_uv(u-val_az:u+val_az,v-val:v+val)=0;
pat_uv_az=pat_uv(u,:);

%convert to dB
pat_uv_az_dB=10.*log10(pat_uv_az);
pat_uv_dB=10.*log10(pat_uv);
SLL{end+1}=max(max(pat_uv_dB));

[pat_az,az,el] = pattern(uta_final,fc,-180:0.01:180,0,'CoordinateSystem','rectangular',...
    'PropagationSpeed',physconst('Lightspeed'),'Type','powerdb','Weights',sv);

[pat_el,az1,el1] = pattern(uta_final,fc,0,-90:0.01:90,'CoordinateSystem','rectangular',...
    'PropagationSpeed',physconst('Lightspeed'),'Type','powerdb','Weights',sv);

%Find the BW and the Null locations
[BW1,Ang1] = beamwidth(uta_final,fc,'Cut','Azimuth','Weights',sv,'dBDown',Inf);
[BW2,Ang2] = beamwidth(uta_final,fc,'Cut','Elevation','Weights',sv,'dBDown',Inf)

%Find the 2 angles in az where the nulls occur
Null_az_1=find(round(az*100)==round(Ang1(1)*100));
Null_az_2=find(round(az*100)==round(Ang1(2)*100));

%Find the 2 angles in el where the nulls occur
Null_el_1=find(round(el1*100)==round(Ang2(1)*100));
Null_el_2=find(round(el1*100)==round(Ang2(2)*100));

%convert from dB to linear power
pat_az=10.^(pat_az/10);
pat_el=10.^(pat_el/10);

%set the main lobe to zero
pat_az_SL=pat_az;
pat_az_SL([Null_az_1:Null_az_2])=0; %azimuth

pat_el_SL=pat_el;
pat_el_SL([Null_el_1:Null_el_2])=0; %elevation

%convert from linear to dB
pat_az_SL=10*log10(pat_az_SL);
pat_el_SL=10*log10(pat_el_SL);

%SLL along az/el
SLL_az{end+1}=max(pat_az_SL);
SLL_el{end+1}=max(pat_el_SL);
   
SLL_real{end+1}=max([SLL{1,count},SLL_az{1,count},SLL_el{1,count}]);
%SLL_real=max([SLL_az,SLL_el]);
BW1_3dB(end+1) = beamwidth(uta_final,fc,'Cut','Azimuth','Weights',sv);
BW2_3dB(end+1) = beamwidth(uta_final,fc,'Cut','Elevation','Weights',sv);
