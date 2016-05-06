% See: SubsrefSandbox
% If we can't use when(mock), can we create a "when" class which would then
% just call the mock object appropriately?
clear all;

d = SubsrefClass;

when(d).aFunc('arg').thenReturn('res'); 
% Works fine in console, but throws an error from the script:
% Static method or constructor invocations cannot be indexed.
% Do not follow the call to the static method or constructor with
% any additional indexing or dot references.
% 
% Apparently, it's a fluke it works at all and should be considered a bug:
% http://stackoverflow.com/q/10440409/93300
% 
% Also: http://blodgett.doof.me.uk/2010/10/01/hateyhatey/
% Apparently, eval'ing the line works but that defeats the purpose

% Per the SO question, should work when used in a function:
whenFunction(); % and it does

%% The real magic
% If the code is called in cell-mode (ctrl-enter), it works! 
d = SubsrefClass;
when(d).aFunc('arg').thenReturn('res'); 