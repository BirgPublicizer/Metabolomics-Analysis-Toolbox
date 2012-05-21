function appended = append_to_processing_log( collections, text )
% Appends text to the end of all processing logs in collections.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - a cell array of spectral collections. Each spectral
%               collection is a struct of spectra. This is the format
%               of the return value of load_collections.m in
%               common_scripts.
%
% text        - a string. The text to append
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% appended - the collections after their processing logs have been appended
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> appended = append_to_processing_log(collections, 'This text is appended.')
%
% If collections{1}.processing_log was 'Old processing log'. Then
% appended{1}.processing_log reads 'Old processing logThis text is
% appended.'
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer 2012 (eric_moyer@yahoo.com)

appended = collections;
for c=1:length(appended)
    appended{c}.processing_log = [appended{c}.processing_log text];
end

end