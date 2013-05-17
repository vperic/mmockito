classdef AnyArgs < Matcher
    %AnyArgs is a matcher which matches an arbitrary number of arguments
    %   AnyArgs will match any number of arguments sucessfully, including
    %   zero. It can be used in combination with other matchers, but it has
    %   to be the last one specified (as otherwise it would override
    %   everything else).
    
    %   The Matcher is actually implemented in InvocationPattern.m.
    %
    %   TODO: extract this into an interface, so that users can create
    %   similar matchers
    
    properties
    end
    
    methods
        function answer = matches(self, varargin)
            answer = true;
        end;
    end
    
end

