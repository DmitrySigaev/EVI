clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.07.22';
disp(char(['-> ' mfn ' ' version]));


addpath ..

[files, dirs] = findallfiles( '..', 'r' );
dirs = dirs';
files = files';
expr = '[^:].*MYD11A2\.[^:]+\.hdf$';
[t m] = regexpi(files, expr ,'tokens', 'match', 'lineanchors') ;
isdef = @(x) (~isempty(x));
log = double(cellfun(isdef,m));

index = find(log ==1);

input_f = files(index);

MYD11_A2_file_name = input_f{1};

[LST, lst_scale, lst_offset, lst_fillval] = read_myd11_t(MYD11_A2_file_name);

disp(lst_scale);

disp(char(['<- ' mfn ' ' version]));