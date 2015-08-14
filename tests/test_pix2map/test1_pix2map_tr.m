clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.08.12';
disp(char(['-> ' mfn ' ' version]));


addpath ('..', '..\..');

[files, dirs] = findallfiles( '..', 'r' );
dirs = dirs';
files = files';
expr = '[^:].*elev[^:]+\.tif$';
[t m] = regexpi(files, expr ,'tokens', 'match', 'lineanchors') ;
isdef = @(x) (~isempty(x));
log = double(cellfun(isdef,m));

index = find(log ==1);

input_f = files(index);

srtm_38_03_file_name = input_f{1};
srtm_38_04_file_name = input_f{2};
srtm_39_03_file_name = input_f{3};
srtm_39_04_file_name = input_f{4};


expr = '[^:].*972012_P[^:]+\.shp$';
[t m] = regexpi(files, expr ,'tokens', 'match', 'lineanchors') ;
log = double(cellfun(isdef,m));
index = find(log ==1);
input_f = files(index);

allsta_1000_972012_PC = input_f{1};


proj = geotiffinfo(srtm_38_04_file_name);

%disp(proj);
%struct = geotiff2mstruct(proj); doesn't work

%[latlim, lonlim] = utmzone('32t'); %temporary comment
%[x, y] = projfwd(proj, latlim, lonlim); %temporary comment

[X, cmap, R1, bbox] = geotiffread(srtm_38_03_file_name);
i = find(X==-32768);
X(i) = NaN;
mx1 = max(max(X)); 
mn1 = min(min(X)); 

downsample_step = 10;

 X_ds = downsample(X,downsample_step);
 X_ds_2_1 = downsample(X_ds',downsample_step)';
%imagesc(X_ds_2,[mn mx]);


i = 0;
xx_i = 1:downsample_step:size(X, 2);
yy_i = 1:downsample_step:size(X, 1);
for xx = 1:downsample_step:size(X, 2);
    i = i+1;
    if (i <= size(xx_i, 2))
        j = 0;
        for yy =  1:downsample_step:size(X, 1);
            j = j+1;
             if( j <= size(yy_i, 2) )
                [lon_i, lat_i]= pix2map(R1, yy, xx');
%                [lat_i, lon_i] = inv_sinproj_tr(xx,yy);
                 lat1(j, i) = lat_i;
                 lon1(j, i) = lon_i;
             end
        end
    end
end

downsample_step1 = downsample_step;
save('lat_s_lon_s.mat' , 'lat1', 'lon1', 'downsample_step1', 'R1');

clearvars X X_ds

%%

[X, cmap, R2, bbox] = geotiffread(srtm_39_03_file_name);
i = find(X==-32768);
X(i) = NaN;
mx2 = max(max(X)); 
mn2 = min(min(X)); 

 X_ds = downsample(X,downsample_step);
 X_ds_2_2 = downsample(X_ds',downsample_step)';
%imagesc(X_ds_2,[mn mx]);


i = 0;
xx_i = 1:downsample_step:size(X, 2);
yy_i = 1:downsample_step:size(X, 1);
for xx = 1:downsample_step:size(X, 2);
    i = i+1;
    if (i <= size(xx_i, 2))
        j = 0;
        for yy =  1:downsample_step:size(X, 1);
            j = j+1;
             if( j <= size(yy_i, 2) )
                [lon_i, lat_i]= pix2map(R2, yy, xx');
%                [lat_i, lon_i] = inv_sinproj_tr(xx,yy);
                 lat2(j, i) = lat_i;
                 lon2(j, i) = lon_i;
             end
        end
    end
end
clearvars X X_ds

downsample_step2 = downsample_step;
save('lat_s_lon_s1.mat' , 'lat2', 'lon2' , 'downsample_step2', 'R2');

%%

[X, cmap, R3, bbox] = geotiffread(srtm_38_04_file_name);
i = find(X==-32768);
X(i) = NaN;
mx3 = max(max(X)); 
mn3 = min(min(X)); 

downsample_step = 10;

 X_ds = downsample(X,downsample_step);
 X_ds_2_3 = downsample(X_ds',downsample_step)';
%imagesc(X_ds_2,[mn mx]);


i = 0;
xx_i = 1:downsample_step:size(X, 2);
yy_i = 1:downsample_step:size(X, 1);
for xx = 1:downsample_step:size(X, 2);
    i = i+1;
    if (i <= size(xx_i, 2))
        j = 0;
        for yy =  1:downsample_step:size(X, 1);
            j = j+1;
             if( j <= size(yy_i, 2) )
                [lon_i, lat_i]= pix2map(R3, yy, xx');
%                [lat_i, lon_i] = inv_sinproj_tr(xx,yy);
                 lat3(j, i) = lat_i;
                 lon3(j, i) = lon_i;
             end
        end
    end
end

downsample_step3 = downsample_step;
save('lat_s_lon_s2.mat' , 'lat3', 'lon3', 'downsample_step3', 'R3');

clearvars X X_ds

[X, cmap, R4, bbox] = geotiffread(srtm_39_04_file_name);
i = find(X==-32768);
X(i) = NaN;
mx4 = max(max(X)); 
mn4 = min(min(X)); 

 X_ds = downsample(X,downsample_step);
 X_ds_2_4 = downsample(X_ds',downsample_step)';
%imagesc(X_ds_2,[mn mx]);


i = 0;

xx_i = 1:downsample_step:size(X, 2);
yy_i = 1:downsample_step:size(X, 1);
for xx = 1:downsample_step:size(X, 2);
    i = i+1;
    if (i <= size(xx_i, 2))
        j = 0;
        for yy =  1:downsample_step:size(X, 1);
            j = j+1;
             if( j <= size(yy_i, 2) )
                [lon_i, lat_i]= pix2map(R4, yy, xx');
%                [lat_i, lon_i] = inv_sinproj_tr(xx,yy);
                 lat4(j, i) = lat_i;
                 lon4(j, i) = lon_i;
             end
        end
    end
end
clearvars X X_ds

downsample_step4 = downsample_step;
save('lat_s_lon_s3.mat' , 'lat4', 'lon4' , 'downsample_step4', 'R4');

srtmDataLim = [min(min(mn1, mn2), min(mn3, mn4)) max(max(mx1, mx2), max(mx3, mx4))];

figure
worldmap([39.8197706210566 50.0069689864989], [0 26.0713521241303]);

%cm = colormap;
%surflsrm(lat,lon, double(X_ds_2),[],cm,srtmDataLim);
surflsrm(lat1,lon1, double(X_ds_2_1));
surflsrm(lat2,lon2, double(X_ds_2_2));
surflsrm(lat3,lon3, double(X_ds_2_3));
surflsrm(lat4,lon4, double(X_ds_2_4));

land=shaperead('landareas.shp','UseGeoCoords',true);
geoshow([land.Lat],[land.Lon])

%Smap = shaperead('./allsta/allsta_1000_972012_TC.shp');
Smap = shaperead(allsta_1000_972012_PC);

sSmap = size(Smap, 1);


%for index=1:numel(Smap)
%  h=textm(Smap(index).CG_Lat, Smap(index).CG_Lon, ...
%           Smap(index).Name);
 %  trimcart(h);
%   rotatetext(h);
%   map2pix(R, yy, xx');
%   
%end
geoshow([Smap(1:sSmap,1).CG_Lat], [Smap(1:sSmap,1).CG_Lon],'Marker','o',...
   'MarkerFaceColor','red','MarkerEdgeColor','k');

disp(char(['<- ' mfn ' ' version]));
