classdef StubbingTest < matlab.unittest.TestCase
%StubbingTest Acceptance tests for the mock stubbing behavior.
    
    properties
    end
    
    methods (Test)
        function test_stubbedMethodPasses_whenCalledWithoutArguments(testCase)
            % Prepare fixture
            m = Mock();
            m.when.stubbedMethod().thenPass();
            % Test the SUT
            m.stubbedMethod();
        end
        
        function test_stubbedMethodPasses_whenCalledWithArguments(testCase)
            m = Mock();
            arg1 = 'arg1';
            arg2 = 10;
            m.when.stubbedMethod(arg1, arg2).thenPass();
            
            m.stubbedMethod(arg1, arg2);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithoutArguments(testCase)
            m = Mock();
            res = 'result';
            m.when.stubbedMethod().thenReturn(res);
            
            testCase.assertEqual(m.stubbedMethod(), res);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithArguments(testCase)
            m = Mock();
            arg1 = 2;
            arg2 = true;
            res = 42;
            m.when.stubbedMethod(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.stubbedMethod(arg1, arg2), res);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithVaryingArguments(testCase)
            m = Mock();
            arg1 = 'arg1';
            arg2 = 2;
            res1 = 10;
            res2 = 20;
            m.when.stubbedMethod(arg1).thenReturn(res1);
            m.when.stubbedMethod(arg1, arg2).thenReturn(res2);
            
            testCase.assertNotEqual(m.stubbedMethod(arg1), m.stubbedMethod(arg1, arg2));
        end;
        
        function test_stubbedMethodThrowsException(testCase)
            m = Mock();
            err1 = MException('a:b:c', 'error thrown');
            m.when.stubbedMethod().thenThrow(err1);
            
            testCase.assertError(@() m.stubbedMethod(), 'a:b:c');
        end;
        
        function test_stubbingMatchers(tc)
            import matlab.unittest.constraints.*;

            m = Mock();
            m.when.asdf(4, ArgThat(HasNaN)).thenReturn('a NaN');
            m.when.asdf(4, ArgThat(IsFinite)).thenReturn('no NaN');
            
            tc.assertEqual(m.asdf(4, [5 6 NaN]), 'a NaN');
            tc.assertEqual(m.asdf(4, [5 6 7]), 'no NaN');
        end;
        
        function test_AnyMatcher(tc)
            m = Mock();
            m.when.asdf(Any(?double), Any()).thenReturn('a double');
            m.when.asdf(Any('char'), 10).thenReturn('a char10');
            
            tc.assertEqual(m.asdf(5, 'str'), 'a double');
            tc.assertEqual(m.asdf(13, 15), 'a double');
            tc.assertEqual(m.asdf('s', 10), 'a char10');
        end;
        
        function test_overlappingCalls(tc)
            m = Mock();
            m.when.asdf(5).thenReturn('good');
            m.when.asdf(Any(?double)).thenReturn('not implemented');
            m.when.asdf(Any()).thenReturn('bad input');
            
            tc.assertEqual(m.asdf(5), 'good');
            tc.assertEqual(m.asdf(666), 'not implemented');
            tc.assertEqual(m.asdf('str'), 'bad input');
        end;
        
        function test_manyReturns(tc)
            m = Mock();
            m.when.asdf(1).thenReturn(1).thenReturn(2).thenReturn(3);
            
            tc.assertEqual(m.asdf(1), 1);
            tc.assertEqual(m.asdf(1), 2);
            tc.assertEqual(m.asdf(1), 3);
            tc.assertEqual(m.asdf(1), 3);
        end;
    end
    
end

