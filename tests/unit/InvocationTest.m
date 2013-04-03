classdef InvocationTest < matlab.unittest.TestCase
    %InvocationTest Tests the behaviour of the Invocation value class
    %   * Test that creation is handled correctly (first substruct must
    %   define a method).
    %   * Test that matches works on identical Invocations.
    
    properties
    end
    
    methods (Test)
        function test_correctConstructor(tc)
            s = substruct('.', 'asdf', '()', {[5]});
            s2 = substruct('.', 'asdf', '{}', {[5]});
            s3 = substruct('.', 'asdf', '.', 'fdsa');
            
            inv = Invocation(s);
            inv2 = Invocation(s2);
            inv3 = Invocation(s3);
        end;
        
        function test_incorrectConstructor(tc)
            s = substruct('()', '{[5]}', '.', 'asdf');
            
            tc.assertError(@() Invocation(s), 'mmockito:illegalInvocation');
        end;
    end
end