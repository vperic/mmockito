classdef StubbingTest < matlab.unittest.TestCase
%StubbingTest Acceptance tests for the mock stubbing behavior.
    
    properties
    end
    
    methods (Test)
        function test_stubbedMethodPasses_whenCalledWithoutArguments(testCase)
            % Prepare fixture
            m = mock();
            m.when.stubbedMethod().thenPass();
            % Test the SUT
            m.stubbedMethod();
        end
        
        function test_stubbedMethodPasses_whenCalledWithArguments(testCase)
            m = mock();
            arg1 = 'arg1';
            arg2 = 10;
            m.when.stubbedMethod(arg1, arg2).thenPass();
            
            m.stubbedMethod(arg1, arg2);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithoutArguments(testCase)
            m = mock();
            res = 'result';
            m.when.stubbedMethod().thenReturn(res);
            
            testCase.assertEqual(m.stubbedMethod(), res);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithArguments(testCase)
            m = mock();
            arg1 = 2;
            arg2 = true;
            res = 42;
            m.when.stubbedMethod(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.stubbedMethod(arg1, arg2), res);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithVaryingArguments(testCase)
            m = mock();
            arg1 = 'arg1';
            arg2 = 2;
            res1 = 10;
            res2 = 20;
            m.when.stubbedMethod(arg1).thenReturn(res1);
            m.when.stubbedMethod(arg1, arg2).thenReturn(res2);
            
            testCase.assertNotEqual(m.stubbedMethod(arg1), m.stubbedMethod(arg1, arg2));
        end;
        
        function test_stubbedMethodThrowsException(testCase)
            m = mock();
            err1 = MException('a:b:c', 'error thrown');
            m.when.stubbedMethod().thenThrow(err1);
            
            testCase.assertError(@() m.stubbedMethod(), 'a:b:c');
        end;
        
        function test_stubbingMatchers(tc)
            import matlab.unittest.constraints.*;

            m = mock();
            m.when.asdf(4, HasNaN).thenReturn('a NaN');
            m.when.asdf(4, IsFinite).thenReturn('no NaN');
            
            tc.assertEqual(m.asdf(4, [5 6 NaN]), 'a NaN');
            tc.assertEqual(m.asdf(4, [5 6 7]), 'no NaN');
        end;
    end
    
end

