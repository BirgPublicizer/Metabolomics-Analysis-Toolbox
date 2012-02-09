function Out = strorg(n, len, varargin)

% STRORG Get random strings of various length and character compositions from www.random.org (internet connection is needed)
%
%   STRORG(N, LEN) Get N strings. The length of each string is LEN. 
%                  N and LEN should be a scalar positive integers and N <= 10,000 and LEN <= 20.
%   
%   STRORG(...,Optionals) Supply a maximum of 3 optional flags.
%       - 'noDigits'     : (0-9) are not allowed to occur in the strings
%       - 'noUpperCase'  : (A-Z) are not allowed to occur in the strings
%       - 'noLowerCase'  : (a-z) are not allowed to occur in the strings
%       - 'unique'       : only unique string are allowed to occur. If the N exceeds the
%                          maximum number of unique string STRORG throws an error.
%
%   STRORG  Check your quota 
%   
%   Note: each IP address has a base quota of 1,000,000 bits. If your quota is negative the service won't
%   work. Every day, shortly after midnight UTC, all quotas with less than 1,000,000 bits receive a free top-up
%   of 200,000 bits (for more detail see RANDOM HTTP API link below).
%   Extremes of the RANGE are included.
%
% Examples:
%   - myStrs = strorg(10,5);             % get 10 strings with length of 5
%   - myStrs = strorg(10,5,'noD');       % exclude digits
%   - myStrs = strorg(10,5,'noU','noL'); % only digits
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/27942','-browser')">FEX randorg page</a>
% - <a href="matlab: web('http://www.random.org/','-browser')">www.random.org</a>
% - <a href="matlab: web('http://www.random.org/clients/http','-browser')">RANDOM HTTP API</a>
%
% See also: RANDORG, SEQORG, URLREAD

% Author: Oleg Komarov (oleg.komarov@hotmail.it) 
% Tested on R14SP3 (7.1) and on R2009b
% 21 jun 2010 - Created

% Ninputs
error(nargchk(0,5,nargin))
if nargin == 1
    error('strorg:nInputs','Not enough input arguments');
end

% Print quota
if nargin == 0
    Out = sscanf(urlread('http://www.random.org/quota/?format=plain'),'%d');
    return
end

% n
if ~isnumeric(n) || rem(n,1) ~= 0 || n < 1 || n > 1e4
    error('strorg:formatN','N should be a scalar positive integer less than 10,000.');
end

% Len
if ~isnumeric(len) || rem(len,1) ~= 0 || len < 1 || len > 20
    error('strorg:formatLen','LEN should be a scalar positive integer less than 20.');
end

% Optionals
if ~iscellstr(varargin)
    error('strorg:formatOptionals','OPTIONALS should be strings')
end
% Retrieve optional flags
nOpt = numel(varargin);
noD = 'on'; noU = 'on'; noL = 'on'; noUn = 'on'; arg = 1; allStr = 62;
while arg <= nOpt 
    if strfind('noDigits',varargin{arg});
        noD = 'off'; allStr = allStr - 10;
    elseif strfind('noUpperCase',varargin{arg});
        noU = 'off'; allStr = allStr - 26;
    elseif strfind('noLowerCase',varargin{arg});
        noL = 'off'; allStr = allStr - 26;
    elseif strfind('unique',varargin{arg});
        noUn = 'off';
    else
        error('strorg:formatOptionals','The optional flag "%s" is not allowed',varargin{arg})
    end
    arg = arg + 1;
end

% All character sets excluded?
if all(strcmp('off',{noD,noU,noL}))
    error('strorg:noCharSet','At least one of the digits or alphabet sets must be allowed')
end

% Unique strings
if strcmp(noUn,'on') && allStr*len < n
    error('strorg:unStr','The number of strings requested exceeds the number of possible unique strings (%d)',allStr*len)
end

% Retrieve strings
[Out, noERR] = urlread(['http://www.random.org/strings/?num=' num2str(n) '&len='...
               num2str(len) '&digits=' noD '&upperalpha=' noU '&loweralpha='...
               noL '&unique=' noUn '&format=plain&rnd=new']);

% IF errors
if noERR 
    Out = reshape(Out(~isspace(Out)),n,len);
elseif strorg <= 0
    warning('warnStrorg:quotaLimit','your quota is insufficient to continue (%d)', strorg);
    return
    % ...unexpected error
else 
    error('strorg:unexErr','An unexpected error has occured. Try again.'); 
end 

end

