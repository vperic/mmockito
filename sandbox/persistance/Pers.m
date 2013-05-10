classdef Pers < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        a = {};
    end
    
    methods
        function ans = increment(self)
            persistent id;

            if isempty(id)
                id = 0;
            end;
            
            self.a{length(self.a) + 1} = id;
            id = id + 1;
        end;
    end
    
end

