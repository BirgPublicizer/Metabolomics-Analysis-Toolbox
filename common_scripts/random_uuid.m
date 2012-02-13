function [ uuid_string ] = random_uuid
%RANDOM_UUID Return a random uuid generated from random.org 
%or the system random number generator
%
% Returns a random uuid
% ( http://en.wikipedia.org/wiki/Universally_unique_identifier ).
% This will be in version 4 format.  That means that it  
% consists of 36 characters in the form:
%           xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx 
% where x is any hexadecimal digit and y is either 8, 9, A, 
% or B.  This is equivalent to setting a version identifier
% nibble and two other reserved bits.
%
% First attempts to get the bits needed from random.org.  
% Failing that, gets them from the random number generator 
% using rand.
rand_nums = [];

% Try to get the bits from random.org
quota = randorg;
if quota > 124
    rand_nums = randorg(31, [0,15]);
end

% If we failed to get the bits from random.org, use the pseudorandom number
% generator
if isempty(rand_nums) 
    rand_nums = randi(16,31,1)-1;
end

% Set the two reserved bits
rand_nums(16)=bitor(bitand(rand_nums(16),11),8);

% Assemble the string form - which adds the extra version number nibble
uuid_string = [ ...
    sprintf('%x',rand_nums(1:8)) '-' ...
    sprintf('%x',rand_nums(9:12)) ...
    '-4' sprintf('%x',rand_nums(13:15)) ...
    '-' sprintf('%x',rand_nums(16:19)) ...
    '-' sprintf('%x',rand_nums(20:31)) ];
