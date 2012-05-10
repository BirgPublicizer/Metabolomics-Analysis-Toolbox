function [x,Y,labels] = combine_collections(collections)
% First check to see if all of the collections have exactly the same x
% values
x = collections{1}.x;
xwidth = x(1)-x(2);
Y = collections{1}.Y;
labels = ones(1,collections{1}.num_samples);
try
    for c = 2:length(collections)
        if sum(abs(x-collections{c}.x)) == 0
            Y = [Y,collections{c}.Y];
            labels = [labels,ones(1,collections{c}.num_samples)+c-1];
        else
            error_x_values_do_not_match
        end
    end
    return
catch ME
    Y = collections{1}.Y;
end
for c = 2:length(collections)
    test_xwidth = collections{c}.x(1)-collections{c}.x(2);
    if test_xwidth ~= xwidth
        errRecord = MException('combine_collections', ...
            'Digital resolution is different between collections');
        throw(errRecord);
    end
    new_x = collections{c}.x;
    new_Y = collections{c}.Y;
    inxs = [];
    new_inxs = [];
    start = 1;
    for i = 1:length(x)
        for j = start:length(new_x)
            if new_x(j) < x(i) % Past
                start = j;
                break;
            end
            if x(i) == new_x(j)
                inxs(end+1) = i;
                new_inxs(end+1) = j;
                break;
            end
        end
    end
    x = x(inxs);
    Y = Y(inxs,:);
    new_Y = new_Y(new_inxs,:);
    Y = [Y,new_Y];
    labels = [labels,ones(1,collections{c}.num_samples)+c-1];
    
%     if new_x(1) > x(1)
%         start_inx = 1;
%         while new_x(start_inx) ~= x(1)
%             start_inx = start_inx + 1;
%         end
%         if start_inx > 1
%             new_x = new_x(start_inx:end);
%             new_Y = new_Y(start_inx:end,:);
%         end
%     elseif new_x(1) < x(1)
%         chop_inx = 1;
%         while new_x(1) ~= x(chop_inx)
%             chop_inx = chop_inx + 1;
%         end
%         if chop_inx > 1 % Adjust x and Y
%             x = x(chop_inx:end);
%             Y = Y(chop_inx:end,:);
%         end
%     end
%     if length(new_x) < length(x) % Adjust x and Y        
%         x = x(1:length(new_x));
%         Y = Y(1:length(new_x),:);
%     elseif length(new_x) > length(x)
%         new_x = new_x(1:length(x));
%         new_Y = new_Y(1:length(x),:);
%     end
end