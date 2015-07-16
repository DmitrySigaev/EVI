% The MODerate-resolution Imaging Spectroradiometer (MODIS) Reflectance product
% MCD43A4 provides 500-meter reflectance data adjusted using a bidirectional
% reflectance distribution function (BRDF) to model the values as if they were
% taken from nadir view. The MCD43A4 product contains 16 days of data provided
% in a level-3 gridded data set in Sinusoidal projection. 
% Both Terra and Aqua data are used in the generation of this product, providing
% the highest probability for quality input data and designating it as an MCD,
% meaning Combined, product. - 
% See more at: https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mcd43a4#sthash.hiQlC3cQ.dpuf

% Reads MCD43A4 hdf files
function [red_d, nir_d, blue_d, green_d, scale, offset, fillval] = read_data_from_a4(FILE_NAME)

file_id = hdfgd('open', FILE_NAME, 'rdonly');

%Reading Data from a Data Field
GRID_NAME='MOD_Grid_BRDF';
grid_id = hdfgd('attach', file_id, GRID_NAME);
clearvars GRID_NAME

DATAFIELD_NAME1='Nadir_Reflectance_Band1'; %mcdca4-- RED
DATAFIELD_NAME2='Nadir_Reflectance_Band2'; %mcdca4-- NIR
DATAFIELD_NAME3='Nadir_Reflectance_Band3'; %mcdca4-- B
DATAFIELD_NAME4='Nadir_Reflectance_Band4'; %mcdca4-- G

[data1, fail1] = hdfgd('readfield', grid_id, DATAFIELD_NAME1, [], [], []);
[data2, fail2] = hdfgd('readfield', grid_id, DATAFIELD_NAME2, [], [], []);
[data3, fail3] = hdfgd('readfield', grid_id, DATAFIELD_NAME3, [], [], []);
[data4, fail4] = hdfgd('readfield', grid_id, DATAFIELD_NAME4, [], [], []);
clearvars fail1 fail2 fail3 fail4

%Convert M-D data to 2-D data
data_1=data1;
data_2=data2;
data_3=data3;
data_4=data4;

%Convert the data to double type for plot
data_1=double(data_1);
data_2=double(data_2);
data_3=double(data_3);
data_4=double(data_4);

%Transpose the data to match the map projection
data_1=data_1';
data_2=data_2';
data_3=data_3';
data_4=data_4';

%Remove items from workspace, freeing up system memory
%Clear variables from memory
clearvars data1 data2 data3 data4

red_d=data_1;
nir_d=data_2;
blue_d=data_3;
green_d=data_4;

clearvars data_1 data_2 data_3 data_4


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
sds_index3 = hdfsd('nametoindex', SD_id, DATAFIELD_NAME3);
sds_index4 = hdfsd('nametoindex', SD_id, DATAFIELD_NAME4);
clearvars DATAFIELD_NAME1 DATAFIELD_NAME2 DATAFIELD_NAME3 DATAFIELD_NAME4

sds_id1 = hdfsd('select',SD_id, sds_index1);
sds_id2 = hdfsd('select',SD_id, sds_index2);
sds_id3 = hdfsd('select',SD_id, sds_index3);
sds_id4 = hdfsd('select',SD_id, sds_index4);
clearvars sds_index1 sds_index2 sds_index3 sds_index4

%Reading filledValue from the data field
fillvalue_index1 = hdfsd('findattr', sds_id1, '_FillValue');
fillvalue_index2 = hdfsd('findattr', sds_id2, '_FillValue');
fillvalue_index3 = hdfsd('findattr', sds_id3, '_FillValue');
fillvalue_index4 = hdfsd('findattr', sds_id4, '_FillValue');
[fillvalue1, status] = hdfsd('readattr',sds_id1, fillvalue_index1);
[fillvalue2, status] = hdfsd('readattr',sds_id2, fillvalue_index2);
[fillvalue3, status] = hdfsd('readattr',sds_id3, fillvalue_index3);
[fillvalue4, status] = hdfsd('readattr',sds_id4, fillvalue_index4);
clearvars fillvalue_index1 fillvalue_index2 fillvalue_index3 fillvalue_index4

%if (fillvalue1 == fillvalue2 && fillvalue2 == fillvalue3 && fillvalue3 == fillvalue4)
%   fillval = fillvalue1; 
%else
   fillval = struct('f1', fillvalue1, 'f2', fillvalue2, 'f3', fillvalue3, 'f4', fillvalue4);
%end

%Reading units from the data field
units_index1 = hdfsd('findattr', sds_id1, 'units');
units_index2 = hdfsd('findattr', sds_id2, 'units');
units_index3 = hdfsd('findattr', sds_id3, 'units');
units_index4 = hdfsd('findattr', sds_id4, 'units');
[units1, status] = hdfsd('readattr',sds_id1, units_index1);
[units2, status] = hdfsd('readattr',sds_id2, units_index2);
[units3, status] = hdfsd('readattr',sds_id3, units_index3);
[units4, status] = hdfsd('readattr',sds_id4, units_index4);
clearvars units_index1 units_index2 units_index3 units_index4
clearvars units1 units2 units3 units4

%Reading scale_factor from the data field
scale_index1 = hdfsd('findattr', sds_id1, 'scale_factor');
scale_index2 = hdfsd('findattr', sds_id2, 'scale_factor');
scale_index3 = hdfsd('findattr', sds_id3, 'scale_factor');
scale_index4 = hdfsd('findattr', sds_id4, 'scale_factor');
[scale1, status] = hdfsd('readattr',sds_id1, scale_index1);
[scale2, status] = hdfsd('readattr',sds_id2, scale_index2);
[scale3, status] = hdfsd('readattr',sds_id3, scale_index3);
[scale4, status] = hdfsd('readattr',sds_id4, scale_index4);
clearvars scale_index1 scale_index2 scale_index3 scale_index4

%if (scale1 == scale2 && scale2 == scale3 && scale3 == scale4)
%   scale = scale1; 
%else
   scale = struct('s1', scale1, 's2', scale2, 's3', scale3, 's4', scale4);
%end

clearvars scale1 scale2 scale3 scale4

%Reading add_offset from the data field
offset_index1 = hdfsd('findattr', sds_id1, 'add_offset');
offset_index2 = hdfsd('findattr', sds_id2, 'add_offset');
offset_index3 = hdfsd('findattr', sds_id3, 'add_offset');
offset_index4 = hdfsd('findattr', sds_id4, 'add_offset');
[offset1, status] = hdfsd('readattr',sds_id1, offset_index1);
[offset2, status] = hdfsd('readattr',sds_id2, offset_index2);
[offset3, status] = hdfsd('readattr',sds_id3, offset_index3);
[offset4, status] = hdfsd('readattr',sds_id4, offset_index4);


%if (offset1 == offset2 && offset2 == offset3 && offset3 == offset4)
%   offset = offset1; 
%else
   offset = struct('o1', offset1, 'o2', offset2, 'o3', offset3, 'o4', offset4);
%end

clearvars offset1 offset2 offset3 offset4 
clearvars offset_index1 offset_index2 offset_index3 offset_index4 
clearvars status

%Terminate access to the corresponding data set
hdfsd('endaccess', sds_id1);
hdfsd('endaccess', sds_id2);
hdfsd('endaccess', sds_id3);
hdfsd('endaccess', sds_id4);
%Closing the File
hdfsd('end', SD_id);
clearvars SD_id sds_id1 sds_id2 sds_id3 sds_id4

