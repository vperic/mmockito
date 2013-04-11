classdef argThat < Matcher
    %argThat provides an interface to matlab.unittest.constraints;
    %   As Matchers and Constraints are fundamentally the same, provide a
    %   way to encapsulate any Constraint in a matcher. Construct an
    %   argThat Matcher by calling it with any Constraint.
    
    properties
        c;
    end
    
    methods
        function self = argThat(constraint)
            import matlab.unittest.constraints.*;
            
            if ~isa(constraint, 'Constraint')
                ME = MException('mmockito:illegalMatcher', ...
                'argThat only accepts a class which inherits from Constraint.');
                throw(ME);
            end;
            
            self.c = constraint;
        end;
        
        function answer = satisfiedBy(self, actual)
            import matlab.unittest.constraints.*;

            answer = satisfiedBy(self.c, actual);
        end;
    end
    
end

