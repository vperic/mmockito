classdef Matcher
    %Matcher is an interface for comparisons in mocked arguments
    %   When mocking, we will sometimes want to specify a rule to match an
    %   argument to, not just a constant (eg. "all doubles" or "all strings
    %   starting with xx"). Matchers are the interface which allows us to
    %   do this. Each Matcher only needs to provide a method, matches, 
    %   which returns true if a given value satisfies the Matcher.
    %
    %   The ArgThat Matcher allows the usage of Constraints as Matchers.
    %
    %   Example Matchers can be seen in the mmockito.matchers package.
    %
    %   See also:
    %       Any
    %       ArgThat
    
    %   Internally, Matchers are the same as Constraints from the new
    %   matlab.unittest module, except they do not need to provide a
    %   diagnostic. We create a new class so we can expose different
    %   Matcher names which make more sense in our domain specific
    %   language, and to make the creation of custom Matchers easier (as no
    %   diagnostic has to be provided).
    
    methods(Abstract)
        % matches returns true if actual can be matched by matcher
        answer = matches(matcher, actual);
    end
    
end

