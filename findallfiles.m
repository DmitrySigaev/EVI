%Creates lists of files and dirs from init directory
% inputs: init - directory of search
%         type - type of serch. ( r - recursive search)

 function [files, dirs] = findallfiles( init, type )
    y = dir(init); 
    t = {y(:).isdir};
    isfile = @(x) (x == 0);
    % full_file = @(x) (fullfile(x));
    logical_index = cellfun(isfile,t);
    file_index = find(logical_index); 
    dir_index = find(logical_index == 0); 
    files = {y(file_index).name}; 
    count = size(files,2);
    if (type == 'r')
        for i = 1:count
        files{1,i} = fullfile(init, files{1,i});
        end
    end
    alldirs = {y(dir_index).name};
    is_child_dir = @(x) ((strcmp(x, '.') ||  strcmp(x, '..')) == 0);
    logical_child_dir = cellfun(is_child_dir, alldirs);
    child_dir_index = find(logical_child_dir); 
    dirs = alldirs(child_dir_index); 
    if (type == 'r')
        m = size(dirs,2);
        files_3 = files;
        dirs_3 = dirs;
        for t = 1:m
            dirs{1,t}  = fullfile(init, dirs{1,t});
            st = dirs{1,t};
            [files_2, dirs_2] = findallfiles(st, type);
            files_3 = [files files_2];
            dirs_3 = [dirs dirs_2];
            files = files_3;
            dirs = dirs_3;
        end
        files = files_3;
        dirs = dirs_3;
    end
 end