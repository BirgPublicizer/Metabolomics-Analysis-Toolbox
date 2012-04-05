function area=calc_area()
% Return the area under the spectrum specified by getappdata(gca)
%
% It is expected that getappdata(gcf,collections) is a cell array of
% spectral collections objects as would be obtained from load_collections
% or get_collections.
%
% getappdata(gcf, collection_inx) will give the index of the collection
% in which is located the spectrum whose area should be calculated
%
% getappdata(gcf, spectrum_inx) gives the index within the collection
% of the spectrum whose area should be calculated
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% All inputs are ignored, but see the description for arguments passed
% through getappdata.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% area - the area under the spectrum (the sum of all the y values in the
% spectrum)
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
% area=calc_area()
%

collections = getappdata(gcf, 'collections');
c_inx = getappdata(gcf, 'collection_inx');
s_inx = getappdata(gcf, 'spectrum_inx');

collection = collections{c_inx};
area=sum(collection.Y(:,s_inx));
