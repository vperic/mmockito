classdef mock < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    % General design: we create some big (empty) structs to hold all the
    % data, which can be problematic. A cleaner solution would be to use
    % Map objects (so .mockery is a struct of Maps), but only strings
    % and/or single numbers can be keys in a map. Hence, we'd have to
    % represent everything as a string... worthwhile compromise? Would also
    % help with indexing strings. --> would lead to problems later with
    % matchers (probably; but maybe not, return the matcher as the value
    % and process it further).
    
    properties
        mockery = struct(); % struct of mocked objects
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
                answer = cell2mat(subsref(obj.mockery, S));
                % TODO: handle cells: cell2mat cannot handle cells nested
                % in cells; cellfun might help here
                % TODO: this processing should probably be moved to when
                % the values are added, so it's done only once
            elseif strcmp(S(1).subs, 'when')
                % substruct('.','when',
                %           '.','asdf',
                %           '()',{[5]},
                %           '.', 'thenReturn',
                %           '()', {[6]})
                % TODO: error checking
                % TODO: here, we can separate the case for thenReturn and
                % thenPass (do we really need this?)
                func_name = S(2).subs;
                if ~ismember(func_name, mockedFuctionNames)
                    % create new mock only if it doesn't already exist
                    obj.mockery.(func_name) = {};
                end;
                % we must defer to builtin for this to work
                obj.mockery.(func_name) = subsasgn(obj.mockery.(func_name), S(3), S(5).subs);
                
                % BIG TODO: the way this is designed, strings won't work:
                % they'll get translated to their int representation, and
                % then each char is considered separately and added to the
                % cell array
                
            elseif strcmp(S(1).subs, 'verify')
                % TODO: implement this
            else
                % TODO: error checking!
                answer = builtin('subsref', obj, S);
            end;
            
            
        end;
    end
    
end

