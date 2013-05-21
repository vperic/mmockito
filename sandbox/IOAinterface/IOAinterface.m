classdef IOAinterface < handle
    %IOAinterface is the interface we are trying to implement.
    %   There are 4 abstract methods defined:
    %
    %       * initialize()
    %       * run()
    %       * getRecommendatioin()  -> returns [solution, cost]
    %
    %   The constructor is expected to take all inputs needed, none of the
    %   methods have any arguments.
    
    properties
    end
    
    methods (Abstract)
        initialize(self);
        run(self);
        [solution, cost] = getRecommendation(self);
    end
    
end

