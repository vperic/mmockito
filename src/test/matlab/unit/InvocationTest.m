classdef InvocationTest < matlab.unittest.TestCase
    %InvocationTest Tests the behaviour of the Invocation value class
    %   * Test that creation is handled correctly (first substruct must
    %   define a method).
    
    properties
    end
    
    methods (Test)
        function test_correctConstructor(tc)
            import mmockito.internal.*;
            
            s = substruct('.', 'asdf', '()', {[5]});
            
            inv = Invocation(s);
        end;
        
        function test_incorrectConstructor(tc)
            import mmockito.internal.*;
            
            s = substruct('()', '{[5]}', '.', 'asdf');
            s2 = substruct('{}', {[5 6]}, '()', {[4]});
            s3 = substruct('.', 'func', '.', 'otherFunc');
            
            tc.assertError(@() Invocation(s), 'mmockito:illegalInvocation');
            tc.assertError(@() Invocation(s2), 'mmockito:illegalInvocation');
            tc.assertError(@() Invocation(s3), 'mmockito:illegalInvocation');
        end;

    end
end