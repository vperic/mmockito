classdef mock < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    % General design: mockery is a cell array of pairs (Invocation, result)
    
    properties
        mockery = {};
        mockeryLength = 0;
    end
    
    methods
        function obj = mock
            obj;
        end;
        
        function answer = subsref(obj, S)
            if S(1).type ~= '.'
                ME = MException('mmockito:illegalCall', ...
                                'Must call a function on the mock object');
                throw(ME);
                % FIXME: this means arrays of mocks wouldn't work, there
                % must be a better way to have this check
                % Arrays also wouldn't work because substruct references
                % are hardcoded everywhere (ie. S(1).subs)
            end;
            
            % used for debugging
            if strcmp(S(1).subs, 'mockery')
                answer = builtin('subsref', obj, S);
                return;
            end;

            % FIXME: this is done every time and errors if S has a length
            % of 1. Either protect against this or handle it better. Other
            % than inspecting mockery directly, there's no actual use-case
            % where S isn't longer than 2.
            inv = Invocation(S(1:2));
            for i=1:obj.mockeryLength
                if obj.mockery{i,1}.matches(inv)
                    answer = obj.mockery{i,2}{1};
                    return;
                end;
            end;

            if strcmp(S(1).subs, 'when')
                % substruct('.','when',
                %           '.','asdf',
                %           '()',{[5]},
                %           '.', 'thenReturn',
                %           '()', {[6]})
                inv = Invocation(S(2:3));

                if strcmp(S(4).subs, 'thenPass')
                    mockedValue = {true};
                elseif strcmp(S(4).subs, 'thenReturn')
                    mockedValue = S(5).subs;
                else
                    ME = MException('mmockito:illegalCall', ...
                    'After defining a function, must use either thenReturn or thenPass.');
                    throw(ME);
                end;

                % we must defer to builtin for this to work
                obj.mockeryLength = obj.mockeryLength + 1;
                obj.mockery{obj.mockeryLength, 1} = inv;
                obj.mockery{obj.mockeryLength, 2} = mockedValue;
                
            elseif strcmp(S(1).subs, 'verify')
                % TODO: implement this
            else
                % TODO: error checking!
                answer = builtin('subsref', obj, S);
            end;
            
            
        end;
    end
    
end

