classdef StringContaining < Matcher
    %StringContaining is an example matcher
    %   Example demonstrating how to create a custom matcher.
    %   StringContaining passes if the given value contains the predefined
    %   string; StringContaining is case-sensitive.
    %
    %   matlab.unittest.constraints.ContainsSubstring is a Constraint
    %   allowing to ignore case or spaces. It can be used with Mocks if
    %   combined with the ArgThat matcher.
    
    properties
        substring;
    end
    
    methods
        function self = StringContaining(str)
            if ~ischar(str)
                ME = MException('mmockito:illegalMatcher', ...
                'StringContaining must be called with a char type.');
                throw(ME);
            end;
            
            self.substring = str;
        end;
        
        function answer = matches(self, str)
            answer = ~isempty(strfind(str, self.substring));
        end;
    end
    
end

