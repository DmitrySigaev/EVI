clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.08.18';
disp(char(['-> ' mfn ' ' version]));

addpath ('..', '..\..', '.\out');
load evi_downs_mds_roi_001_doy_1
ndviCmap = load_ndvi_cmap();

limits = [ 1, 5, 2, 7];
m = evi_3_ds_2( 1:5, 2:7);

 R = 6371007.18100; %Earth's radius in meters

sin_struct = defaultm('sinusoid');
%mstruct.maplonlimit = [-150 -30];
%sin_struct.geoid = almanac('earth','wgs84','meters');

sin_struct.geoid = [R 0];
%sin_struct.geoid = almanac('earth','sphere','meters');
sin_struct = defaultm(sin_struct);



horizontal_tile_no = 19; %part of Italy
  vertical_tile_no = 4; %part of Italy
  R = 6371007.18100; %Earth's radius in meters
  tile_width = 2*pi*R / 36;
  tile_height = tile_width;
  cells = 2400; %number of pixels in the MODIS tile image
  pixel_size = tile_width / cells;
  pixel_size_new = tile_width / 800;
  x_coor_lower_left = -pi*R + horizontal_tile_no * tile_width;
  y_coor_lower_left = -pi*R/2 + (17 - vertical_tile_no) * tile_height;
  x_coor_upper_left = -pi*R + horizontal_tile_no * tile_width;
  y_coor_upper_left = -pi*R/2 + (17 - vertical_tile_no + 1) * tile_height;
  x_coor_upper_right = -pi*R + (horizontal_tile_no + 2)* tile_width;
  
  y_coor_upper_right = -pi*R/2 + (17 - vertical_tile_no + 1) * tile_height;
  x_coor_lower_right = -pi*R + (horizontal_tile_no + 2) * tile_width;
  y_coor_lower_right = -pi*R/2 + (17 - vertical_tile_no) * tile_height;
%Then world coordinate (x,y) of the lower-left corner in the image can be used to interpolate the world coordinates for the rest pixels. By calling 
   [llal,llon] = minvtran(sin_struct,x_coor_upper_left,y_coor_upper_left);
  % 50.000056356929840
  % 50.0069689864989
   
   
  [ll_lati, ll_longi] = inv_sinproj_tr(x_coor_lower_left,y_coor_lower_left);
  [ul_lati, ul_longi] = inv_sinproj_tr(x_coor_upper_left,y_coor_upper_left);
  [ur_lati, ur_longi] = inv_sinproj_tr(x_coor_upper_right,y_coor_upper_right);
  [lr_lati, lr_longi] = inv_sinproj_tr(x_coor_lower_right,y_coor_lower_right);

 %5559752.598832617 - from code
 %5559752.598333 - from modis

load lat_s_lon_s
  
lat_save = lat1;
lon_save = lon1;
%  xx = x_coor_upper_left:pixel_size_new:x_coor_upper_right;
%  yy = y_coor_upper_left:-pixel_size_new:y_coor_lower_left;

%i = 0;
%j = 0;
%lat = zeros(801, 1601);
%lon = zeros(801, 1601);
%for xx =x_coor_upper_left:pixel_size_new:x_coor_upper_right
%    i= i+1;
%    for yy = y_coor_upper_left:-pixel_size_new:y_coor_lower_left
%        j = j+1;
%            [lat_i, long_i] = invSinProj(xx,yy);
%            lat(i, j) = lat_i;
%            lon(i, j) = long_i;
%    end
%end
 
 mstruct = defaultm('sinusoid');
%mstruct.maplonlimit = [-150 -30];
%mstruct.geoid = almanac('earth','wgs84','meters');
mstruct.geoid = [R 0];
%mstruct.geoid = almanac('earth','sphere','meters');
mstruct = defaultm(mstruct);

%[lat_q,lon_q] = minvtran(mstruct, xx(1),yy(1));
[lat_q2,lon_q2] = minvtran(mstruct, 1111950.519667,4447802.078667);
[lat_q1,lon_q1] = inv_sinproj_tr(0.000000,5559752.598333);


 
figure

%I = shapeinfo('./allsta/allsta_1000_972012_TC.shp');
I = shapeinfo('../allsta/allsta_1000_972012_PC.shp');
bb = I.BoundingBox;
xx = [bb(1), bb(2)];
yy = [bb(3), bb(4)];


wgs84 = almanac('earth','wgs84','meters'); 
mstruct = defaultm('utm'); 
mstruct.zone='32N'; 
mstruct.geoid = wgs84; % World Geodetic System
mstruct = defaultm(mstruct); 
%[x_ch3,y_ch3] = mfwdtran(mstruct,lat_ch, lon_ch);
[lat_c, lon_c]=minvtran(mstruct, xx, yy);



%worldmap([44 47], [10 14]);
worldmap([39.8197706210566 50.0069689864989], [0 26.0713521241303]);
%worldmap europe

sz = size(evi_3_ds_2);
lan_d = 50.0069689864989- 39.8197706210566;
lon_d = 39.8197706210566;
d = [lan_d lan_d];

coef = sz./d;


cm = colormap(ndviCmap);
eviDataLim = [-0.25  1.00];



config.mds_xs1 = [2400 2400];
config.mds_xs2 =  [2400 2400];
config.mds_cells = 2400;
config.Code_ROIs = [1:3000]';

Smap_test = get_data_index_from_roi(config, '../allsta/allsta_1000_972012_PC.shp', 'mds');
tm1 = [Smap_test(:).mds_row];
tm2 = [Smap_test(:).mds_col];
disp(tm1);
disp(tm2);

test = zeros(size(evi_3_ds_2));

for index=1:numel(Smap_test)
 Smap_test(index).mds_region_point_ds = round(Smap_test(index).mds_region_point./3);
% disp(Smap_test(index).mds_region_point_ds);
 Smap_test(index).mds_indexes_ds = sub2ind(size(test),  Smap_test(index).mds_region_point_ds(:,1), Smap_test(index).mds_region_point_ds(:,2));
%test (Smap_test(index).mds_indexes_ds) = 256;
test (Smap_test(index).mds_region_point_ds(:,1), Smap_test(index).mds_region_point_ds(:,2)) = 256;

end
%surflsrm(lat_save,lon_save, double(test));

surflsrm(lat_m,lon_m, evi_3_ds_2,[],cm,eviDataLim);

%disp(Smap(1).mds_indexes);
%surface(lat_m, lon_m, double(evi_3_ds_2),...
%    'Linestyle','none','CDataMapping','Direct')
%geoshow(evi_3_ds_2, [100 50.0069689864989 0 ], 'DisplayType', 'texturemap');

land=shaperead('landareas.shp','UseGeoCoords',true);
geoshow([land.Lat],[land.Lon])
m=gcm;
latlim = m.maplatlimit;
lonlim = m.maplonlimit;
BoundingBox = [lonlim(1) latlim(1);lonlim(2) latlim(2)];
cities=shaperead('worldcities.shp', ...
   'BoundingBox',BoundingBox,'UseGeoCoords',true);
for index=1:numel(cities)
   h=textm(cities(index).Lat, cities(index).Lon, ...
           cities(index).Name, 'FontWeight', 'bold', 'Color', 'red');
   trimcart(h)
   rotatetext(h)
end

%Smap = shaperead('./allsta/allsta_1000_972012_TC.shp');
Smap = shaperead('../allsta/allsta_1000_972012_PC.shp');

sSmap = size(Smap, 1);


Spoint =  [ Smap(1:sSmap, 1).X ; Smap(1:sSmap ,1).Y ]';
S_utmi =  [ Smap(1:sSmap,1).UTM32_X; Smap(1:sSmap,1).UTM32_Y ]';
S_latlon =   [ Smap(1:sSmap,1).CG_Lat; Smap(1:sSmap,1).CG_Lon]';
S_latlon2 =   [ Smap(1:sSmap,1).CG_Lon ; Smap(1:sSmap,1).CG_Lat]';

%for index=1:numel(Smap)
%  h=textm(Smap(index).CG_Lat, Smap(index).CG_Lon, ...
%           Smap(index).Name);
%   trimcart(h)
%   rotatetext(h)
%end
geoshow([Smap(1:sSmap,1).CG_Lat], [Smap(1:sSmap,1).CG_Lon],'Marker','o',...
   'MarkerFaceColor','c','MarkerEdgeColor','k');

%mapshow(Smap,'Marker','o',...
%    'MarkerFaceColor','c','MarkerEdgeColor','k');


orient landscape
tightmap
axis off
previewmap



%%

figure

%I = shapeinfo('./allsta/allsta_1000_972012_TC.shp');
I = shapeinfo('./allsta/allsta_1000_972012_PC.shp');
bb = I.BoundingBox;
xx = [bb(1), bb(2)];
yy = [bb(3), bb(4)];


wgs84 = almanac('earth','wgs84','meters'); 
mstruct = defaultm('utm'); 
mstruct.zone='32N'; 
mstruct.geoid = wgs84; % World Geodetic System
mstruct = defaultm(mstruct); 
%[x_ch3,y_ch3] = mfwdtran(mstruct,lat_ch, lon_ch);
[lat_c, lon_c]=minvtran(mstruct, xx, yy);



%worldmap([44 47], [10 14]);
worldmap([39.8197706210566 50.0069689864989], [0 26.0713521241303]);
%worldmap europe

sz = size(evi_3_ds_2);
lan_d = 50.0069689864989- 39.8197706210566;
lon_d = 39.8197706210566;
d = [lan_d lan_d];

coef = sz./d;


cm = colormap(ndviCmap);
eviDataLim = [-0.25  1.00];



config.mds_xs1 = [2400 2400];
config.mds_xs2 =  [2400 2400];
config.mds_cells = 2400;


Smap_test = get_data_index_from_roi(config, './allsta/allsta_1000_972012_PC.shp', 'mds');
tm1 = [Smap_test(:).mds_row];
tm2 = [Smap_test(:).mds_col];
disp(tm1);
disp(tm2);

test = zeros(size(evi_3_ds_2));

for index=1:numel(Smap_test)
 Smap_test(index).mds_region_point_ds = round(Smap_test(index).mds_region_point./3);
% disp(Smap_test(index).mds_region_point_ds);
 Smap_test(index).mds_indexes_ds = sub2ind(size(test),  Smap_test(index).mds_region_point_ds(:,1), Smap_test(index).mds_region_point_ds(:,2));
%test (Smap_test(index).mds_indexes_ds) = 256;
test (Smap_test(index).mds_region_point_ds(:,1), Smap_test(index).mds_region_point_ds(:,2)) = 256;

end
surflsrm(lat_save,lon_save, double(test));

%surflsrm(lat_m,lon_m, evi_3_ds_2,[],cm,eviDataLim);

%disp(Smap(1).mds_indexes);
%surface(lat_m, lon_m, double(evi_3_ds_2),...
%    'Linestyle','none','CDataMapping','Direct')
%geoshow(evi_3_ds_2, [100 50.0069689864989 0 ], 'DisplayType', 'texturemap');

land=shaperead('landareas.shp','UseGeoCoords',true);
geoshow([land.Lat],[land.Lon])
m=gcm;
latlim = m.maplatlimit;
lonlim = m.maplonlimit;
BoundingBox = [lonlim(1) latlim(1);lonlim(2) latlim(2)];
cities=shaperead('worldcities.shp', ...
   'BoundingBox',BoundingBox,'UseGeoCoords',true);
for index=1:numel(cities)
   h=textm(cities(index).Lat, cities(index).Lon, ...
           cities(index).Name, 'FontWeight', 'bold', 'Color', 'red');
   trimcart(h)
   rotatetext(h)
end

%Smap = shaperead('./allsta/allsta_1000_972012_TC.shp');
Smap = shaperead('../allsta/allsta_1000_972012_PC.shp');

sSmap = size(Smap, 1);


Spoint =  [ Smap(1:sSmap, 1).X ; Smap(1:sSmap ,1).Y ]';
S_utmi =  [ Smap(1:sSmap,1).UTM32_X; Smap(1:sSmap,1).UTM32_Y ]';
S_latlon =   [ Smap(1:sSmap,1).CG_Lat; Smap(1:sSmap,1).CG_Lon]';
S_latlon2 =   [ Smap(1:sSmap,1).CG_Lon ; Smap(1:sSmap,1).CG_Lat]';

%for index=1:numel(Smap)
%  h=textm(Smap(index).CG_Lat, Smap(index).CG_Lon, ...
%           Smap(index).Name);
%   trimcart(h)
%   rotatetext(h)
%end
geoshow([Smap(1:sSmap,1).CG_Lat], [Smap(1:sSmap,1).CG_Lon],'Marker','o',...
   'MarkerFaceColor','c','MarkerEdgeColor','k');

%mapshow(Smap,'Marker','o',...
%    'MarkerFaceColor','c','MarkerEdgeColor','k');


orient landscape
tightmap
axis off
previewmap

%%

%%



figure

%I = shapeinfo('./allsta/allsta_1000_972012_TC.shp');
I = shapeinfo('../allsta/allsta_1000_972012_PC.shp');
bb = I.BoundingBox;
xx = [bb(1), bb(2)];
yy = [bb(3), bb(4)];


wgs84 = almanac('earth','wgs84','meters'); 
mstruct = defaultm('utm'); 
mstruct.zone='32N'; 
mstruct.geoid = wgs84; % World Geodetic System
mstruct = defaultm(mstruct); 
%[x_ch3,y_ch3] = mfwdtran(mstruct,lat_ch, lon_ch);
[lat_c, lon_c]=minvtran(mstruct, xx, yy);



worldmap([44 47], [10 14]);
%worldmap([39.8197706210566 50.0069689864989], [0 26.0713521241303]);
%worldmap europe


land=shaperead('landareas.shp','UseGeoCoords',true);
geoshow([land.Lat],[land.Lon])
m=gcm;
latlim = m.maplatlimit;
lonlim = m.maplonlimit;
BoundingBox = [lonlim(1) latlim(1);lonlim(2) latlim(2)];
cities=shaperead('worldcities.shp', ...
   'BoundingBox',BoundingBox,'UseGeoCoords',true);
for index=1:numel(cities)
   h=textm(cities(index).Lat, cities(index).Lon, ...
           cities(index).Name);
   trimcart(h)
   rotatetext(h)
end

%Smap = shaperead('./allsta/allsta_1000_972012_TC.shp');
Smap = shaperead('../allsta/allsta_1000_972012_PC.shp');

sSmap = size(Smap, 1);


Spoint =  [ Smap(1:sSmap, 1).X ; Smap(1:sSmap ,1).Y ]';
S_utmi =  [ Smap(1:sSmap,1).UTM32_X; Smap(1:sSmap,1).UTM32_Y ]';
S_latlon =   [ Smap(1:sSmap,1).CG_Lat; Smap(1:sSmap,1).CG_Lon]';
S_latlon2 =   [ Smap(1:sSmap,1).CG_Lon ; Smap(1:sSmap,1).CG_Lat]';

geoshow([Smap(1:sSmap,1).CG_Lat], [Smap(1:sSmap,1).CG_Lon],'DisplayType','point', 'Marker','o',...
   'MarkerFaceColor','c','MarkerEdgeColor','k');

for index=1:numel(Smap)
   h=textm(Smap(index).CG_Lat, Smap(index).CG_Lon, ...
           Smap(index).Name);
   trimcart(h)
   rotatetext(h)
end

%mapshow(Smap,'Marker','o',...
%    'MarkerFaceColor','c','MarkerEdgeColor','k');


orient landscape
tightmap
axis off
previewmap

%%

figure

%I = shapeinfo('./allsta/allsta_1000_972012_TC.shp');
I = shapeinfo('../allsta/allsta_1000_972012_PC.shp');
bb = I.BoundingBox;
xx = [bb(1), bb(2)];
yy = [bb(3), bb(4)];


wgs84 = almanac('earth','wgs84','meters'); 
mstruct = defaultm('utm'); 
mstruct.zone='32N'; 
mstruct.geoid = wgs84; % World Geodetic System
mstruct = defaultm(mstruct); 
%[x_ch3,y_ch3] = mfwdtran(mstruct,lat_ch, lon_ch);
[lat_c, lon_c]=minvtran(mstruct, xx, yy);




sin_struct = defaultm('sinusoid');
%mstruct.maplonlimit = [-150 -30];
%mstruct.geoid = almanac('earth','wgs84','meters');
sin_struct.geoid = [R 0];
%mstruct.geoid = almanac('earth','sphere','meters');
sin_struct = defaultm(sin_struct);

[x,y] = mfwdtran(sin_struct,lat_c, lon_c);


 horizontal_tile_no = 18; %part of Italy
  vertical_tile_no = 4; %part of Italy
  R = 6371007.18100; %Earth's radius in meters
  tile_width = 2*pi*R / 36;
  tile_height = tile_width;
  cells = 2400; %number of pixels in the MODIS tile image
  pixel_size = tile_width / cells;
  %x0 = [x_coor_lower_right, x_coor_upper_left];
  %x1 = [x_coor_lower_right, x_coor_lower_right];
  x0 = [x_coor_upper_left, x_coor_upper_left];

  i0 =  fix((x-x0)./pixel_size);
  %i1 =  fix((x-x1)./pixel_size);
  %i2 =  fix((x-x2)./pixel_size);
  %j =   (y - )
  d_i = i0(2)- i0(1);

  %y0 = [y_coor_lower_left, y_coor_upper_left];
  y0 = [y_coor_lower_left, y_coor_lower_left];
  %y2 = [y_coor_upper_left, y_coor_upper_left];
  j0 = fix((y-y0)./pixel_size);
  %j1 = fix((y-y1)./pixel_size);
  %j2 = fix((y-y2)./pixel_size);
  d_j = j0(2)- j0(1);



load lat_m_lon_m1


%for xx =x_coor_upper_left:pixel_size_new:x_coor_upper_right
%    i= i+1;
%    for yy = y_coor_upper_left:-pixel_size_new:y_coor_lower_left
%        j = j+1;
%            [lat_i, long_i] = invSinProj(xx,yy);
%            lat(i, j) = lat_i;
%            lon(i, j) = long_i;
%    end
%end
  
  x_coor_lower_left = -pi*R + horizontal_tile_no * tile_width;
  y_coor_lower_left = -pi*R/2 + (17 - vertical_tile_no) * tile_height;
  x_coor_upper_left = -pi*R + horizontal_tile_no * tile_width;
  y_coor_upper_left = -pi*R/2 + (17 - vertical_tile_no + 1) * tile_height;
  x_coor_upper_right = -pi*R + (horizontal_tile_no + 2)* tile_width;
  y_coor_upper_right = -pi*R/2 + (17 - vertical_tile_no + 1) * tile_height;
  x_coor_lower_right = -pi*R + (horizontal_tile_no + 2) * tile_width;
  y_coor_lower_right = -pi*R/2 + (17 - vertical_tile_no) * tile_height;
%Then world coordinate (x,y) of the lower-left corner in the image can be used to interpolate the world coordinates for the rest pixels. By calling 
  [ll_lati, ll_longi] = invSinProj(x_coor_lower_left,y_coor_lower_left);
  [ul_lati, ul_longi] = invSinProj(x_coor_upper_left,y_coor_upper_left);
  [ur_lati, ur_longi] = invSinProj(x_coor_upper_right,y_coor_upper_right);
  [lr_lati, lr_longi] = invSinProj(x_coor_lower_right,y_coor_lower_right);

%[lat_q,lon_q] = minvtran(mstruct, xx(1),yy(1));
[lat_q2,lon_q2] = minvtran(mstruct, 1111950.519667,4447802.078667);
[lat_q1,lon_q1] = invSinProj(0.000000,5559752.598333);



worldmap(lat_c, lon_c);
%worldmap([39.8197706210566 50.0069689864989], [0 26.0713521241303]);
%worldmap europe


land=shaperead('landareas.shp','UseGeoCoords',true);
geoshow([land.Lat],[land.Lon])
m=gcm;
latlim = m.maplatlimit;
lonlim = m.maplonlimit;
BoundingBox = [lonlim(1) latlim(1);lonlim(2) latlim(2)];
cities=shaperead('worldcities.shp', ...
   'BoundingBox',BoundingBox,'UseGeoCoords',true);
for index=1:numel(cities)
   h=textm(cities(index).Lat, cities(index).Lon, ...
           cities(index).Name);
   trimcart(h)
   rotatetext(h)
end

%Smap = shaperead('./allsta/allsta_1000_972012_TC.shp');
Smap = shaperead('../allsta/allsta_1000_972012_PC.shp');

sSmap = size(Smap, 1);



sin_struct = defaultm('sinusoid');
%mstruct.maplonlimit = [-150 -30];
%mstruct.geoid = almanac('earth','wgs84','meters');
sin_struct.geoid = [R 0];
%mstruct.geoid = almanac('earth','sphere','meters');
sin_struct = defaultm(sin_struct);

lat_roi = [Smap(1:sSmap,1).CG_Lat];
lon_roi = [Smap(1:sSmap,1).CG_Lon];
[utm_x, utm_y] = mfwdtran(sin_struct,lat_roi, lon_roi);
col_roi =  fix((utm_x-x_coor_upper_left)./pixel_size);
row_roi =  fix((utm_y-y_coor_lower_left)./pixel_size);


Spoint =  [ Smap(1:sSmap, 1).X ; Smap(1:sSmap ,1).Y ]';
S_utmi =  [ Smap(1:sSmap,1).UTM32_X; Smap(1:sSmap,1).UTM32_Y ]';
S_latlon =   [ Smap(1:sSmap,1).CG_Lat; Smap(1:sSmap,1).CG_Lon]';
S_latlon2 =   [ Smap(1:sSmap,1).CG_Lon ; Smap(1:sSmap,1).CG_Lat]';


geoshow([Smap(1:sSmap,1).CG_Lat], [Smap(1:sSmap,1).CG_Lon],'DisplayType','point', 'Marker','o',...
   'MarkerFaceColor','c','MarkerEdgeColor','k');


config.mds_xs1 = [2400 2400];
config.mds_xs2 = [2400 2400];
config.mds_cells = 2400;


Smap___2 = get_data_index_from_roi(config, '../allsta/allsta_1000_972012_PC.shp', 'mds');
%disp(Smap(1).mds_indexes);


for index=1:numel(Smap)
   h=textm(Smap(index).CG_Lat, Smap(index).CG_Lon, ...
           Smap(index).Name);
   trimcart(h)
   rotatetext(h)
end



%mapshow(Smap,'Marker','o',...
%    'MarkerFaceColor','c','MarkerEdgeColor','k');


orient landscape
tightmap
axis off
previewmap

disp(char(['<- ' mfn ' ' version]));
