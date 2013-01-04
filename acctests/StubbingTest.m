classdef StubbingTest < TestCase
%StubbingTest Acceptance tests for the mock stubbing behavior.
    
    properties
    end
    
    methods
        function obj = StubbingTest(name)
            obj = obj@TestCase(name)
        end
        function test_stubbedMethodJustPasses_whenCalledWithoutArguments(obj)
            % Prepare fixture
            m = mock();
            when(m).stubbedMethod().thenPass();
            % Test the SUT
            m.stubbedMethod();
        end
    end
    
end

