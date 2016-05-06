classdef SubsrefClass
    %SUBSREFBEHAVIOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function when2(obj)
           disp('a method');
        end
        
        function answer = subsref(obj, S)
            for i=1:length(S)
                S(i)
            end;
        end;
    end
    
end

