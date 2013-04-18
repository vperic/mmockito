classdef InvocationMatcherTest < matlab.unittest.TestCase
    %InvocationMatcherTest tests the behavior of InvocationMatcher
    %   * Test the constructor.
    %   * Test that matches works on identical Invocations.
    %   * Test different method names.
    %   * Test a few matchers to see if they work.
    %   * Test matcher / non-matcher combination
    
    properties
    end
    
    methods (Test)
        function test_constructor(tc)
            import mmockito.internal.*;
            
            i = Invocation(substruct('.', 'asdf', '()', {[5] 'string'}));
            
            im = InvocationMatcher(i);
            
            tc.assertEqual(im.func_name, 'asdf');
        end;
        
        function test_equalInvocations(tc)
            import mmockito.internal.*;
            
            inv = Invocation(substruct('.', 'asdf', '()', {[5]}));
            inv2 = Invocation(substruct('.', 'asdf', '()', {[5]}));
            
            im = InvocationMatcher(inv);
            im2 = InvocationMatcher(inv2);
            
            tc.assertTrue(im.matches(inv));
            tc.assertTrue(im.matches(inv2));
            tc.assertTrue(im2.matches(inv2));
        end;
        
        function test_notEqualInvocations(tc)
            import mmockito.internal.*;
            
            inv = Invocation(substruct('.', 'asdf', '()', {[5]}));
            inv2 = Invocation(substruct('.', 'asdf', '()', {[5] [6]}));
            inv3 = Invocation(substruct('.', 'asdf', '()', {[4]}));
            
            im = InvocationMatcher(inv);
            im2 = InvocationMatcher(inv2);
            
            tc.assertFalse(im.matches(inv2));
            tc.assertFalse(im.matches(inv3));
            tc.assertFalse(im2.matches(inv3));
        end;
        
        function test_differentMethodNames(tc)
            import mmockito.internal.*;
            
            i = Invocation(substruct('.', 'asdf', '()', {[5]}));
            i2 = Invocation(substruct('.', 'fdsa', '()', {[5]}));
            
            im = InvocationMatcher(i);
            
            tc.assertFalse(im.matches(i2));
        end;
            
        
        function test_IsGreaterThanMatcher(tc)
            import mmockito.internal.*;
            
            import matlab.unittest.constraints.IsGreaterThan;

            i = Invocation(substruct('.', 'asdf', '()', {ArgThat(IsGreaterThan(5))}));
            i2 = Invocation(substruct('.', 'asdf', '()', {4}));
            i3 = Invocation(substruct('.', 'asdf', '()', {6 7 8 9}));            
            i4 = Invocation(substruct('.', 'asdf', '()', {6}));

            im = InvocationMatcher(i);

            tc.assertFalse(im.matches(i2));
            tc.assertFalse(im.matches(i3));
            tc.assertTrue(im.matches(i4));
        end;
        
        function test_ContainsSubstringMatcher(tc)
            import mmockito.internal.*;
            import matlab.unittest.constraints.ContainsSubstring;

            i = Invocation(substruct('.', 'asdf', '()', {ArgThat(ContainsSubstring('str'))}));
            i2 = Invocation(substruct('.', 'asdf', '()', {'stingy'}));
            i3 = Invocation(substruct('.', 'asdf', '()', {'sting' 'me'}));            
            i4 = Invocation(substruct('.', 'asdf', '()', {'stringy'}));

            im = InvocationMatcher(i);

            tc.assertFalse(im.matches(i2));
            tc.assertFalse(im.matches(i3));
            tc.assertTrue(im.matches(i4));
        end;        
        
        function test_matcherNonMatcher(tc)
            import mmockito.internal.*;
            import matlab.unittest.constraints.IsEmpty;
            
            i = Invocation(substruct('.', 'asdf', '()', {ArgThat(IsEmpty) 5}));
            i2 = Invocation(substruct('.', 'asdf', '()', {[] 6}));
            i3 = Invocation(substruct('.', 'asdf', '()', {[]}));
            i4 = Invocation(substruct('.', 'asdf', '()', {[] 5}));
            
            im = InvocationMatcher(i);
            
            tc.assertFalse(im.matches(i2));
            tc.assertFalse(im.matches(i3));
            tc.assertTrue(im.matches(i4));
        end;
    end;
    
end

