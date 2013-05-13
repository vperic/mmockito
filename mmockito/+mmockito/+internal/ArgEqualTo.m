classdef ArgEqualTo < Matcher
    %ArgEqualTo is an internal matcher used to match constants.
    %   If constants are passed to be matched, they need to be converted to
    %   a Matcher. The robust solution would be to reuse the IsEqualTo
    %   constraint from the new matlab.unittest module, but it is not
    %   available in earlier MATLAB versions. In those cases, fallback to a
    %   simpler Matcher which works only with primitive types.
    
    %   Implemented as a try/catch rather than a version check because the
    %   former is much faster; using a version check in both methods
    %   approximately tripled the test time.

    properties
        expected;

        constraint;
    end
    
    methods
        function self = ArgEqualTo(expected)
            try
                import matlab.unittest.constraints.*;
                self.constraint = ArgThat(IsEqualTo(expected));
            catch
                if isa(expected, 'numeric') || isa(expected, 'char')
                    self.expected = expected;
                else
                    ME = MException('mmockito:illegalMatcher', ...
'Matching constants (other than primitive types) is not supported under MATLAB older than 2013a. Please update or use a custom Matcher.');
                    throw(ME);
                end;
            end;
        end;
        
        function answer = satisfiedBy(self, actual)
            try
                answer = satisfiedBy(self.constraint, actual);
            catch
                if isa(self.expected, char)
                    answer = strcmp(self.expected, actual);
                else % numeric
                    answer = eq(self.expected, actual);
                end;
            end;
        end;
    end
    
end

