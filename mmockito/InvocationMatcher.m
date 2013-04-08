classdef InvocationMatcher
    %InvocationMatcher converts given Invocation to use matchers
    %   In order to actually compare an Invocation's arguments, we must
    %   convert them to matchers (ie. Constraints, from
    %   matlab.unittest.constraints). As such, InvocationMatcher is
    %   constructed from an Invocation (whose constructor assures data
    %   correctness) but provides a matches method which returns true if
    %   the InvocationMatcher matches the given Invocation.
    
    properties
        func_name;
        arguments = cell(1,0);
    end
    
    methods
        function self = InvocationMatcher(Invocation)
            self.func_name = Invocation.S(1).subs;
            self.arguments = Invocation.S(2).subs;
        end;

        function answer = matches(self, Inv)
            % returns true if Inv can match self

            % isequal recursively compares properties
            % TODO: implement matchers
            answer = isequal(self.func_name, Inv.S(1).subs) && ...
                     isequal(self.arguments, Inv.S(2).subs);
        end;
    end;
end

