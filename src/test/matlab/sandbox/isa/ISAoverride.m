classdef ISAoverride
    %ISAOVERRIDE tests if its possible to override the "isa" function
    %   Yes, it seems to be possible.
    
    properties
    end
    
    methods
        function answer = isa(self, str)
            answer = true;
        end;
    end
    
end

