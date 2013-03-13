% Comparison of the dot notation and the function-style notation of calling
% object methods:
%
% Let's have a class with a single method called 'method'.
% Let's execute the method many times using the function style syntax
%     method(obj)
% and subsequently using the dot notation
%     obj.method or obj.method()
% and let's compare the time needed to execute the statements.

% The function-style call invokes the method directly, while the dot
% notation style actually executes the default subsref method which then
% dispatches the call to the right method. The second method shall thus be
% slower. How much?

% On my machine:
%               T_funcStyle      T_dotNotation      factor
% R2009a           ~2.5             ~3.5              ~1.4
% R2012a           ~0.66            ~1.35             ~2
%
% The speed of method calls improved significantly, but the dot notation is
% still between 1.5 to 2 times slower than the function call.

clc;

obj = ObjectWithMethod;
nReps = 1e5;

tic;
for i = 1:nReps,
    method(obj);
end
tFuncStyle = toc

tic;
for i = 1:nReps,
    obj.method();
end
tDotStyle = toc

tDotStyle/tFuncStyle

