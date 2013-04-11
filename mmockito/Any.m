classdef Any < Matcher
    %Any is a Matcher accepting arguments of specific class or any at all
    %   The Any Matcher provides two functionalities:
    %
    %       Any()      passes for any argument
    %       
    %       Any(class) fails if argument does not derive from class. class
    %                  can be given by its classname of meta.class instance
    
    % Internally, just falls back on the IsInstanceOf(class) constraint.
    
    properties
        c;
        passAlways = false;
    end
    
    methods
        function self = Any(varargin)
            import matlab.unittest.constraints.*;
            
            if nargin==0
                self.passAlways = true;
            elseif nargin==1
                self.c = IsInstanceOf(varargin{1});
            else
                ME = MException('mmockito:illegalMatcher', ...
                'Any can only be called with zero or one arguments.');
                throw(ME);
            end;
        end;
        
        function answer = satisfiedBy(self, actual)            
            import matlab.unittest.constraints.*;
            
            if self.passAlways
                answer = true;
            else
                answer = satisfiedBy(self.c, actual);
            end;
        end;
    end
    
end

