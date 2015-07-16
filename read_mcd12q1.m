% Land Cover Type Yearly L3 Global 500 m SIN Grid
% MCD12Q1
% Short Name: MCD12Q1 
% Sample image of MCD12Q1	
% This image represents the 2005 land cover-types for the western
% United States (h08/v05). 
% This first SDS layer depicts the IGBP classification. 
% The predominant light-brown color represents open shrublands. 
% Varying shades of green portray evergreen and deciduous forests. 
% Sienna shades are areas of woody savannas and savannas.
% Closed shrublands are characterized in thistle, and yellow indicates
% croplands. Red represents urban and built-up areas, while coral indicates
% barren and sparse vegetation.

%The MODIS Land Cover Type product (Short Name: MCD12Q1) provides data 
%characterizing five global land cover classification systems.
% In addition, it provides a land-cover type assessment, and quality-control
% information.

%- See more at: https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mcd12q1#sthash.g8mAkdN0.dpuf

%Reading mcd12q1 file
function CroplandsIndex = read_mcd12q1(FILE_NAME)

file_id = hdfgd('open', FILE_NAME, 'rdonly');

%Reading Data from a Data Field
GRID_NAME='MOD12Q1';
grid_id = hdfgd('attach', file_id, GRID_NAME);
clearvars GRID_NAME

DATAFIELD_NAME1='Land_Cover_Type_1'; %Land_Cover_Type_1 

[data1, fail1] = hdfgd('readfield', grid_id, DATAFIELD_NAME1, [], [], []);
clearvars fail1 

%Convert M-D data to 2-D data
data_1=data1;

%Convert the data to double type for plot
data_1=double(data_1);

%Transpose the data to match the map projection
data_1=data_1';

%Remove items from workspace, freeing up system memory
%Clear variables from memory
clearvars data1 

CroplandsIndex = find(data_1 == 12);  %Croplands class

clearvars data_1

%Detaching from the Grid Object
hdfgd('detach', grid_id);
%Closing the File
hdfgd('close', file_id);
clearvars file_id grid_id
