classdef Any < Matcher
    %Any is a Matcher accepting arguments of specific class or any at all
    %   The Any Matcher provides two functionalities:
    %
    %       Any()      passes for any argument
    %       
    %       Any(class) fails if argument does not derive from class. class
    %                  can be given by its classname of meta.class instance
    %
    %   Deriving from an class is understood as returning true from an
    %   "isa" call.
    
    % Internally, just falls back on the IsInstanceOf(class) constraint.
    %
    % The Matcher is Any (as opposed to any) so as not to override the
    % MATLAB builtin.
    
    properties
        c;
        passAlways = false;
    end
    
    methods
        function self = Any(varargin)
            if nargin==0
                self.passAlways = true;
            elseif nargin==1
                class = varargin{1};
                if ~ischar(class)
                    class = class.Name;
                end;

                self.c = class;
            else
                ME = MException('mmockito:illegalMatcher', ...
                'Any can only be called with zero or one arguments.');
                throw(ME);
            end;
        end;
        
        function answer = matches(self, actual)
            if self.passAlways
                answer = true;
            else
                answer = isa(actual, self.c);
            end;
        end;
    end
    
end

