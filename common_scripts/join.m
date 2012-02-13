function str = join(ary,dlm)
str = '';
for i = 1:length(ary)
    if iscell(ary)
        if i == 1        
            str = ary{i};
        else
            str = [str,dlm,ary{i}];
        end
    else
        if i == 1        
            str = num2str(ary(i));
        else
            str = [str,dlm,num2str(ary(i))];
        end        
    end
end