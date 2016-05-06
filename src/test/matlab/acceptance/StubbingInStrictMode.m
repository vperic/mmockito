classdef StubbingInStrictMode < matlab.unittest.TestCase
%StubbingInStrictModeTest Acceptance tests for the mock stubbing behavior.
    
    properties
    end
    
    methods (Test)
        
        function throwsEx_whenCallingUnstubbedMethod(testCase)
            % Given
            m = Mock('strict');
            % Then
            testCase.assertError(@() m.unstubbed(), ?MException);
        end
        
        function stubbedMethod_passes_whenCalledWithoutArguments(testCase)
            % Given
            m = Mock('strict');
            % When
            m.when.stub().thenPass();
            % Then
            m.stub();   % This shall just pass
            testCase.assertError(@() m.unstubbed(), ?MException);
        end
        
        function stubbedMethod_passes_whenCalledWithArguments(testCase)
            % Given
            m = Mock('strict');
            arg1 = 'arg1';
            arg2 = 10;
            % When
            m.when.stub(arg1, arg2).thenPass();
            % Then            
            m.stub(arg1, arg2);   % This shall just pass
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_returns_whenCalledWithoutArguments(testCase)
            % Given
            m = Mock('strict');
            res = 'result';
            % When
            m.when.stub().thenReturn(res);
            % Then            
            testCase.assertEqual(m.stub(), res);
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_returns_whenCalledWithArgs(testCase)
            % Given
            m = Mock('strict');
            arg1 = 2;
            arg2 = true;
            res = 42;
            % When
            m.when.stub(arg1, arg2).thenReturn(res);
            % Then            
            testCase.assertEqual(m.stub(arg1, arg2), res);
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_returnsDifferentResults_forDifferentArgs(testCase)
            % Given
            m = Mock('strict');
            arg1 = 'arg1';
            arg2 = 2;
            res1 = 10;
            res2 = 20;
            % When
            m.when.stub(arg1).thenReturn(res1);
            m.when.stub(arg1, arg2).thenReturn(res2);
            % Then            
            testCase.assertNotEqual(m.stub(arg1), m.stub(arg1, arg2));
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_throwsException(testCase)
            % Given
            m = Mock('strict');
            err1 = MException('a:b:c', 'error thrown');
            % When
            m.when.stub().thenThrow(err1);
            % Then
            testCase.assertError(@() m.stub(), 'a:b:c');
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;

		function stubbedMethod_withArgThatMatcher_whenItMatches(testCase)
            import matlab.unittest.constraints.*;
		    % Given
            m = Mock('strict');
            % When
            m.when.stub(4, ArgThat(HasNaN)).thenReturn('a NaN');
            m.when.stub(4, ArgThat(IsFinite)).thenReturn('no NaN');
            % Then
            testCase.assertEqual(m.stub(4, [5 6 7]), 'no NaN');
            testCase.assertEqual(m.stub(4, [5 6 NaN]), 'a NaN');
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
		function stubbedMethod_withArgThatMatcher_whenItDoesNotMatch(testCase)
            import matlab.unittest.constraints.*;
		    % Given
            m = Mock('strict');
            % When
            m.when.stub(4, ArgThat(HasNaN)).thenReturn('a NaN');
            m.when.stub(4, ArgThat(IsFinite)).thenReturn('no NaN');
            % Then
            testCase.assertError(@() m.stub(), ?MException);
            testCase.assertError(@() m.stub(4), ?MException);
            testCase.assertError(@() m.stub(4,10,'too long arg list'), ?MException);
            testCase.assertError(@() m.stub(5, [NaN]), ?MException);
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_withAnyMatcher_whenItMatches(testCase)
            % Given
            m = Mock('strict');
            % When
            m.when.stub(Any(?double), Any()).thenReturn('a double');
            m.when.stub(Any('char'), 10).thenReturn('a char10');
            %
            testCase.assertEqual(m.stub(5, 'str'), 'a double');
            testCase.assertEqual(m.stub(13, 15), 'a double');
            testCase.assertEqual(m.stub('s', 10), 'a char10');
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_withAnyMatcher_whenItDoesNotMatch(testCase)
            % Given
            m = Mock('strict');
            % When
            m.when.stub(Any(?double), Any()).thenReturn('a double');
            m.when.stub(Any('char'), 10).thenReturn('a char10');
            % Then
            testCase.assertError(@() m.stub(), ?MException);
            testCase.assertError(@() m.stub(4), ?MException);
            testCase.assertError(@() m.stub(4,10,'too long arg list'), ?MException);
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_returnsFirstMatch_forOverlappingCalls(testCase)
            % Given
            m = Mock('strict');
            % When
            m.when.stub(5).thenReturn('good');
            m.when.stub(Any(?double)).thenReturn('not implemented');
            m.when.stub(Any()).thenReturn('bad input');
            % Then
            testCase.assertEqual(m.stub(5), 'good');
            testCase.assertEqual(m.stub(666), 'not implemented');
            testCase.assertEqual(m.stub('str'), 'bad input');
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_returnsSequenceOfResults(testCase)
            % Given
            m = Mock('strict');
            % When
            m.when.stub(1).thenReturn(1).thenReturn(2).thenReturn(3);
            % Then
            testCase.assertEqual(m.stub(1), 1);
            testCase.assertEqual(m.stub(1), 2);
            testCase.assertEqual(m.stub(1), 3);
            testCase.assertEqual(m.stub(1), 3);
            testCase.assertEqual(m.stub(1), 3);
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_returnsSequence_usingTimes(testCase)
            % Given
            m = Mock('strict');
            % When
            m.when.stub(5).thenReturn('fine').times(2).thenReturn('bad!');
            % Then
            testCase.assertEqual(m.stub(5), 'fine');
            testCase.assertEqual(m.stub(5), 'fine');
            testCase.assertEqual(m.stub(5), 'bad!');
            testCase.assertEqual(m.stub(5), 'bad!');
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;
        
        function stubbedMethod_eventuallyThrowsEx_whenThenReturnEndsWithTimes(testCase)
            % Given
            m = Mock('strict');
            % When
            m.when.stub(5).thenReturn('ok').times(2);
            % Then
            testCase.assertEqual(m.stub(5), 'ok');
            testCase.assertEqual(m.stub(5), 'ok');
            testCase.assertError(@() m.stub(5), ?MException);
            testCase.assertError(@() m.unstubbed(), ?MException);
        end;

    end
    
end

