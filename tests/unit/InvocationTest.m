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
            
            inv = Invocation(s);
            inv2 = Invocation(s2);
        end;
        
        function test_incorrectConstructor(tc)
            s = substruct('()', '{[5]}', '.', 'asdf');
            s2 = substruct('{}', {[5 6]}, '()', {[4]});
            s3 = substruct('.', 'func', '.', 'otherFunc');
            
            tc.assertError(@() Invocation(s), 'mmockito:illegalInvocation');
            tc.assertError(@() Invocation(s2), 'mmockito:illegalInvocation');
            tc.assertError(@() Invocation(s3), 'mmockito:illegalInvocation');
        end;
        
        function test_equalInvocations(tc)
            s = substruct('.', 'asdf', '()', {[5]});
            s2 = substruct('.', 'asdf', '()', {[5]});
            
            i = Invocation(s);
            i2 = Invocation(s2);
            
            tc.assertTrue(i.matches(s));
            tc.assertTrue(i.matches(s2));
            tc.assertTrue(i2.matches(s2));
        end;
        
        function test_notEqualInvocations(tc)
            s = substruct('.', 'asdf', '()', {[5]});
            s2 = substruct('.', 'asdf', '{}', {[5]});
            s3 = substruct('.', 'asdf', '{}', {[4]});
            
            i = Invocation(s);
            i2 = Invocation(s2);
            i3 = Invocation(s3);            
            
            tc.assertFalse(i.matches(s2));
            tc.assertFalse(i.matches(s3));
            tc.assertFalse(i2.matches(s3));
        end;
    end
end