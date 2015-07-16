clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.07.16';
disp(char(['-> ' mfn ' ' version]));


addpath ..

[files, dirs] = findallfiles( '..', 'r' );
dirs = dirs';
files = files';
expr = '[^:].*MCD43A4\.[^:]+\.hdf$';
[t m] = regexpi(files, expr ,'tokens', 'match', 'lineanchors') ;
isdef = @(x) (~isempty(x));
log = double(cellfun(isdef,m));

index = find(log ==1);

input_f = files(index);

DOY_A4_file_name = input_f{1};
[red_d, nir_d, blue_d, green_d, scale, offset, fillval] = read_data_from_a4(DOY_A4_file_name);

disp(scale);

disp(char(['<- ' mfn ' ' version]));