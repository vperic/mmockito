classdef ClassWithMethodAndFieldOfTheSameName
    properties
        something = 'field';
    end
    methods
        function ret = something(obj)
            ret = 'method';
        end
    end
end