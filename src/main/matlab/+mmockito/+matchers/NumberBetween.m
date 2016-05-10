classdef NumberBetween < Matcher
    %NumberBetween is an example matcher
    %   Example to demonstrate how to create a custom matcher.
    %   NumberBetween passes if the given value is between (and including) 
    %   two predefined values.
    
    properties
        upperBound;
        lowerBound;
    end
    
    methods
        function self = NumberBetween(low, up)
            
            % The constructor can be used to check input correctness
            if ~isa(low, 'numeric') || ~isa(up, 'numeric')
                ME = MException('mmockito:illegalMatcher', ...
                'NumberBetween must be called with numeric types.');
                throw(ME);
            end;
            
            self.lowerBound = low;
            self.upperBound = up;
        end;
        
        function answer = matches(self, num)
            if self.lowerBound <= num && num <= self.upperBound
                answer = true;
            else
                answer = false;
            end;
        end;
    end
    
end

