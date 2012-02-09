function Out = seqorg(range, varargin)

% SEQORG Get sequence of randomly arranged integers from www.random.org (internet connection is needed)
%
%   SEQORG(RANGE) Supply the RANGE of the sequence as [min, max] where min < max and 
%                 max-min <= 10,000; min and max should be scalar integers in the [-1e9,1e9] interval. 
%   
%   SEQORG(...,  M, N,... ) 
%   SEQORG(..., [M, N,...]) Specify the size of the output as requested by RESHAPE
%                            A column vector of 'n' elements is the DEFAULT output (if empty or not supplied).
%
%   SEQORG  Check your quota
%   
%   Note: each IP address has a base quota of 1,000,000 bits. If your quota is negative the service won't
%   work. Every day, shortly after midnight UTC, all quotas with less than 1,000,000 bits receive a free top-up
%   of 200,000 bits (for more detail see RANDOM HTTP API link below).
%   Extremes of the RANGE are included.
%
% Examples:
%   - mySeq = seqorg([-30,89]);          % get sequence of 120 integers in the [-20,90] interval
%   - mySeq = seqorg([-30,89],[],30,20); % get sequence and reshape it into an m by 30 by 20 matrix
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/27942','-browser')">FEX randorg page</a>
% - <a href="matlab: web('http://www.random.org/','-browser')">www.random.org</a>
% - <a href="matlab: web('http://www.random.org/clients/http','-browser')">RANDOM HTTP API</a>
%
% See also: RANDORG, RANDI, URLREAD, RESHAPE, SSCANF

% Author: Oleg Komarov (oleg.komarov@hotmail.it) 
% Tested on R14SP3 (7.1) and on R2009b
% 21 jun 2010 - Created

% Print quota
if nargin == 0
    Out = sscanf(urlread('http://www.random.org/quota/?format=plain'),'%d');
    return
end

% range
if isnumeric(range) && numel(range) == 2 && all(rem(range,1) == 0) && range(2) - range(1) <= 1e4 
    if any(range) < -1e9 || any(range > 1e9)
       error('seqorg:boundsRange','The RANGE should be in the [-1e9, 1e9] interval.');
    elseif range(1) >= range(2) 
        error('seqorg:minmax','The first value of RANGE should be smaller than the second; min < max');
    end
else
    error('seqorg:formatRange',['RANGE should be [min, max] where:'...
          '\n\t - min < max;'...
          '\n\t - max-min +1 <= 10,000 integers;'...
          '\n\t - both are scalar integers in the [-1e9, 1e9] interval.']);    
end

% Output size
if ~isempty(varargin) && ~isvector(varargin) && ~all(cellfun(@isnumeric,varargin)) && ~all(@isvector,varargin)
    error('seqorg:sizeOut','The size of the output should be supplied as documented by RESHAPE');
end

% Retrieve sequence
[Out, noERR] = urlread(['http://www.random.org/sequences/?&min=' num2str(range(1)) '&max=' num2str(range(2)) '&col=1&format=plain&rnd=new']);

% IF errors
if noERR 
    Out = sscanf(Out,'%d\n');
elseif seqorg <= 0
	warning('warnSeqorg:quotaLimit','your quota is insufficient to continue (%d)', seqorg);
    return
% ...unexpected error
else 
    error('seqorg:unexErr','An unexpected error has occured. Try again.'); 
end 

% Reshape 
if ~isempty(varargin)
    Out = reshape(Out,varargin{:});
end

end
