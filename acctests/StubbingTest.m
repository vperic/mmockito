classdef StubbingTest < TestCase
%StubbingTest Acceptance tests for the mock stubbing behavior.
    
    properties
    end
    
    methods
        function obj = StubbingTest(name)
            obj = obj@TestCase(name)
        end
        function test_stubbedMethodPasses_whenCalledWithoutArguments(obj)
            % Prepare fixture
            m = mock();
            when(m).stubbedMethod().thenPass();
            % Test the SUT
            m.stubbedMethod();
        end
        
        function test_stubbedMethodPasses_whenCalledWithArguments(obj)
            m = mock();
            arg1 = 'arg1';
            arg2 = 10;
            when(m).stubbedMethod(arg1, arg2).thenPass();
            
            m.stubbedMethod(arg1, arg2);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithoutArguments(obj)
            m = mock();
            res = 'result';
            when(m).stubbedMethod().thenReturn(res);
            
            assertEqual(m.stubbedMethod(), res);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithArguments(obj)
            m = mock();
            arg1 = 2;
            arg2 = true;
            res = 42;
            when(m).stubbedMethod(arg1, arg2).thenReturn(res);
            
            assertEqual(m.stubbedMethod(arg1, arg2), res);
        end;
        
        function test_stubbedMethodReturns_whenCalledWithVaryingArguments(obj)
            m = mock();
            arg1 = 'arg1';
            arg2 = 2;
            res1 = 10;
            res2 = 20;
            when(m).stubbedMethod(arg1).thenReturn(res1);
            when(m).stubbedMethod(arg1, arg2).thenReturn(res2);
            
            assertFalse(m.stubbedMethod(arg1) == m.stubbedMethod(arg1, arg2));
        end;
        
        function test_stubbedMethodThrowsException(obj)
            m = mock();
            err1 = error('a:b:c', 'error thrown');
            when(m).stubbedMethod().thenThrow(err1);
            f = @() m.stubbedMethod;
            % TODO: this and similar examples require more thought
            
            assertExceptionThrown(f, 'a:b:c');
        end;
    end
    
end

