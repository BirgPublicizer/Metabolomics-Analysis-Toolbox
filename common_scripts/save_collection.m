function file = save_collection(fname_or_output_dir,suffix_or_collection, collection_if_suffix)
% Saves the collection to either a specified filename or a generated one
%
% 
% -------------------------------------------------------------------------
% Syntax:
% -------------------------------------------------------------------------
% save_collection(filename, collection)
%
% save_collection(output_dir, suffix, collection)
%
% -------------------------------------------------------------------------
% Input arguments:
% -------------------------------------------------------------------------
%
% filename    The filename to which to save the colleciton
%             A string.
%
% collection  The collection to save.  A structure.
%
% output_dir  The directory to save to (if generating the filename).  A
%             string
%
% suffix      The part of the generated filename after collection_####.  A
%             string
%
% -------------------------------------------------------------------------
% Output arguments:
% -------------------------------------------------------------------------
%
% file   The filename to which the collection was written - a string
%
% -------------------------------------------------------------------------
% Description
% -------------------------------------------------------------------------
%
% The collection will be written as a text file, overwriting any file with
% the same name.
%
% save_collection(filename, collection)  The collection will be written to
% the given filename
% 
% save_collection(output_dir, suffix, collection) The collection will be
% written to a filename of the form collection_xxxyyy.txt  in the
% directory output_dir.  xxx will be replaced with the collection_id field.
% yyy will be replaced with the contents of suffix.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% save_collection('/foo/bar/my_file.txt', col);
%
%   Will save col to "/foo/bar/my_file.txt".
%
% save_collection('/foo/bar','_test', col);
%
%   Will save col to "/foo/bar/collection_1_test.txt" if col.collection_id
%   is 1.

if nargin == 3
    collection = collection_if_suffix;
    file = [fullfile(fname_or_output_dir,'collection_'), ...
        num2str(collection.collection_id),suffix_or_collection,'.txt'];
else
    collection = suffix_or_collection;
    file = fname_or_output_dir;
end

fid = fopen(file,'w');
for i = 1:length(collection.input_names)
    name = regexprep(collection.input_names{i},' ','_');
    field_name = lower(name);
    if i > 1
        fprintf(fid,'\n');
    end
    fprintf(fid,collection.input_names{i});
    if iscell(collection.(field_name))
        for j = 1:length(collection.(field_name))
            if ischar(collection.(field_name){j})
                fprintf(fid,'\t%s',collection.(field_name){j});
            elseif int8(collection.(field_name){j}) == collection.(field_name){j} % Integer
                fprintf(fid,'\t%d',collection.(field_name){j});
            else
                fprintf(fid,'\t%f',collection.(field_name){j});
            end
        end
    elseif ischar(collection.(field_name))
        fprintf(fid,'\t%s',collection.(field_name));
    elseif length(collection.(field_name)) > 1 % Array
        for j = 1:length(collection.(field_name))
            if ischar(collection.(field_name)(j))
                fprintf(fid,'\t%s',collection.(field_name)(j));
            elseif int32(collection.(field_name)(j)) == collection.(field_name)(j) % Integer
                fprintf(fid,'\t%d',collection.(field_name)(j));
            else
                fprintf(fid,'\t%f',collection.(field_name)(j));
            end
        end
    elseif int32(collection.(field_name)) == collection.(field_name) % Integer
        fprintf(fid,'\t%d',collection.(field_name));
    else
        fprintf(fid,'\t%f',collection.(field_name));
    end
end
fprintf(fid,'\nX');
for i = 1:collection.num_samples
    fprintf(fid,'\tY%d',i);
end
for j = 1:length(collection.x)
    if iscell(collection.x)
        if isfloat(collection.x{j})
            fprintf(fid,'\n%f',collection.x{j});
        else
            fprintf(fid,'\n%s',collection.x{j});
        end
    else
        fprintf(fid,'\n%f',collection.x(j));
    end
    for i = 1:collection.num_samples
        fprintf(fid,'\t%f',collection.Y(j,i));
    end
end
fclose(fid);