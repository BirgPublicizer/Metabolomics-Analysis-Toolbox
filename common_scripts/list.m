function [filenames,pathnames] = list(mydir,chemin)
mylist = dirr(chemin);
filenames = {};
pathnames = {};
[filenames,pathnames] = rlist(mydir,mylist,filenames,pathnames);
