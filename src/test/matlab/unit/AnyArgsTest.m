classdef AnyArgsTest < matlab.unittest.TestCase
    %AnyArgsTest tests the behavior of the AnyArgs matcher
    %   As AnyArgs is somewhat of a special case, it needs to be tested
    %   more carefully: it's implementation is actually hidden in
    %   InvocationPattern.
    
    methods(Test)
        function test_AnyArgs_single(tc)
            m = Mock();
            m.when.stub(AnyArgs()).thenReturn('ok');
            
            tc.assertEqual(m.stub(), 'ok');
            tc.assertEqual(m.stub(1), 'ok');
            tc.assertEqual(m.stub(2, 5, 'asdf'), 'ok');
        end;
        
        function test_AnyArgs_withOtherArguments(tc)
            m = Mock('strict');
            m.when.stub(1, AnyArgs()).thenReturn('ok');
            
            tc.assertEqual(m.stub(1), 'ok');
            tc.assertEqual(m.stub(1, 2), 'ok');
            tc.assertEqual(m.stub(1, 2, 'asdf'), 'ok');
            
            tc.assertError(@() m.stub(), ?MException);
            tc.assertError(@() m.stub(2, 2), ?MException);
        end;
        
        function test_AnyArgs_notLastArgument(tc)
            m = Mock();
            
            tc.assertError(@()...
                m.when.stub(AnyArgs(), 1), 'mmockito:illegalMatcher');
        end;
          
    end
end