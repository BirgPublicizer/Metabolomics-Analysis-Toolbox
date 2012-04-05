function [ mm_no_deleted ] = remove_deleted_bins_from_metabmap( metabmap )
% Returns a copy of metabmap without the bins marked as deleted
%
% Metabmap is an array of CompoundBin objects.  Some may have the 
% was_deleted field set to true.  mm_no_deleted contains the same list in
% the same order but without the deleted bins.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% metabmap  An array of CompoundBin objects whose deleted elemets are 
%           to be removed
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% mm_no_deleted  Same order and contents as metabmap except that the
%                deleted bins have been removed.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
%
% >> header=['"Bin ID","Deleted","Compound ID",'...
%    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
%    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
%    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
% >> alpha_keto=['10,,7,"alpha-Ketoglutarate","X",2.472,2.430,"t",3,,'...
%    '"g CH2/CH2",,"X","Chemonx/Lindon/Measured","1H",'];
% >> succ=['11,X,25,"succinate","X",2.425,2.405,"s",1,,"CH",254,"X",'...
%    '"Chemonx/Lindon/Measured","1H"'];
% >> nacet=['12,,26,"N-Acetylglutamine","X",2.055,2.025,"s",1,,"CH3",6029,'...
%    '"X","Chenomx/Lindon","1H",'];
%
% >> starting_map = [CompoundBin(header, nacet) ...
%    CompoundBin(header, succ) ...
%    CompoundBin(header, alpha_keto) ...
%    ];
%
% map = remove_deleted_bins_from_metabmap(starting_map);


% Count the bins to remain
num_good_bins = 0;
for index=1:length(metabmap)
    b = metabmap(index);
    if ~b.was_deleted
        num_good_bins = num_good_bins+1;
    end
end

% Allocate space for non-deleted bins
mm_no_deleted = metabmap;
mm_no_deleted(num_good_bins+1:length(metabmap))=[];

% Copy non-deleted bins
out_idx = 1;
for in_index=1:length(metabmap);
    b = metabmap(in_index);
    if ~b.was_deleted
        mm_no_deleted(out_idx) = b;
        out_idx = out_idx + 1;
    end
end
assert(out_idx == num_good_bins + 1);


