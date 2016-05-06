classdef StubbingInTolerantModeTest < matlab.unittest.TestCase
%StubbingInTolerantModeTest Acceptance tests for the mock stubbing behavior.
    
    properties
    end
    
    methods (Test)
        
        function passes_whenCallingUnstubbedMethod(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.anyMethod(); % This shall just pass
            res = m.anyOtherMethod(); % Return empty matrix
            [res2,res3] = m.yetAnotherMethod();
            % Then
            testCase.assertEqual(res, []);
            testCase.assertEqual(res2, []);
            testCase.assertEqual(res3, []);            
        end
        
        function stubbedMethod_passes_whenCalledWithoutArguments(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.when.stub().thenPass();
            % Then
            m.stub();
            testCase.assertEqual(m.unstubbed(), []);
        end
        
        function stubbedMethod_passes_whenCalledWithArguments(testCase)
            % Given
            m = Mock('tolerant');
            arg1 = 'arg1';
            arg2 = 10;
            % When
            m.when.stub(arg1, arg2).thenPass();
            % Then            
            m.stub(arg1, arg2);
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_returns_whenCalledWithoutArguments(testCase)
            % Given
            m = Mock('tolerant');
            res = 'result';
            % When
            m.when.stub().thenReturn(res);
            % Then            
            testCase.assertEqual(m.stub(), res);
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_returns_whenCalledWithArgs(testCase)
            % Given
            m = Mock('tolerant');
            arg1 = 2;
            arg2 = true;
            res = 42;
            % When
            m.when.stub(arg1, arg2).thenReturn(res);
            % Then            
            testCase.assertEqual(m.stub(arg1, arg2), res);
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_returnsDifferentResults_forDifferentArgs(testCase)
            % Given
            m = Mock('tolerant');
            arg1 = 'arg1';
            arg2 = 2;
            res1 = 10;
            res2 = 20;
            % When
            m.when.stub(arg1).thenReturn(res1);
            m.when.stub(arg1, arg2).thenReturn(res2);
            % Then            
            testCase.assertNotEqual(m.stub(arg1), m.stub(arg1, arg2));
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_throwsException(testCase)
            % Given
            m = Mock('tolerant');
            err1 = MException('a:b:c', 'error thrown');
            % When
            m.when.stub().thenThrow(err1);
            % Then
            testCase.assertError(@() m.stub(), 'a:b:c');
            testCase.assertEqual(m.unstubbed(), []);
        end;

		function stubbedMethod_withArgThatMatcher_whenItMatches(testCase)
            import matlab.unittest.constraints.*;
		    % Given
            m = Mock('tolerant');
            % When
            m.when.stub(4, ArgThat(HasNaN)).thenReturn('a NaN');
            m.when.stub(4, ArgThat(IsFinite)).thenReturn('no NaN');
            % Then
            testCase.assertEqual(m.stub(4, [5 6 7]), 'no NaN');
            testCase.assertEqual(m.stub(4, [5 6 NaN]), 'a NaN');
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
		function stubbedMethod_withArgThatMatcher_whenItDoesNotMatch(testCase)
            import matlab.unittest.constraints.*;
		    % Given
            m = Mock('tolerant');
            % When
            m.when.stub(4, ArgThat(HasNaN)).thenReturn('a NaN');
            m.when.stub(4, ArgThat(IsFinite)).thenReturn('no NaN');
            % Then
            testCase.assertEqual(m.stub(), []);
            testCase.assertEqual(m.stub(4), []);
            testCase.assertEqual(m.stub(4,10,'too long arg list'), []);
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_withAnyMatcher_whenItMatches(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.when.stub(Any(?double), Any()).thenReturn('a double');
            m.when.stub(Any('char'), 10).thenReturn('a char10');
            %
            testCase.assertEqual(m.stub(5, 'str'), 'a double');
            testCase.assertEqual(m.stub(13, 15), 'a double');
            testCase.assertEqual(m.stub('s', 10), 'a char10');
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_withAnyMatcher_whenItDoesNotMatch(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.when.stub(Any(?double), Any()).thenReturn('a double');
            m.when.stub(Any('char'), 10).thenReturn('a char10');
            % Then
            testCase.assertEqual(m.stub(), []);
            testCase.assertEqual(m.stub(4), []);
            testCase.assertEqual(m.stub(4,10,'too long arg list'), []);
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_returnsFirstMatch_forOverlappingCalls(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.when.stub(5).thenReturn('good');
            m.when.stub(Any(?double)).thenReturn('not implemented');
            m.when.stub(Any()).thenReturn('bad input');
            % Then
            testCase.assertEqual(m.stub(5), 'good');
            testCase.assertEqual(m.stub(666), 'not implemented');
            testCase.assertEqual(m.stub('str'), 'bad input');
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_returnsSequenceOfResults(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.when.stub(1).thenReturn(1).thenReturn(2).thenReturn(3);
            % Then
            testCase.assertEqual(m.stub(1), 1);
            testCase.assertEqual(m.stub(1), 2);
            testCase.assertEqual(m.stub(1), 3);
            testCase.assertEqual(m.stub(1), 3);
            testCase.assertEqual(m.stub(1), 3);
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_returnsSequence_usingTimes(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.when.stub(5).thenReturn('fine').times(2).thenReturn('bad!');
            % Then
            testCase.assertEqual(m.stub(5), 'fine');
            testCase.assertEqual(m.stub(5), 'fine');
            testCase.assertEqual(m.stub(5), 'bad!');
            testCase.assertEqual(m.stub(5), 'bad!');
            testCase.assertEqual(m.unstubbed(), []);
        end;
        
        function stubbedMethod_eventuallyThrowsEx_whenThenReturnEndsWithTimes(testCase)
            % Given
            m = Mock('tolerant');
            % When
            m.when.stub(5).thenReturn('ok').times(2);
            % Then
            testCase.assertEqual(m.stub(5), 'ok');
            testCase.assertEqual(m.stub(5), 'ok');
            testCase.assertEqual(m.stub(5), []);
            testCase.assertEqual(m.unstubbed(), []);
        end;

        function passes_whenStubbingExistingMethodOfRealClass(testCase)
            % Given
            m = Mock(RealClass, 'tolerant');
            % Then
            m.when.get().thenPass();  % This shall just pass
        end
        
        function passes_whenStubbingNonExistingMethodOfRealClass(testCase)
            % Given
            m = Mock(RealClass, 'tolerant');
            % Then
            m.when.nonexistent().thenPass();  % This shall pass too.
        end
        
        function mustSpecify_exactNumberOfReturnValues(testCase)
            m = Mock('tolerant');
            
            m.when.stub(5).thenReturn(1, 2);
            
            [a, b] = m.stub(5);
            testCase.assertEqual(a, 1);
            testCase.assertEqual(b, 2);
            
            testCase.assertError(@() m.stub(5), 'mmockito:illegalCall');
            % TODO: check that [a,b,c ] = m.stub(5) also errors
        end
       
         function check_for_property_assignments_realclass(testCase)
           m = Mock(RealClass, 'tolerant');
           m.prop1 = 1;
           m.prop2 = 'msg';
           testCase.assertEqual(m.prop1, 1);
           testCase.assertEqual(m.prop2, 'msg');
        end
        
    end
    
end

