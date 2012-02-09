function reopen(disk_file_id)
addpath('../common_scripts');

username = [];
password = [];
if isempty(username) || isempty(password)
    [username,password] = logindlg;
end

file = tempname;

urlwrite(sprintf('http://birg.cs.wright.edu/omics_analysis/saved_files/download/%d',disk_file_id), [file,'.fig'], 'GET', ... 
        {'name',username,'password',password})

open([file,'.fig']);