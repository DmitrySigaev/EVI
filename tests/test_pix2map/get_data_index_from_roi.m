function [Smap, roi_station_are_not_founded] = get_data_index_from_roi(config, path, type, tile)

Smap1 = shaperead(path(1,:));
%ss1 = Smap1(1); %struct array with field
%fn1 = fieldnames(ss1);
%sfn1 = size(fn1,1);

CodeROI1 = [Smap1(:).Code]';

[c1, ia1, ib1] = intersect (CodeROI1, config.Code_ROIs);
all_index_roi = 1:size(config.Code_ROIs);

delete1 = config.Code_ROIs(ib1);

other_roi = setxor(ib1, all_index_roi); % all good indexes without any mask

Smap_1 = Smap1(ia1);
sSmap1 = size(Smap_1, 1);


for i = 1:sSmap1
    Smap(ib1(i)).Name = Smap_1(i).Name;
    Smap(ib1(i)).Code = Smap_1(i).Code;
    Smap(ib1(i)).CG_Lat = Smap_1(i).CG_Lat;
    Smap(ib1(i)).CG_Lon = Smap_1(i).CG_Lon;
end


sSmap = size(Smap, 2);

if(strcmp(type,'mds') || strcmp(type,'all'))

% begin of uml2singrid.m 
    
R = 6371007.18100; %Earth's radius in meters

if(strcmp(tile,'h18v04'))
horizontal_tile_no(1) = 18; %part of Italy
vertical_tile_no(1) = 4; %part of Italy
end
if(strcmp(tile,'h19v04'))
horizontal_tile_no(1) = 19; %part of Italy
vertical_tile_no(1) = 4; %part of Italy
end
tile_width = 2*pi*R / 36;
tile_height = tile_width;
config.x_coor_upper_left(1) = -pi*R + horizontal_tile_no(1) * tile_width;
config.y_coor_upper_left(1) = -pi*R/2 + (17 - vertical_tile_no(1)+1) * tile_height;

pixel_size = tile_width / config.mds_cells;
  
sin_struct = defaultm('sinusoid');
%mstruct.maplonlimit = [-150 -30];
%sin_struct.geoid = almanac('earth','wgs84','meters');
sin_struct.geoid = [R 0];
%sin_struct.geoid = almanac('earth','sphere','meters');
sin_struct = defaultm(sin_struct);

lat_roi = [Smap(1,1:sSmap).CG_Lat];
lon_roi = [Smap(1,1:sSmap).CG_Lon];
[spheroid_x, spheroid_y] = mfwdtran(sin_struct,lat_roi, lon_roi);
col_roi1 =  round((spheroid_x-config.x_coor_upper_left(1))./pixel_size);
row_roi1 =  round((config.y_coor_upper_left(1)-spheroid_y)./pixel_size);

% end of uml2singrid.m 

for index=1:numel(Smap)
   pix_r(1) = row_roi1(index);
   pix_c(1) = col_roi1(index);
   if(pix_r(1) > 0 && pix_r(1) < config.mds_xs(1) && pix_c(1) > 0 && pix_c(1) < config.mds_xs(2))
       Smap(index).mds_tile = tile;
       Smap(index).mds_row = round(pix_r(1));
       Smap(index).mds_col = round(pix_c(1));
       Smap(index).mds_index = sub2ind(config.mds_xs, Smap(index).mds_row, Smap(index).mds_col);
% begin of blockproc       
       Smap(index).mds_region_point =  [round(pix_r(1)-1), round(pix_c(1)-1); round(pix_r(1)-1), round(pix_c(1)); round(pix_r(1)-1), round(pix_c(1)+ 1); ...
                                    round(pix_r(1)), round(pix_c(1)-1); round(pix_r(1)), round(pix_c(1)); round(pix_r(1)), round(pix_c(1)+ 1); ...
                                    round(pix_r(1)+1), round(pix_c(1)-1); round(pix_r(1)+1), round(pix_c(1)); round(pix_r(1)+1), round(pix_c(1)+ 1)];
% end of blockproc                                       
       Smap(index).mds_indexes = sub2ind(config.mds_xs,  Smap(index).mds_region_point(:,1), Smap(index).mds_region_point(:,2));
   else
      Smap(index).mds_index = 0;
       Smap(index).mds_row = 0;
       Smap(index).mds_col = 0;
     
   end
end
end

if(strcmp(type,'srtm') || strcmp(type,'all'))
for index=1:numel(Smap)
   Smap(index).elev_index = 0;
   Smap(index).elev_tile = 0;
   [pix_r(1), pix_c(1)] = map2pix(config.srtm_R1, Smap(index).CG_Lon, Smap(index).CG_Lat);
   if(pix_r(1) > 0 && pix_r(1) < config.srtm_xs1(1) && pix_c(1) > 0 && pix_c(1) < config.srtm_xs1(2))
       Smap(index).elev_tile = 1;
       Smap(index).elev_row = round(pix_r(1));
       Smap(index).elev_col = round(pix_c(1));
       Smap(index).elev_index = sub2ind(config.srtm_xs1, Smap(index).elev_row, Smap(index).elev_col);
       Smap(index).elev_region_point =  [round(pix_r(1)-1), round(pix_c(1)-1); round(pix_r(1)-1), round(pix_c(1)); round(pix_r(1)-1), round(pix_c(1)+ 1); ...
                                    round(pix_r(1)), round(pix_c(1)-1); round(pix_r(1)), round(pix_c(1)); round(pix_r(1)), round(pix_c(1)+ 1); ...
                                    round(pix_r(1)+1), round(pix_c(1)-1); round(pix_r(1)+1), round(pix_c(1)); round(pix_r(1)+1), round(pix_c(1)+ 1)];
       Smap(index).elev_indexes = sub2ind(config.srtm_xs1,  Smap(index).elev_region_point(:,1), Smap(index).elev_region_point(:,2));
   end
   [pix_r(2), pix_c(2)] = map2pix(config.srtm_R2, Smap(index).CG_Lon, Smap(index).CG_Lat);
   if(pix_r(2) > 0 && pix_r(2) < config.srtm_xs2(1) && pix_c(2) > 0 && pix_c(2) < config.srtm_xs2(2))
       Smap(index).elev_tile = 2;
       Smap(index).elev_row = round(pix_r(2));
       Smap(index).elev_col = round(pix_c(2));
       Smap(index).elev_index = sub2ind(config.srtm_xs2, Smap(index).elev_row, Smap(index).elev_col);
       Smap(index).elev_region_point =  [round(pix_r(2)-1), round(pix_c(2)-1); round(pix_r(2)-1), round(pix_c(2)); round(pix_r(2)-1), round(pix_c(2)+ 1); ...
                                    round(pix_r(2)), round(pix_c(2)-1); round(pix_r(2)), round(pix_c(2)); round(pix_r(2)), round(pix_c(2)+ 1); ...
                                    round(pix_r(2)+1), round(pix_c(2)-1); round(pix_r(2)+1), round(pix_c(2)); round(pix_r(2)+1), round(pix_c(2)+ 1)];
       Smap(index).elev_indexes = sub2ind(config.srtm_xs2,  Smap(index).elev_region_point(:,1), Smap(index).elev_region_point(:,2));
   end
   [pix_r(3), pix_c(3)] = map2pix(config.srtm_R3, Smap(index).CG_Lon, Smap(index).CG_Lat);
   if(pix_r(3) > 0 && pix_r(3) < config.srtm_xs3(1) && pix_c(3) > 0 && pix_c(3) < config.srtm_xs3(2))
       Smap(index).elev_tile = 3;
       Smap(index).elev_row = round(pix_r(3));
       Smap(index).elev_col = round(pix_c(3));
       Smap(index).elev_index = sub2ind(config.srtm_xs3, Smap(index).elev_row, Smap(index).elev_col);
       Smap(index).elev_region_point =  [round(pix_r(3)-1), round(pix_c(3)-1); round(pix_r(3)-1), round(pix_c(3)); round(pix_r(3)-1), round(pix_c(3)+ 1); ...
                                         round(pix_r(3)),   round(pix_c(3)-1); round(pix_r(3)),   round(pix_c(3)); round(pix_r(3)),   round(pix_c(3)+ 1); ...
                                         round(pix_r(3)+1), round(pix_c(3)-1); round(pix_r(3)+1), round(pix_c(3)); round(pix_r(3)+1), round(pix_c(3)+ 1)];
       Smap(index).elev_indexes = sub2ind(config.srtm_xs3,  Smap(index).elev_region_point(:,1), Smap(index).elev_region_point(:,2));
   end
   [pix_r(4), pix_c(4)] = map2pix(config.srtm_R4, Smap(index).CG_Lon, Smap(index).CG_Lat);
   if(pix_r(4) > 0 && pix_r(4) < config.srtm_xs4(1) && pix_c(4) > 0 && pix_c(4) < config.srtm_xs4(2))
       Smap(index).elev_tile = 4;
       Smap(index).elev_row = round(pix_r(4));
       Smap(index).elev_col = round(pix_c(4));
       Smap(index).elev_index = sub2ind(config.srtm_xs4, Smap(index).elev_row, Smap(index).elev_col);
       Smap(index).elev_region_point =  [round(pix_r(4)-1), round(pix_c(4)-1); round(pix_r(4)-1), round(pix_c(4)); round(pix_r(4)-1), round(pix_c(4)+ 1); ...
                                         round(pix_r(4)),   round(pix_c(4)-1); round(pix_r(4)),   round(pix_c(4)); round(pix_r(4)),   round(pix_c(4)+ 1); ...
                                         round(pix_r(4)+1), round(pix_c(4)-1); round(pix_r(4)+1), round(pix_c(4)); round(pix_r(4)+1), round(pix_c(4)+ 1)];
       Smap(index).elev_indexes = sub2ind(config.srtm_xs4,  Smap(index).elev_region_point(:,1), Smap(index).elev_region_point(:,2));
   end
end
end

if(strcmp(type,'tm') || strcmp(type,'all'))
for index=1:numel(Smap)
   [x, y] = projfwd(config.tm_proj, Smap(index).CG_Lat, Smap(index).CG_Lon);
   [pix_r(1), pix_c(1)] = map2pix(config.tm_R, x, y);
   if(pix_r(1) > 0 && pix_r(1) < config.tm_xs(1) && pix_c(1) > 0 && pix_c(1) < config.tm_xs(2))
       Smap(index).tm_tile = tile;
       Smap(index).tm_row = round(pix_r(1));
       Smap(index).tm_col = round(pix_c(1));
       Smap(index).tm_index = sub2ind(config.tm_xs, Smap(index).tm_row, Smap(index).tm_col);
       Smap(index).tm_region_point =  [round(pix_r(1)-1), round(pix_c(1)-1); round(pix_r(1)-1), round(pix_c(1)); round(pix_r(1)-1), round(pix_c(1)+ 1); ...
                                    round(pix_r(1)), round(pix_c(1)-1); round(pix_r(1)), round(pix_c(1)); round(pix_r(1)), round(pix_c(1)+ 1); ...
                                    round(pix_r(1)+1), round(pix_c(1)-1); round(pix_r(1)+1), round(pix_c(1)); round(pix_r(1)+1), round(pix_c(1)+ 1)];
       Smap(index).tm_indexes = sub2ind(config.tm_xs,  Smap(index).tm_region_point(:,1), Smap(index).tm_region_point(:,2));
    else
      Smap(index).tm_index = 0;
   end
end
end
end