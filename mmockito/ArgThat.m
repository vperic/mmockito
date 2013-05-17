classdef ArgThat < Matcher
    %ArgThat provides an interface to matlab.unittest.constraints;
    %   As Matchers and Constraints are fundamentally the same, provide a
    %   way to encapsulate any Constraint in a matcher. Construct an
    %   ArgThat Matcher by calling it with any Constraint.
    
    properties
        c;
    end
    
    methods
        function self = ArgThat(constraint)
            import matlab.unittest.constraints.*;
            
            if ~isa(constraint, 'Constraint')
                ME = MException('mmockito:illegalMatcher', ...
                'ArgThat only accepts a class which inherits from Constraint.');
                throw(ME);
            end;
            
            self.c = constraint;
        end;
        
        function answer = matches(self, actual)
            import matlab.unittest.constraints.*;

            answer = satisfiedBy(self.c, actual);
        end;
    end
    
end

