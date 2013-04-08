% Comparison of import speed
%   Testing to see if it's faster to import just the used classes from a
%   package, or the whole package. 

% On my machine:
% tAll    = 1.27
% tSingle = 2.47
% factor  ~ 1.9
%
% => It is actually faster to import the whole package than a single class!

clear all;

nReps = 1e5;

tic;
for i = 1:nReps,
    import matlab.unittest.constraints.*;
    clear import;
end
tAll = toc

tic;
for i = 1:nReps,
    import matlab.unittest.constraints.IsEqualTo;
    clear import;
end
tSingle = toc

tSingle/tAll