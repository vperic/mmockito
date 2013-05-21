classdef FirstImprovementLocalSearch < IOAinterface
    %FirstImprovementLocalSearch implements the IOAinterface
    %   The constructor takes an initial solution, function handles to
    %   evaluate, perturb and termCondition functions, and a logger object.
    %
    %   Algorithm pseudocode:
    %
    %       currSol <- initSol
    %       currCost <- evaluate(currSol)
    %       logger.logInitialized;
    %   
    %       while not termCondition():
    %           newSol <- perturb(currSol);
    %           newCost <- evaluate(newSol);
    %           if newCost < currCost:
    %               currSol, currCost <- newSol, newCost
    %               logger.logImproved;
    %
    %       logger.logFinished;
    %       return currSol, currCost
    
    properties
        currSol;
        currCost;
        evaluate;
        perturb;
        termCondition;
        logger;
    end
    
    methods
        function self = FirstImprovementLocalSearch(initSol, ...
                evaluate, perturb, termCondition, logger)
            self.currSol = initSol;
            self.evaluate = evaluate;
            self.perturb = perturb;
            self.termCondition = termCondition;
            self.logger = logger;
        end
        
        function self = initialize(self)
            self.currCost = self.evaluate(self.currSol);
            self.logger.logInitialized();
        end;
        
        function self = run(self)
            while ~self.termCondition()
                newSol = self.perturb(self.currSol);
                newCost = self.evaluate(newSol);
                
                if newCost < self.currCost
                    self.currSol = newSol;
                    self.currCost = newCost;
                    self.logger.logImproved();
                end;
            end;
            
            self.logger.logFinished();
        end;
        
        function [sol, cost] = getRecommendation(self)
%             if isempty(self.currCost) % not initialized yet
%                 ME = MException('IOA:noInit', 'Cannot recommend before init.');
%                 throw(ME);
%             end;
            
            sol = self.currSol;
            cost = self.currCost;
        end;
            
    end
    
end

