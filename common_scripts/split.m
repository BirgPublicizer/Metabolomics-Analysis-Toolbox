function fields = split(header_string,dlm)
fields = regexp(header_string,dlm,'split');
% fields = {};
% tab = sprintf('\t');
% [T,R] = strtok(header_string,dlm);
% if isempty(T) && isempty(R)
%     return;
% end
% fields{end+1} = T;
% while ~isempty(R)
%     [T,R] = strtok(R,dlm);
%     fields{end+1} = T;
%     if strcmp(R,tab) % If the remainder is exactly a tab
%         fields{end+1} = '';
%     end
% end
