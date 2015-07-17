clear all;
close all;

mfn = mfilename;
version = 'ver# 2015.07.17';
disp(char(['-> ' mfn ' ' version]));


addpath ..

[files, dirs] = findallfiles( '..', 'r' );
dirs = dirs';
files = files';
expr = '[^:].*MCD43A2\.[^:]+\.hdf$';
[t m] = regexpi(files, expr ,'tokens', 'match', 'lineanchors') ;
isdef = @(x) (~isempty(x));
log = double(cellfun(isdef,m));

index = find(log ==1);

input_f = files(index);

DOY_A2_file_name = input_f{1};
[AQ0_index ,SA0_index, QI1230_index, AAL1_index] = read_mask_from_a2(DOY_A2_file_name);

disp(AAL1_index(1));

disp(char(['<- ' mfn ' ' version]));