classdef whenTest < matlab.unittest.TestCase
    %whenTest Tests basic behaviour of when keyword to mocks
    %   There are two basic forms we need to check:
    %       mock.when.func(arg).thenPass()
    %
    %   where arg can be empty, or a numerical, char, struct or cell type.
    %   Success means a logical true is returned.
    %
    %       mock.when.func(arg).thenReturn(result)
    %
    %   where arg can again be empty, or one of the basic data types. 
    %   result is one of the basic types.
    %
    %       mock.when.func(args).thenReturn(result)
    %
    %   an extension of the second form, we permit multiple arguments. 

    %   Generally, all basic data types are tested in all combinations;
    %   special care is given to cells, which can be tricky. In the
    %   multiple argument case, only pairs are checked, which should
    %   provide enough coverage for all usecases.
    % 
    %   TODO: add several more complicated uses to acceptance tests.
    
    properties
    end
    
    methods (Test)
        function test_noArg_returnSuccess(testCase)
            m = Mock();
            m.when.aFunc().thenPass();
            
            testCase.assertTrue(m.aFunc());
        end;
        
        %%% Single argument -> returnSuccess
        
        function test_numArg_returnSuccess(testCase)
            m = Mock();
            arg = 2.5;
            m.when.aFunc(arg).thenPass();
            
            testCase.assertTrue(m.aFunc(arg));
        end;
        
        function test_charArg_returnSuccess(testCase)
            m = Mock();
            arg = 'arg';
            m.when.aFunc(arg).thenPass();
            
            testCase.assertTrue(m.aFunc(arg));
        end;
        
        function test_structArg_returnSuccess(testCase)
            m = Mock();
            arg = struct('a', 5, 'b', 6);
            m.when.aFunc(arg).thenPass();
            
            testCase.assertTrue(m.aFunc(arg));
        end;
        
        function test_cellArg_returnSuccess(testCase)
            m = Mock();
            arg = {5};
            m.when.aFunc(arg).thenPass();
            
            testCase.assertTrue(m.aFunc(arg));
        end;        
        
        %%% Single argument -> return result
        
        % num, char and struct types basically behave the same, always test
        % with strings
        
        function test_numArg_returnChar(testCase)
            m = Mock();
            arg = 2.5;
            res = 'result';
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;
        
        function test_charArg_returnChar(testCase)
            m = Mock();
            arg = 'arg';
            res = 'result';
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;        
        
        function test_structArg_returnChar(testCase)
            m = Mock();
            arg = struct('a', 5, 'b', 6);
            res = 'result';
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;
        
        function test_cellArg_returnChar(testCase)
            m = Mock();
            arg = {2};
            res = 'result';
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;       
        
        % Cells are trickier, test them separately.
        
        function test_numArg_returnCell(testCase)
            m = Mock();
            arg = 2.5;
            res = {'result cell'};
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;        
        
        function test_charArg_returnCell(testCase)
            m = Mock();
            arg = 'arg';
            res = {'result cell'};
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;        
        
        function test_structArg_returnCell(testCase)
            m = Mock();
            arg = struct('a', 5, 'b', 6);
            res = {'result cell'};
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;
        
        function test_cellArg_returnCell(testCase)
            m = Mock();
            arg = {2};
            res = {'result cell'};
            m.when.aFunc(arg).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg), res);
        end;    
        
        %%% Two arguments -> return result
        
        % Only test for string results.
        
        function test_numnumArg_returnChar(testCase)
            m = Mock();
            arg1 = 2.5;
            arg2 = 3;
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;
        
        function test_numcharArg_returnChar(testCase)
            m = Mock();
            arg1 = 2.5;
            arg2 = 'arg';
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;        
        
        function test_numstructArg_returnChar(testCase)
            m = Mock();
            arg1 = 2.5;
            arg2 = struct('a', 5, 'b', 6);
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;        
        
        function test_numcellArg_returnChar(testCase)
            m = Mock();
            arg1 = 2.5;
            arg2 = {3};
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;        
        
        function test_charcharArg_returnChar(testCase)
            m = Mock();
            arg1 = '2b';
            arg2 = '333';
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;        
        
        function test_charstructArg_returnChar(testCase)
            m = Mock();
            arg1 = '2';
            arg2 = struct('a', 3);
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;                
        
        function test_charcellArg_returnChar(testCase)
            m = Mock();
            arg1 = '2';
            arg2 = {'3'};
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;          
        
        function test_structstructArg_returnChar(testCase)
            m = Mock();
            arg1 = struct('a','2');
            arg2 = struct('b','3');
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;                
        
        function test_structcellArg_returnChar(testCase)
            m = Mock();
            arg1 = struct('a','2');
            arg2 = {'a', '3'};
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;        

        function test_cellcellArg_returnChar(testCase)
            m = Mock();
            arg1 = {'a','2'};
            arg2 = {'b','3'};
            res = 'result';
            m.when.aFunc(arg1, arg2).thenReturn(res);
            
            testCase.assertEqual(m.aFunc(arg1, arg2), res);
        end;                        

        %%% Possible to mock multiple return values of a function
        % XXX: move this to a separate class?
        
        function test_multipleCalls(testCase)
            m = Mock();
            arg1 = 2.5;
            arg2 = 17;
            res1 = 'good';
            res2 = 'better';
            m.when.aFunc(arg1).thenReturn(res1);
            m.when.aFunc(arg2).thenReturn(res2);

            testCase.assertEqual(m.aFunc(arg1), res1);
            testCase.assertEqual(m.aFunc(arg2), res2);
        end;
        
        %%% Test that not just the first arguments are used
        
        function test_sameFirstArgument_differentReturns(tc)
            m = Mock();
            arg1 = 3;
            arg2 = 'joy';
            arg3 = 'radost';
            m.when.aFunc(arg1, arg2).thenReturn(5);
            m.when.aFunc(arg1, arg3).thenReturn(6);

            tc.assertNotEqual(m.aFunc(arg1, arg2), m.aFunc(arg1, arg3));
        end;
        
        function test_sameFirstSecondArguments_differentReturns(tc)
            m = Mock();
            arg1 = 2;
            arg2 = 3;
            arg31 = 4;
            arg32 = 5;
            m.when.aFunc(arg1, arg2, arg31).thenReturn(13);
            m.when.aFunc(arg1, arg2, arg32).thenReturn(31);

            tc.assertNotEqual(m.aFunc(arg1, arg2, arg31), m.aFunc(arg1, arg2, arg32));
        end;
    end
    
end

