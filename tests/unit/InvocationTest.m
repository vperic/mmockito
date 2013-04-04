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
            s2 = substruct('{}', {[5 6]}, '()', {[4]});
            
            tc.assertError(@() Invocation(s), 'mmockito:illegalInvocation');
            tc.assertError(@() Invocation(s2), 'mmockito:illegalInvocation');
        end;
        
        function test_equalInvocations(tc)
            s = substruct('.', 'asdf', '()', {[5]});
            s2 = substruct('.', 'asdf', '()', {[5]});
            
            i = Invocation(s);
            i2 = Invocation(s2);
            i3 = Invocation(s2);
            
            tc.assertTrue(i.matches(i));
            tc.assertTrue(i.matches(i2));
            tc.assertTrue(i2.matches(i3));
        end;
        
        function test_notEqualInvocations(tc)
            s = substruct('.', 'asdf', '()', {[5]});
            s2 = substruct('.', 'asdf', '{}', {[5]});
            s3 = substruct('.', 'asdf', '.', 'fdsa');
            
            i = Invocation(s);
            i2 = Invocation(s2);
            i3 = Invocation(s3);            
            
            tc.assertFalse(i.matches(i2));
            tc.assertFalse(i.matches(i3));
            tc.assertFalse(i2.matches(i3));
        end;
    end
end