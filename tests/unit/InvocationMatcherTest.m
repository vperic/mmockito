classdef InvocationMatcherTest < matlab.unittest.TestCase
    %InvocationMatcherTest tests the behavior of InvocationMatcher
    %   * Test the constructor.
    %   * Test that matches works on identical Invocations.
    
    properties
    end
    
    methods (Test)
        function test_constructor(tc)
            i = Invocation(substruct('.', 'asdf', '()', {[5] 'string'}));
            
            im = InvocationMatcher(i);
            
            tc.assertEqual(im.func_name, 'asdf');
            tc.assertEqual(im.arguments, {[5] 'string'});
        end;
        
        function test_equalInvocations(tc)
            inv = Invocation(substruct('.', 'asdf', '()', {[5]}));
            inv2 = Invocation(substruct('.', 'asdf', '()', {[5]}));
            
            im = InvocationMatcher(inv);
            im2 = InvocationMatcher(inv2);
            
            tc.assertTrue(im.matches(inv));
            tc.assertTrue(im.matches(inv2));
            tc.assertTrue(im2.matches(inv2));
        end;
        
        function test_notEqualInvocations(tc)
            inv = Invocation(substruct('.', 'asdf', '()', {[5]}));
            inv2 = Invocation(substruct('.', 'asdf', '()', {[5] [6]}));
            inv3 = Invocation(substruct('.', 'asdf', '()', {[4]}));
            
            im = InvocationMatcher(inv);
            im2 = InvocationMatcher(inv2);
            
            tc.assertFalse(im.matches(inv2));
            tc.assertFalse(im.matches(inv3));
            tc.assertFalse(im2.matches(inv3));
        end;
    end;
    
end

