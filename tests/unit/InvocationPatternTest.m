classdef InvocationPatternTest < matlab.unittest.TestCase
    %InvocationPatternTest tests the behavior of InvocationPattern
    %   * Test the constructor.
    %   * Test that matchedBy works on identical Invocations.
    %   * Test different method names.
    %   * Test a few matchers to see if they work.
    %   * Test matcher / non-matcher combination
    
    properties
    end
    
    methods (Test)
        function test_constructor(tc)
            import mmockito.internal.*;
            
            i = Invocation(substruct('.', 'asdf', '()', {[5] 'string'}));
            
            im = InvocationPattern(i);
            
            tc.assertEqual(im.func_name, 'asdf');
        end;
        
        function test_equalInvocations(tc)
            import mmockito.internal.*;
            
            inv = Invocation(substruct('.', 'asdf', '()', {[5]}));
            inv2 = Invocation(substruct('.', 'asdf', '()', {[5]}));
            
            im = InvocationPattern(inv);
            im2 = InvocationPattern(inv2);
            
            tc.assertTrue(im.matchedBy(inv));
            tc.assertTrue(im.matchedBy(inv2));
            tc.assertTrue(im2.matchedBy(inv2));
        end;
        
        function test_notEqualInvocations(tc)
            import mmockito.internal.*;
            
            inv = Invocation(substruct('.', 'asdf', '()', {[5]}));
            inv2 = Invocation(substruct('.', 'asdf', '()', {[5] [6]}));
            inv3 = Invocation(substruct('.', 'asdf', '()', {[4]}));
            
            im = InvocationPattern(inv);
            im2 = InvocationPattern(inv2);
            
            tc.assertFalse(im.matchedBy(inv2));
            tc.assertFalse(im.matchedBy(inv3));
            tc.assertFalse(im2.matchedBy(inv3));
        end;
        
        function test_differentMethodNames(tc)
            import mmockito.internal.*;
            
            i = Invocation(substruct('.', 'asdf', '()', {[5]}));
            i2 = Invocation(substruct('.', 'fdsa', '()', {[5]}));
            
            im = InvocationPattern(i);
            
            tc.assertFalse(im.matchedBy(i2));
        end;
            
        
        function test_IsGreaterThanMatcher(tc)
            import mmockito.internal.*;
            
            import matlab.unittest.constraints.IsGreaterThan;

            i = Invocation(substruct('.', 'asdf', '()', {ArgThat(IsGreaterThan(5))}));
            i2 = Invocation(substruct('.', 'asdf', '()', {4}));
            i3 = Invocation(substruct('.', 'asdf', '()', {6 7 8 9}));            
            i4 = Invocation(substruct('.', 'asdf', '()', {6}));

            im = InvocationPattern(i);

            tc.assertFalse(im.matchedBy(i2));
            tc.assertFalse(im.matchedBy(i3));
            tc.assertTrue(im.matchedBy(i4));
        end;
        
        function test_ContainsSubstringMatcher(tc)
            import mmockito.internal.*;
            import matlab.unittest.constraints.ContainsSubstring;

            i = Invocation(substruct('.', 'asdf', '()', {ArgThat(ContainsSubstring('str'))}));
            i2 = Invocation(substruct('.', 'asdf', '()', {'stingy'}));
            i3 = Invocation(substruct('.', 'asdf', '()', {'sting' 'me'}));            
            i4 = Invocation(substruct('.', 'asdf', '()', {'stringy'}));

            im = InvocationPattern(i);

            tc.assertFalse(im.matchedBy(i2));
            tc.assertFalse(im.matchedBy(i3));
            tc.assertTrue(im.matchedBy(i4));
        end;        
        
        function test_matcherNonMatcher(tc)
            import mmockito.internal.*;
            import matlab.unittest.constraints.IsEmpty;
            
            i = Invocation(substruct('.', 'asdf', '()', {ArgThat(IsEmpty) 5}));
            i2 = Invocation(substruct('.', 'asdf', '()', {[] 6}));
            i3 = Invocation(substruct('.', 'asdf', '()', {[]}));
            i4 = Invocation(substruct('.', 'asdf', '()', {[] 5}));
            
            im = InvocationPattern(i);
            
            tc.assertFalse(im.matchedBy(i2));
            tc.assertFalse(im.matchedBy(i3));
            tc.assertTrue(im.matchedBy(i4));
        end;
    end;
    
end

