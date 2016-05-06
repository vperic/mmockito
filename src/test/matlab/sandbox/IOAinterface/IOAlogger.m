classdef IOAlogger
    %IOAlogger is the interface for the IOA logger.
    %   Provides three methods:
    %
    %       * logInitialized()
    %       * logImproved()
    %       * logFinished()
    
    properties
    end
    
    methods (Abstract)
        logInitialized(self);
        logImproved(self);
        logFinished(self);
    end
    
end

