function [filenames,pathnames] = rlist(mydir,mylist,filenames,pathnames)
for i = 1:length(mylist)
    if ~isstruct(mylist(i).isdir) && mylist(i).isdir == 0
        if strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64')
            pathnames{end+1} = [mydir,'\'];
        else
            pathnames{end+1} = [mydir,'/'];
        end
        filenames{end+1} = mylist(i).name;
    else
        if strcmp(computer,'PCWIN') || strcmp(computer,'PCWIN64')
            [filenames,pathnames] = rlist([mydir,'\',mylist(i).name],mylist(i).isdir,filenames,pathnames);
        else
            [filenames,pathnames] = rlist([mydir,'/',mylist(i).name],mylist(i).isdir,filenames,pathnames);
        end
    end
end
