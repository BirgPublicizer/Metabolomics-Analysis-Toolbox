function Out = randorg(n, range, varargin)

% RANDORG Get random integers from www.random.org (internet connection is needed)
%
%   RANDORG(N) Get N random integers. N should be a scalar positive integer.
%   
%   RANDORG(...,RANGE) Get integers in the RANGE supplied as [min, max], where min < max;
%                      min and max should be scalar integers in the [-1e9,1e9] interval 
%                      To preserve the quota the default RANGE is set to [0,1000] (if empty or not supplied). 
%   
%   RANDORG(...,  M, N,... ) 
%   RANDORG(..., [M, N,...]) Specify the size of the output as requested by RESHAPE
%                            A column vector of 'n' elements is the DEFAULT output (if empty or not supplied).
%
%   RANDORG  Check your quota
%   
%   Note: each IP address has a base quota of 1,000,000 bits. If your quota is negative the service won't
%   work. Every day, shortly after midnight UTC, all quotas with less than 1,000,000 bits receive a free top-up
%   of 200,000 bits (for more detail see RANDOM HTTP API link below).
%
% Examples:
%   - myRandNums = randorg(100);            % get 100 random numbers in a row vector
%   - myRandNums = randorg(100,[-10,100]);  % get 100 random numbers in the [-10,100] interval
%   - myRandNums = randorg(100,[],[10,10]); % get 100 random numbers and reshape in a 10 by 10 matrix
%   - myRandNums = randorg(100,[],[],10]);  % get 100 random numbers and reshape in a m by 10 matrix
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/27942','-browser')">FEX randorg page</a>
% - <a href="matlab: web('http://www.random.org/','-browser')">www.random.org</a>
% - <a href="matlab: web('http://www.random.org/clients/http','-browser')">RANDOM HTTP API</a>
%
% See also: RANDI, URLREAD, RESHAPE, SSCANF

% Author: Oleg Komarov (oleg.komarov@hotmail.it) 
% Tested on R14SP3 (7.1) and on R2009b
% 17 jun 2010 - Created
% 21 jun 2010 - Reduced default range to preserve the quota. Edited description.
% 27 jul 2011 - Made no-quota the result of trying to check the quota on a
%               machine that cannot access the internet

% Print quota
if nargin == 0
    [quota_string, success] = ...
        urlread('http://www.random.org/quota/?format=plain');
    if success
        Out = sscanf(quota_string,'%d');
    else
        Out = -1; % Treat not being able to connect as no quota
    end
    return
end

% n
if ~isnumeric(n) || rem(n,1) ~= 0 || n < 1
    error('randorg:formatN','N should be a scalar positive integer.');
end

% range
if nargin == 1 || isempty(range)
    % Edit here to change default range
    % range = [-1e9,1e9];
    range = [0,1e3];
elseif isnumeric(range) && numel(range) == 2 && all(rem(range,1) == 0) 
    if any(range) < -1e9 || any(range > 1e9)
       error('randorg:boundsRange','The RANGE should be in the [-1e9, 1e9] interval.');
    elseif range(1) >= range(2) 
        error('randorg:minmax','The first value of RANGE should be smaller than the second; min < max');
    end
else
    error('randorg:formatRange','RANGE should be [min, max] where min < max and both are scalar integers in the [-1e9, 1e9] interval.');    
end

% Output size
if ~isempty(varargin) && ~isvector(varargin) && ~all(cellfun(@isnumeric,varargin)) && ~all(@isvector,varargin)
    error('randorg:sizeOut','The size of the output should be supplied as documented by RESHAPE');
end


% [1] LOOP (If the number of integers exceeds 10000 a loop is needed; www.random.org limitation)
numLoops = ceil(n/1e4);
Out = NaN(n,1);
r1 = num2str(range(1));
r2 = num2str(range(2));
for l = 1:numLoops 
    
    % [2a] IF the last loop can have less than 1e4 integers
    if l ~= numLoops 
        num = 1e4;
    else 
        num = rem(n,1e4);
    end % [2a]
    
    % Retrieve elements
    [tmp, noERR] = urlread(['http://www.random.org/integers/?num=' num2str(num) '&min=' r1 '&max=' r2 '&col=1&base=10&format=plain&rnd=new']);
        
    % [2b] IF no errors
    if noERR 
        % Store converting into double by avoiding str2num
        Out((l-1)*1e4+1:(l-1)*1e4+num) = sscanf(tmp,'%d\n');
    % [2b] ...quota ok?
    elseif randorg <= 0
        Out = Out(~isnan(Out));
        warning('warnRandorg:quotaLimit','your quota is insufficient to continue (%d). You retrieved %d integers', randorg, numel(Out));
        return
    % [2b] ...unexpected error
    else 
        error('randorg:unexErr','An unexpected error has occured. Try again.'); 
    end % [2b]
    
end % [1]

% Reshape 
if ~isempty(varargin)
    Out = reshape(Out,varargin{:});
end

end
