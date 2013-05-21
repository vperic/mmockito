classdef FirstImprovementLocalSearchTest < matlab.unittest.TestCase

    methods (Test)
%         function getRecommendation_throwsError_whenCalledBeforeInit(testCase)
%             % Given
%             m = Mock();
%             mockLogger = Mock();
%             
%             IOA = FirstImprovementLocalSearch(0, @m.evaluate, ...
%                     @m.perturb, @m.termCond, mockLogger);
%                 
%             % Then
%             testCase.assertError(@() IOA.getRecommendation(), 'IOA:noInit');
%         end;
        
        function verifyLogger_whenInitialized(testCase)
            % Given
            m = Mock();
            mockLogger = Mock();
            
            IOA = FirstImprovementLocalSearch(0, @m.evaluate, ...
                    @m.perturb, @m.termCond, mockLogger);
                
            % When
            IOA.initialize();
            
            % Then
            mockLogger.verify.logInitialized();
        end;
        
        function verifyLogger_whenTermConditionTrue(testCase)
            % Given
            m = Mock();
            m.when.termCond().thenReturn(true);
            mockLogger = Mock();
            
            IOA = FirstImprovementLocalSearch(0, @m.evaluate, ...
                    @m.perturb, @m.termCond, mockLogger);
                
            % When
            IOA.initialize();
            IOA.run();
            
            % Then
            inOrder = InOrder(mockLogger);
            inOrder.verify(mockLogger).logInitialized();
            inOrder.verify(mockLogger).logFinished();
        end;
        
        function verifyLogger_whenResultImproved(testCase)
            % Given
            m = Mock();
            m.when.termCond().thenReturn(false).times(3).thenReturn(true);
            m.when.evaluate(Any()).thenReturn(2).thenReturn(1);
            mockLogger = Mock();
            
            IOA = FirstImprovementLocalSearch(0, @m.evaluate, ...
                    @m.evaluate, @m.termCond, mockLogger);
                
            % When
            IOA.initialize();
            IOA.run();
            
            % Then
            mockLogger.verify.logImproved().atLeast(1);
        end;
        
        function checkResult_whenTermConditionTrue(testCase)
            % Given
            m = Mock();
            m.when.termCond().thenReturn(true);
            mockLogger = Mock();
            
            IOA = FirstImprovementLocalSearch('firstSol', @m.evaluate, ...
                    @m.perturb, @m.termCond, mockLogger);
                
            % When
            IOA.initialize();
            IOA.run();
            [sol, c] = IOA.getRecommendation();
            
            % Then
            testCase.assertEqual(sol, 'firstSol');
        end;
        
        function checkResult_whenResultImproved(testCase)
            % Given
            m = Mock();
            m.when.termCond().thenReturn(false).times(5).thenReturn(true);
            m.when.evaluate(Any()).thenReturn(2).thenReturn(1);
            mockLogger = Mock();
            
            IOA = FirstImprovementLocalSearch(0, @m.evaluate, ...
                    @m.evaluate, @m.termCond, mockLogger);
                
            % When
            IOA.initialize();
            IOA.run();
            [sol, c] = IOA.getRecommendation();
            
            % Then
            testCase.assertEqual(c, 1);
        end;
    end
end