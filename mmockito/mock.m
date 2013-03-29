classdef mock < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    % General design: converting arguments to a string is not particularly
    % robust and might involve a major performance penalty. Is there
    % another way of indexing? Probably need a helper function to handle
    % the conversion of arbitrary objects to strings.
    
    properties
        mockery = struct(); % struct of Maps, one for each mocked function
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
            
            mockedFuctionNames = fieldnames(obj.mockery);
            
            if ismember(S(1).subs, mockedFuctionNames)
                func_name = S(1).subs;
                stringKey = char(cell2mat(S(2).subs));
                answer = obj.mockery.(func_name)(stringKey);

            elseif strcmp(S(1).subs, 'when')
                % substruct('.','when',
                %           '.','asdf',
                %           '()',{[5]},
                %           '.', 'thenReturn',
                %           '()', {[6]})
                % TODO: error checking

                func_name = S(2).subs;
                if ~ismember(func_name, mockedFuctionNames)
                    % create new mock only if it doesn't already exist
                    obj.mockery.(func_name) = containers.Map;
                end;

                if strcmp(S(4).subs, 'thenPass')
                    mockedValue = true;
                elseif strcmp(S(4).subs, 'thenReturn')
                    % check if we were passed a cell of cells
                    % necessary as cell2mat doesn't work on nested cells,
                    % and we want to strip away one level of "cell"
                    % FIXME: if nested cells are different dizes, this
                    % doesn't work correctly
                    if iscell(S(5).subs{1})
                        mockedValue = cellfun(@cell2mat, S(5).subs, 'UniformOutput', false);
                    else
                        mockedValue = cell2mat(S(5).subs);
                    end;
                else
                    ME = MException('mmockito:illegalCall', ...
                    'After defining a function, must use either thenReturn or thenPass.');
                    throw(ME);
                end;

                % we must defer to builtin for this to work
                % TODO: use whole substruct, not just the subs (else we'd
                % treat cells and arrays the same) --> needs more tests!
                % TODO more tests in general, how does cell2mat behave?
                stringKey = char(cell2mat(S(3).subs));
                obj.mockery.(func_name)(stringKey) = mockedValue;
                
            elseif strcmp(S(1).subs, 'verify')
                % TODO: implement this
            else
                % TODO: error checking!
                answer = builtin('subsref', obj, S);
            end;
            
            
        end;
    end
    
end

