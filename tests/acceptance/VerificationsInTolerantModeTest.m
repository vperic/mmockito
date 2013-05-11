classdef VerificationsInTolerantModeTest < matlab.unittest.TestCase
%VerificationsInTolerantModeTest Acceptance tests for the mock verification behavior.
    
    properties
    end
    
    methods (Test)
        function simpleVerification(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.setParam(10);
            m.goHome();
            % Then
            m.verify.setParam(10);
            m.verify.goHome();
            testCase.assertError(@() m.verify.isThereTheGod(), 'mmockito:VerificationError');
        end
        
        function verificationOnRealObject_success(testCase)
            % Given
            m = Mock(RealClass, 'tolerant');
            % When
            x = m.get(10);
            % Then
            m.verify.get(10);
        end
        
        function verificationOnRealObject_failure(testCase)
            % Given
            m = Mock(RealClass, 'tolerant');
            % When
            % Then
            testCase.assertError(@() m.verify.get(10), 'mmockito:VerificationError');
        end
        
        function numberOfInvocations(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.one();
            m.two(pi);
            m.two(pi);
            % Then
            m.verify.one().times(1);
            m.verify.one().atLeast(0);
            m.verify.one().atLeast(1);
            testCase.assertError(@() ...
                m.verify.one().atLeast(2), ...
                'mmockito:VerificationError');
            testCase.assertError(@() ...
                m.verify.one().atMost(0), ...
                'mmockito:VerificationError');
            m.verify.one().atMost(1);
            m.verify.one().atMost(2);
            m.verify.one(1).times(0);
            testCase.assertError(@()...
                m.verify.one(pi).times(1), ...
                'mmockito:VerificationError');
            testCase.assertError(@() ...
                m.verify.one().never(), ...
                'mmockito:VerificationError');
            
            m.verify.two(pi).times(2);
            m.verify.zero().times(0);
            m.verify.zero().never();
        end
        
        function verificationInOrder_success_onSingleMock(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.first();
            m.second();
            % Then
            ino = InOrder(m);
            ino.verify(m).first();
            ino.verify(m).second();
        end
        
        function verificationInOrder_failure_onSingleMock(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.first();
            m.second();
            % Then
            ino = InOrder(m);
            ino.verify(m).second();
            testCase.assertError(@()...
                ino.verify(m).first(), 'mmockito:VerificationError');
        end
        
        function verificationInOrder_onMultipleMocks(testCase)
            m = Mock();
            m2 = Mock();
            
            m.first();
            m2.second();
            m.third();
            
            ino = InOrder(m, m2);
            ino.verify(m).first();
            ino.verify(m2).second();
            ino.verify(m).third();
        end
        
        function verificationInOrder_failure_onMultipleMocks(testCase)
            m = Mock();
            m2 = Mock();
            
            m.first();
            m2.second();
            m.third();
            
            ino = InOrder(m, m2);
            ino.verify(m).first();
            ino.verify(m).third();

            testCase.assertError(@()...
                ino.verify(m2).second(), 'mmockito:VerificationError');            
        end;
        
        % TODO: mock.verifyZeroInteractions
        % TODO: mock.verifyNoMoreInteractions
    end
    
end

