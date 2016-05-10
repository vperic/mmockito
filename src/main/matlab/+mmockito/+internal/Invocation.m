classdef Invocation
    %Invocation holds the two substruct which define a method invocation
    %   The two substruct are enough to define an arbitrary method call.
    %   Invocation is a value class, there is no difference between two
    %   Invocations created with the same substructs. The class only has a
    %   constructor which checks if we defined a valid method call.
    %
    %   S(1).type = '.'   we only mock functions
    %   S(1).subs = '...' the function name we are mocking
    %
    %   S(2).type = '()'  functions are only called with round brackets
    %   S(2).subs         call arguments, can be anything

    
    properties
        S;
    end
    
    methods
        function obj = Invocation(S)
            if S(1).type ~= '.'
                ME = MException('mmockito:illegalInvocation', ...
                                'Must call a function on the mock object');
                throw(ME);
            end;
            
            if S(2).type == '.'
                ME = MException('mmockito:illegalInvocation', ...
            'A function must be called with round brackets.');
                throw(ME);
            end;            
            
            obj.S = S;
        end;

    end
    
end

