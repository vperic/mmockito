% Is it possible to call a function/method without specifying the
% parentheses?

c = ClassWithMethod; % Trying to create an instance without ()
c = ClassWithMethod(); % Instance with ()
% Both calls passed.

c.method; % Call to a method without ()
c.method(); % Call to a method with ()
% Both calls passed and returned 'method'.

% What gets returned, if both the method and a field have the same name?
c = ClassWithMethodAndFieldOfTheSameName();
% Throws error, not possible to have a method and field of the same name.