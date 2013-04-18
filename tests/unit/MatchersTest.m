classdef MatchersTest < matlab.unittest.TestCase
    %MatchersTest tests the behavior of Matchers
    %   Matchers are generally simple, we usually check the constructor
    %   error handling and the satisfiedBy method.
    
    properties
    end
    
    methods(Test)
        function test_ArgThat_constructor(tc)
            import matlab.unittest.constraints.*;
            
            ArgThat(HasSize([3 2]));
            tc.assertError(@() ArgThat(3), 'mmockito:illegalMatcher');
        end;
        
        function test_ArgThat_satisfiedBy(tc)
            import matlab.unittest.constraints.*;
            
            a = ArgThat(IsLessThan(4));
            
            tc.assertTrue(a.satisfiedBy(3));
            tc.assertFalse(a.satisfiedBy(5));
        end;
        
        function test_Any_constructor(tc)
            Any('double');
            Any(?char);
            Any();
            
            tc.assertError(@() Any(1,2), 'mmockito:illegalMatcher');
        end;
        
        function test_Any_satisfiedBy(tc)
            import matlab.unittest.constraints.*;
            
            a = Any();
            b = Any(?logical);
            
            tc.assertTrue(a.satisfiedBy(4));
            tc.assertTrue(a.satisfiedBy('str'));
            tc.assertTrue(a.satisfiedBy(cell(4,3)));
            
            tc.assertTrue(b.satisfiedBy(true));
            tc.assertTrue(b.satisfiedBy([true false]));
            tc.assertFalse(b.satisfiedBy(1));
            tc.assertFalse(b.satisfiedBy('str'));
            tc.assertFalse(b.satisfiedBy(?logical));
        end;
        
        function test_NumberBetween_constructor(tc)
            import mmockito.matchers.*;
            
            NumberBetween(5,15);
            NumberBetween(-inf, 4);
            NumberBetween(0, intmax('uint16'));
            
            tc.assertError(@() NumberBetween(5, 'str'), 'mmockito:illegalMatcher');
        end;
        
        function test_NumberBetween_satisfiedBy(tc)
            import mmockito.matchers.*;
            
            m = NumberBetween(3.5, intmax);
            
            tc.assertTrue(m.satisfiedBy(4));
            tc.assertTrue(m.satisfiedBy(5.72));
            tc.assertFalse(m.satisfiedBy(1));
            tc.assertFalse(m.satisfiedBy(1e100));
        end;
    end
    
end

