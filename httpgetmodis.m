clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.08.05';
disp(char(['-> ' mfn ' ' version]));

%str = urlread('http://e4ftl01.cr.usgs.gov//MODIS_Composites/MOTA/MCD43A4.005/');
%output folder;
slash_chr = '\\';
path_chr  = 'D:';
output_f = [path_chr slash_chr 'InputData'];
if isdir(output_f)
%parse data_url_script_2006-2007.txt 
%% using fread
fid = fopen('data_url_script_2006-2007.txt');

expr1  = 'http://e4ftl01.cr.usgs.gov//MODIS_Composites/MOTA/(MCD43A4).005/([0-9]{4}).([0-9]{2}).([0-9]{2})/MCD43A4.A[0-9]{4}([0-9]{3}).([^:]{6}).[^:]+.hdf$';
expr2  = 'http://e4ftl01.cr.usgs.gov//MODIS_Composites/MOTA/MCD43A4.005/[0-9]{4}.[0-9]{2}.[0-9]{2}/(MCD43A4.A[0-9]{4}[0-9]{3}.[^:]{6}.[^:]+.hdf$)';

all_f = fread(fid, '*char')';

[t_years_days1 m_files_name1] = regexpi(all_f, expr1 ,'tokens', 'match', 'lineanchors') ;  
[t_years_days2 m_files_name2] = regexpi(all_f, expr2 ,'tokens', 'match', 'lineanchors') ;  

g_str = {};
for i = 1:length(t_years_days1)
    
    g_str(i).url = m_files_name1{1,i};
    g_str(i).shortname = t_years_days2{1,i}{1,1};
    g_str(i).type = t_years_days1{1,i}{1,1};
    g_str(i).year = t_years_days1{1,i}{1,2};
    g_str(i).month = t_years_days1{1,i}{1,3};
    g_str(i).day = t_years_days1{1,i}{1,4};
    g_str(i).DOY = t_years_days1{1,i}{1,5};
    g_str(i).tile = t_years_days1{1,i}{1,6};


    disp(['url: ' g_str(i).url]);
    disp(['file(shortname): ' g_str(i).shortname]);
    disp(['type: ' g_str(i).type]);
    disp(['year: ' g_str(i).year]);
    disp(['month: ', g_str(i).month]);
    disp(['day: ', g_str(i).day]);
    disp(['DOY: ', g_str(i).DOY]);
    disp(['tile: ', g_str(i).tile]);
    newfr = [output_f slash_chr g_str(i).year];
    if ~isdir(newfr)
        mkdir(newfr);
    end
    newfr = [output_f slash_chr g_str(i).year slash_chr g_str(i).type];
    if ~isdir(newfr)
        mkdir(newfr);
    end
    newfr = [output_f slash_chr g_str(i).year slash_chr g_str(i).type slash_chr g_str(i).DOY];
    if ~isdir(newfr)
        mkdir(newfr);
    end
    g_str(i).file = [newfr slash_chr g_str(i).shortname];
    [f, status] = urlwrite(g_str(i).url, g_str(i).file);
end
fclose(fid);

end % end of isdir(output_f);


%% line by line
if 0
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
    %urlwrite()
    tline = fgetl(fid);
end


fclose(fid);


end % 0
disp(char(['<- ' mfn ' ' version]));