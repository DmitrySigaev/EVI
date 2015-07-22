% The level-3 MODIS global Land Surface Temperature (LST) and Emissivity 8-day
% data are composed from the daily 1-kilometer LST product (MYD11A1) and stored
% on a 1-km Sinusoidal grid as the average values of clear-sky LSTs during an 8-day period.

% MYD11A2 is comprised of daytime and nighttime LSTs, quality assessment, observation times,
% view angles, bits of clear sky days and nights, and emissivities estimated in Bands 31 and
% 32 from land cover types.

% Version-5 MODIS/Aqua Land Surface Temperature/Emissivity products are validated to Stage 2,
% which means that their accuracy has been assessed over a widely distributed set of locations
% and time periods via several ground-truth and validation efforts.  Further details regarding
% MODIS land product validation for the LST/E products are available from the following
% URL: http://landval.gsfc.nasa.gov/ProductStatus.php?ProductID=MYD11
%- See more at: https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/myd11a2#sthash.Ypnmm7AI.dpuf

%Land Surface Temperature & Emissivity 8-Day L3 Global 1km 
% MYD11A2 reading
function [LST, scale, offset, fillval] = read_myd11_t(FILE_NAME)

file_id = hdfgd('open', FILE_NAME, 'rdonly');

%Reading Data from a Data Field
GRID_NAME='MODIS_Grid_8Day_1km_LST';
grid_id = hdfgd('attach', file_id, GRID_NAME);
clearvars GRID_NAME

DATAFIELD_NAME1='LST_Day_1km'; %LST_Day_1km: 8-Day daytime 1km grid land surface temperature 
DATAFIELD_NAME2='LST_Night_1km'; %LST_Night_1km: 8-Day nighttime 1km grid land surface temperature 

[data1, fail1] = hdfgd('readfield', grid_id, DATAFIELD_NAME1, [], [], []);
[data2, fail2] = hdfgd('readfield', grid_id, DATAFIELD_NAME2, [], [], []);
clearvars fail1 fail2 

%Convert M-D data to 2-D data
data_1=data1;
data_2=data2;

%Convert the data to double type for plot
data_1=double(data_1);
data_2=double(data_2);

%Transpose the data to match the map projection
data_1=data_1';
data_2=data_2';

%Remove items from workspace, freeing up system memory
%Clear variables from memory
clearvars data1 data2 data3 data4 data5 data6

LST = struct('LST_Day', data_1, 'LST_Night', data_2, 'i' , '1');

clearvars data_1 data_2 

%Detaching from the Grid Object
hdfgd('detach', grid_id);
%Closing the File
hdfgd('close', file_id);
clearvars file_id grid_id


%Reading attributes from the data field
SD_id = hdfsd('start',FILE_NAME, 'rdonly');
%clearvars FILE_NAME

sds_index1 = hdfsd('nametoindex', SD_id, DATAFIELD_NAME1);
sds_index2 = hdfsd('nametoindex', SD_id, DATAFIELD_NAME2);
clearvars DATAFIELD_NAME1 DATAFIELD_NAME2 

sds_id1 = hdfsd('select',SD_id, sds_index1);
sds_id2 = hdfsd('select',SD_id, sds_index2);
clearvars sds_index1 sds_index2 

%Reading filledValue from the data field
fillvalue_index1 = hdfsd('findattr', sds_id1, '_FillValue');
fillvalue_index2 = hdfsd('findattr', sds_id2, '_FillValue');

[fillvalue1, status] = hdfsd('readattr',sds_id1, fillvalue_index1);
[fillvalue2, status] = hdfsd('readattr',sds_id2, fillvalue_index2);
clearvars fillvalue_index1 fillvalue_index2 

%if (fillvalue1 == fillvalue2 && fillvalue2 == fillvalue3 && fillvalue3 == fillvalue4)
%   fillval = fillvalue1; 
%else
   fillval = struct('f1', fillvalue1, 'f2', fillvalue2);
%end

%Reading units from the data field

%Reading scale_factor from the data field
scale_index1 = hdfsd('findattr', sds_id1, 'scale_factor');
scale_index2 = hdfsd('findattr', sds_id2, 'scale_factor');

[scale1, status] = hdfsd('readattr',sds_id1, scale_index1);
[scale2, status] = hdfsd('readattr',sds_id2, scale_index2);

clearvars scale_index1 scale_index2 

%if (scale1 == scale2 && scale2 == scale3 && scale3 == scale4)
%   scale = scale1; 
%else
   scale = struct('s1', scale1, 's2', scale2);
%end

clearvars scale1 scale2

%Reading add_offset from the data field
offset_index1 = hdfsd('findattr', sds_id1, 'add_offset');
offset_index2 = hdfsd('findattr', sds_id2, 'add_offset');

[offset1, status] = hdfsd('readattr',sds_id1, offset_index1);
[offset2, status] = hdfsd('readattr',sds_id2, offset_index2);


%if (offset1 == offset2 && offset2 == offset3 && offset3 == offset4)
%   offset = offset1; 
%else
   offset = struct('o1', offset1, 'o2', offset2);
%end

clearvars offset1 offset2
clearvars status

%Terminate access to the corresponding data set
hdfsd('endaccess', sds_id1);
hdfsd('endaccess', sds_id2);
%Closing the File
hdfsd('end', SD_id);
clearvars SD_id sds_id1 sds_id2

