function value = get_field(collection,field,inx)
if iscell(collection.(field))
    value = collection.(field){inx};
else
    value = collection.(field)(inx);
end