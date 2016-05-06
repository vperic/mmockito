% Exactly what is passed as the substruct for various syntaxes?
% Trying to determine if when(mock) is a possible syntax.

d = SubsrefClass();

% all of these actually cause an error, but we can still inspect the
% relevant substruct so they serve our purpose; XXX: why is this so?
d.when; 
%     type: '.'
%     subs: 'when'

d.when(); 
%     type: '.'
%     subs: 'when'
% 
%     type: '()'
%     subs: {1x0 cell}

d.when('someMethod').thenPass;
%     type: '.'
%     subs: 'when'
% 
%     type: '()'
%     subs: {'someMethod'}
% 
%     type: '.'
%     subs: 'thenPass'

d.when('someMethod').thenReturn('someValue');
%     type: '.'
%     subs: 'when'
% 
%     type: '()'
%     subs: {'someMethod'}
% 
%     type: '.'
%     subs: 'thenReturn'
% 
%     type: '()'
%     subs: {'someValue'}

% All of these work as expected.

when(d);
% returns just 'a method'
% notably, doesn't seem to pass through the subsref mechanism
% Conclusion -> a when(mock).stuff syntax is impossible?

when(d.method); 
% throws an error but d.methos seems to be resolved via subsref

when(d).thenReturn();
% Undefined variable "when" or class "when".