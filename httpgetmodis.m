clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.07.29';
disp(char(['-> ' mfn ' ' version]));

%str = urlread('http://e4ftl01.cr.usgs.gov//MODIS_Composites/MOTA/MCD43A4.005/');

%parse data_url_script_2006-2007.txt 
%% using fread
fid = fopen('data_url_script_2006-2007.txt');

expr  = 'http://e4ftl01.cr.usgs.gov//MODIS_Composites/MOTA/MCD43A4.005/([0-9]{4}).([0-9]{2}).([0-9]{2})/MCD43A4.A[0-9]{4}([0-9]{3}).([^:]{6}).[^:]+.hdf$';

all_f = fread(fid, '*char')';

[t_years_days m_files_name] = regexpi(all_f, expr ,'tokens', 'match', 'lineanchors') ;  

for i = 1:length(t_years_days)
    disp(['file: ' m_files_name{1,i}]);
    disp(['year: ' t_years_days{1,i}{1,1}]);
    disp(['month: ', t_years_days{1,i}{1,2}]);
    disp(['day: ', t_years_days{1,i}{1,3}]);
    disp(['DOY: ', t_years_days{1,i}{1,4}]);
    disp(['tile: ', t_years_days{1,i}{1,5}]);
end

fclose(fid);

%% line by line
fid = fopen('data_url_script_2006-2007.txt');

expr  = 'http://e4ftl01.cr.usgs.gov//MODIS_Composites/MOTA/MCD43A4.005/([0-9]{4}).([0-9]{2}).([0-9]{2})/MCD43A4.A[0-9]{4}([0-9]{3}).([^:]{6}).[^:]+.hdf$';


tline = fgetl(fid);
disp('Reading...');
while ischar(tline)
    [t_years_days m_files_name] = regexpi(tline, expr ,'tokens', 'match', 'lineanchors') ;  
    disp(['file: ' m_files_name{1,1}]);
    disp(['year: ' t_years_days{1,1}{1,1}]);
    disp(['month: ', t_years_days{1,1}{1,2}]);
    disp(['day: ', t_years_days{1,1}{1,3}]);
    disp(['DOY: ', t_years_days{1,1}{1,4}]);
    disp(['tile: ', t_years_days{1,1}{1,5}]);
    tline = fgetl(fid);
end


fclose(fid);

%urlwrite()

disp(char(['<- ' mfn ' ' version]));