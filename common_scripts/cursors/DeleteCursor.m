function DeleteCursor(varargin)
% DeleteCursor deletes a cursor created by CreateCursor
%
% Examples:
% scDeleteCursor(CursorNumber)
% scDeleteCursor(fhandle, CursorNumber)
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 01/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

if nargin==1
    fhandle=gcf;
    CursorNumber=varargin{1};
else
    fhandle=varargin{1};
    CursorNumber=varargin{2};
end
    
% Retrieve cursor info
Cursors=getappdata(fhandle, 'VerticalCursors');
% Delete associated lines and text
delete(Cursors{CursorNumber}.Handles);
% Empty the cell array element - can be re-used
Cursors{CursorNumber}={};
% Trim if last cell is empty
if isempty(Cursors{end})
    Cursors{end}=[];
end
% Update in application data area
setappdata(fhandle, 'VerticalCursors', Cursors);