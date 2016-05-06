classdef MatchersTest < matlab.unittest.TestCase
    %MatchersTest tests the behavior of Matchers
    %   Matchers are generally simple, we usually check the constructor
    %   error handling and the matches method.
    
    properties
    end
    
    methods(Test)
        function test_ArgThat_constructor(tc)
            import matlab.unittest.constraints.*;
            
            ArgThat(HasSize([3 2]));
            tc.assertError(@() ArgThat(3), 'mmockito:illegalMatcher');
        end;
        
        function test_ArgThat_matches(tc)
            import matlab.unittest.constraints.*;
            
            a = ArgThat(IsLessThan(4));
            
            tc.assertTrue(a.matches(3));
            tc.assertFalse(a.matches(5));
        end;
        
        function test_Any_constructor(tc)
            Any('double');
            Any(?char);
            Any();
            
            tc.assertError(@() Any(1,2), 'mmockito:illegalMatcher');
        end;
        
        function test_Any_matches(tc)
            import matlab.unittest.constraints.*;
            
            a = Any();
            b = Any(?logical);
            
            tc.assertTrue(a.matches(4));
            tc.assertTrue(a.matches('str'));
            tc.assertTrue(a.matches(cell(4,3)));
            
            tc.assertTrue(b.matches(true));
            tc.assertTrue(b.matches([true false]));
            tc.assertFalse(b.matches(1));
            tc.assertFalse(b.matches('str'));
            tc.assertFalse(b.matches(?logical));
        end;
        
        function test_NumberBetween_constructor(tc)
            import mmockito.matchers.*;
            
            NumberBetween(5,15);
            NumberBetween(-inf, 4);
            NumberBetween(0, intmax('uint16'));
            
            tc.assertError(@() NumberBetween(5, 'str'), 'mmockito:illegalMatcher');
        end;
        
        function test_NumberBetween_matches(tc)
            import mmockito.matchers.*;
            
            m = NumberBetween(3.5, intmax);
            
            tc.assertTrue(m.matches(4));
            tc.assertTrue(m.matches(5.72));
            tc.assertFalse(m.matches(1));
            tc.assertFalse(m.matches(1e100));
        end;
        
        function test_StringContaining_constructor(tc)
            import mmockito.matchers.*;
            
            StringContaining('asdf');
            StringContaining('T');
            
            tc.assertError(@() StringContaining(5), 'mmockito:illegalMatcher');
        end;
        
        function test_StringContaining_matches(tc)
            import mmockito.matchers.*;
            
            s = StringContaining('asD');
            
            tc.assertTrue(s.matches('asDfd'));
            tc.assertFalse(s.matches('asd'));
        end;
    end
    
end

