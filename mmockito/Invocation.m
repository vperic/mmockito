classdef Invocation
    %INVOCATION Summary of this class goes here
    %   Detailed explanation goes here
    
    % Holds the two substructs which define an invocation to an arbitrary
    % function. They have the following fields:
    %
    %   S(1).type = '.'   anything else is an error, we only mock functions
    %   S(1).subs = '...' the function name we are mocking
    %
    %   S(2).type         any legal type
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
            'A function must have arguments, it cannot be called with a dot argument.');
                throw(ME);
            end;            
            
            obj.S = S;
        end;
        
        function answer = matches(self, matchingS)
            % returns true if the substruct matchingS can match self

            % isequal recursively compares properties
            % TODO: implement matchers
            answer = isequal(self.S, matchingS);
        end;
    end
    
end

