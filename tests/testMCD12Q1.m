clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.07.16';
disp(char(['-> ' mfn ' ' version]));


addpath ..

[files, dirs] = findallfiles( '..', 'r' );
dirs = dirs';
files = files';
expr = '[^:].*MCD12Q1\.[^:]+\.hdf$';
[t m] = regexpi(files, expr ,'tokens', 'match', 'lineanchors') ;
isdef = @(x) (~isempty(x));
log = double(cellfun(isdef,m));

index = find(log ==1);
input_f = files(index);

MCD12Q1_file_name = input_f{1};


index = read_mcd12q1(MCD12Q1_file_name);

disp(index(1));

disp(char(['<- ' mfn ' ' version]));