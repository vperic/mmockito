classdef RealClass < handle
    %RealClass Class used in acceptance tests
    
    properties
        prop1
        prop2
    end
    
    methods
        function ret = get(x)
            ret = x;
        end
    end
    
end

