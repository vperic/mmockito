classdef VerificationsTest < matlab.unittest.TestCase
%VerificationsTest Acceptance tests for the mock verification behavior.
    
    properties
    end
    
    methods (Test)
        function tolerant_simpleVerification(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.setParam(10);
            m.goHome();
            % Then
            m.verify.setParam(10);
            m.verify.goHome();
            testCase.assertError(@() m.verify.isThereTheGod(), @MException);
        end
        

    end
    
end

