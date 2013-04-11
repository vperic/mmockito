classdef InvocationMatcher
    %InvocationMatcher converts given Invocation to use matchers
    %   In order to actually compare an Invocation's arguments, we must
    %   convert them to matchers (ie. Constraints, from
    %   matlab.unittest.constraints). As such, InvocationMatcher is
    %   constructed from an Invocation (whose constructor assures data
    %   correctness) but provides a matches method which returns true if
    %   the InvocationMatcher matches the given Invocation.
    
    %   We construct the matchers by inspecting S(2).subs of the passed
    %   Invocation. If the object is a matcher already, we leave it be; if
    %   not, we convert it to an "IsEqualTo" matcher. There is a special 
    %   case when passed empty input - a 1x0 cell array is returned.
    %   Currently, this is handled with a separate if statement but a
    %   better way may be divised. 
    
    properties
        func_name;
        args;
    end
    
    methods
        function self = InvocationMatcher(Invocation)
            import matlab.unittest.constraints.*;
            
            self.func_name = Invocation.S(1).subs;
            self.args = Invocation.S(2).subs;
            
            % create matchers
            argLength = size(self.args, 2);
            if argLength == 0
                % special case, no arguments
                self.args = {argThat(IsEqualTo(cell(1,0)))};
            else
                newArgs = cell(1, argLength);
                for i=1:argLength
                    matcher = self.args{i};
                    if ~isa(matcher, 'Matcher')
                        newArgs{i} = argThat(IsEqualTo(matcher));
                    else
                        newArgs{i} = matcher;
                    end;
                end;
                
                self.args = newArgs;
            end;
            
        end;

        function answer = matches(self, Inv)
            % returns true if Inv can match self
            import matlab.unittest.constraints.*;

            if ~strcmp(self.func_name, Inv.S(1).subs)
                answer = false;
                return;
            end;
            
            argLength = size(Inv.S(2).subs, 2);
            if argLength == 0
                % special case, no arguments
                answer = satisfiedBy(self.args{1}, cell(1,0));
            elseif argLength ~= size(self.args, 2)
                answer = false;
            else
                answer = all(cellfun(@satisfiedBy, self.args, Inv.S(2).subs));
            end;
        end;

    end;
end

