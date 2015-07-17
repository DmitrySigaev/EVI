% BRDF-Albedo Quality 16-Day L3 Global 500m
% The MODerate-resolution Imaging Spectroradiometer (MODIS) BRDF/Albedo Quality 
% product (MCD43A2) describes the overall condition of the other BRDF and Albedo
% products. The MCD43A2 product contains 16 days of data at 500-meter spatial
% resolution provided in a level-3 gridded data set in Sinusoidal projection,
% and includes albedo quality, snow conditions, ancillary, and inversion
% information.
% Both Terra and Aqua data are used to generate this product, providing the
% highest probability for quality input data and designating it as an MCD,
% meaning Combined, product.
% Version-5 MODIS BRDF and Albedo products have attained Validation Stage 3.

% - See more at: https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mcd43a2#sthash.cH9eez5c.dpuf

% MCD43A2 reading

function [AQ0_in, SA0_in, QI1230_in, AAL1_in] = read_mask_from_a2(FILE_NAME)

file_id = hdfgd('open', FILE_NAME, 'rdonly');

%Reading Data from a Data Field
GRID_NAME='MOD_Grid_BRDF';
grid_id = hdfgd('attach', file_id, GRID_NAME);
clearvars GRID_NAME

DATAFIELD_NAME1='BRDF_Albedo_Quality'; %mcdca2      -- BRDF_Albedo_Quality
DATAFIELD_NAME2='Snow_BRDF_Albedo'; %mcdca2          -- Snow_BRDF_Albedo
DATAFIELD_NAME3='BRDF_Albedo_Ancillary'; %mcdca2     -- BRDF_Albedo_Ancillary
DATAFIELD_NAME4='BRDF_Albedo_Band_Quality'; %mcdca2  -- BRDF_Albedo_Band_Quality

[data1, fail1] = hdfgd('readfield', grid_id, DATAFIELD_NAME1, [], [], []);
if(fail1)
    disp(['Can not read ', DATAFIELD_NAME1, ' field in ', FILE_NAME, 'file']);
end   
[data2, fail2] = hdfgd('readfield', grid_id, DATAFIELD_NAME2, [], [], []);
if(fail2)
    disp(['Can not read ', DATAFIELD_NAME2, ' field in ', FILE_NAME, 'file']);
end   
[data3, fail3] = hdfgd('readfield', grid_id, DATAFIELD_NAME3, [], [], []);
if(fail3)
    disp(['Can not read ', DATAFIELD_NAME3, ' field in ', FILE_NAME, 'file']);
end   
[data4, fail4] = hdfgd('readfield', grid_id, DATAFIELD_NAME4, [], [], []);
if(fail4)
    disp(['Can not read ', DATAFIELD_NAME4, ' field in ', FILE_NAME, 'file']);
end   
clearvars fail1 fail2 fail3 fail4

data1=data1'; %AQ0_in
data2=data2'; %SA0_in [SA1_in MUST NOT BE PASSED] 
data3=data3'; %
data4=data4'; %QI0_in -- worth to include to improve results
data5=(bitand(data3, uint16(240))./16); % data5 contains BRDF_Albedo_Ancillary unpacked value 04-07

% if data5 == 0 then Shallow ocean 
% if data5 == 1 then Land (Nothing else but land) 
% if data5 == 2 then Ocean and lake shorelines 
% if data5 == 3 then Shallow inland water 
% if data5 == 4 then Ephemeral water 
% if data5 == 5 then Deep inland water 
% if data5 == 6 then Moderate or continental ocean 
% if data5 == 7 then Deep ocean 

data6 = (bitand(data4, uint32(15))); % data4 contains BRDFAlbedo Inversion Flags unpacked values (00-03)
data7 = (bitand(data4, uint32(240))./16); % data4 contains BRDFAlbedo Inversion Flags unpacked values (04-07)
data8 = (bitand(data4, uint32(3840))./256); % data4 contains BRDFAlbedo Inversion Flags unpacked values (08-11)

% if data6 == 0 best quality inversion 00-03 Band1
% if data7 == 0 best quality inversion 04-07 Band2
% if data8 == 0 best quality inversion 08-11 Band3

% Creat Mask
AQ0_in = find(data1 == 0); % BRDF_Albedo_Quality = 0
SA0_in = find(data2 == 0); % Snow_BRDF_Albedo = 0
%SA1_in = find(data2 == 1); % Snow_BRDF_Albedo = 1 ELIMINATE -- THIS SHOULD
%NOT PASS
%we can try to include here what i mentioned in my last mail to you:
%if a pixel has a value of SAO_in == 0 but is surrounded by pixels with
%SA1_in = 1, than we can consider also THAT pixel havong value SA1_in =1;
%that is we think it ia all SNOW and therefore we do not pass the value.
AAL1_in = find(data5 == 1); % BRDF_Albedo_Ancillary unpacked value 04-07 equal to 1 (land ) or  % if data5 == 1 then Land (Nothing else but land) 

QI10_in  = find(data6 == 0); % Best Quality Iversion for Band 1 
QI20_in  = find(data7 == 0); % Best Quality Iversion for Band 2 
QI30_in  = find(data8 == 0); % Best Quality Iversion for Band 3 
QI120_in = intersect(QI10_in, QI20_in); 
QI1230_in = intersect(QI120_in, QI30_in); % Best Quality Iversion for Band 1, Band2 and Band3 together
clearvars QI10_in QI20_in QI30_in QI120_in

%Transpose the data to match the map projection
%Remove items from workspace, freeing up system memory
%Clear variables from memory
clearvars data1 data2 data3 data4 data5 data6 data7 data8



%Detaching from the Grid Object
hdfgd('detach', grid_id);
%Closing the File
hdfgd('close', file_id);
clearvars file_id grid_id
