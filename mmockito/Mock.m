classdef Mock < handle
    %Mock allows verification and stubbing on itself
    %   Mock objects will record all method calls performed on them, so
    %   that they can later be verified, and can also stub methods to
    %   return canned answers. Inheriting from a real object and using
    %   argument matchers is also supported.
    %
    %   To stub a method, call the when method on a mock object:
    %
    %       mock.when.stubbedMethod(args).thenReturn(res)
    %
    %   * stubbedMethod can be anything other than "when" or "verify"
    %   * thenReturn statements can be chained, with the last one remaining
    %   valid
    %   * also supported are thenPass (shorthand for thenReturn(true)) and
    %   thenThrow(MException) to stub an exception
    %   * each then* statement can be followed by "times(n)" specifying the
    %   number of times the stubbed value should be returned. Example:
    %
    %       mock.when.method().thenPass().times(3).thenThrow(ME)
    %
    %
    %   To verify, call the verify method:
    %
    %       mock.verify.method(args)
    %
    %   * a VerificationError will be thrown if verification fails
    %   * it is possible to quantify the expectation by adding a keyword,
    %   one of: times(n), never(), atLeast(n) or atMost(n). Example:
    %
    %       mock.verify.method().atMost(3)
    %
    %   * verifyZeroInteractions is a special method, verifying the mock
    %   object wasn't interacted with at all. Example:
    %
    %       mock.verifyZeroInteractions
    %
    %   
    %   It is possible to use a Matcher instead of a constant argument both
    %   when verifying and stubbing. Commonly used matchers are Any and
    %   ArgThat (provides an interface to matlab.unittest.constraints).
    %   Matchers and constants can be combined freely. See also: Matcher 
    %   Example usage:
    %
    %       mock.when.method(true, Any(?char)).thenReturn('ok!')
    %
    %   
    %   Mocks can be tolerant and strict. Tolerant Mocks will silently pass
    %   even for methods unknown to them, while strict Mocks will throw an
    %   error. By default they are tolerant. The property can be set as an
    %   argument to the constructor, either the string 'tolerant' or
    %   'strict'. Example:
    %
    %       mock = Mock('strict')
    %
    %
    %   It is possible to mock real objects. In that case, methods which
    %   are not previously stubbed will be called on the real object. Mocks
    %   can still be strict or tolerant. To avoid possibly unexpected
    %   behaviour, it is recommended to always create these 'partial mocks'
    %   as strict. Example:
    %
    %       mock = Mock(RealClass, 'strict')
    
    % General design: mockery is a cell array of tuples:
    %       (Invocation, result, numberOfCalls)
    % where numberOfCalls is the amount of times a given call can be
    % matched (accepting inf for infinite).
    %
    % If we are mocking a real object, then realMocked is true and
    % mockedObj is the mocked objects' handle. 
    %
    % allInvocations is a cell array of tuples:
    %       (Invocation, invocationID)
    % excluding the .when and .verify calls. It is later used in
    % verification. invocationID is a unique identifier used for in order
    % verification.
    
    properties
        mockery = {};
        mockeryLength = 0;
        
        strict = false;

        mockedObj;
        realMocked = false;

        allInvocations = {};
    end
    
    methods
        function self = Mock(arg1, arg2)
            if nargin == 0
                return;
            end;

            % TODO: use inputParser here
            if nargin == 1
                if strcmp(arg1, 'strict')
                    self.strict = true;
                elseif strcmp(arg1, 'tolerant')
                    self.strict = false;
                elseif isobject(arg1)
                    self.mockedObj = arg1;
                    self.realMocked = true;
                end;
            elseif nargin == 2
                self.mockedObj = arg1;
                self.realMocked = true;
                self.strict = strcmp(arg2, 'strict');
            end;
        end;

        function varargout = subsref(obj, S)
            import mmockito.internal.*;
            persistent invID;

            if S(1).type ~= '.'
                ME = MException('mmockito:illegalCall', ...
                                'Must call a function on the mock object');
                throw(ME);
                % FIXME: this means arrays of mocks wouldn't work, there
                % must be a better way to have this check
                % Arrays also wouldn't work because substruct references
                % are hardcoded everywhere (ie. S(1).subs)
            end;

            if strcmp(S(1).subs, 'when')
                obj.when(S(2:end));
            elseif strcmp(S(1).subs, 'verify')
                obj.verify(S(2:end));
            elseif strcmp(S(1).subs, 'verifyZeroInteractions')
                obj.verifyZeroInteractions;
            else
                if length(S) > 1
                    % otherwise we get index exceeded errors due to the
                    % Invocation(S(1:2)) call

                    inv = Invocation(S(1:2));
                    obj.allInvocations{end + 1, 1} = inv;

                    if isempty(invID)
                        invID = 0;
                    end;
                    invID = invID + uint32(1);
                    obj.allInvocations{end, 2} = invID;

                    for i=1:obj.mockeryLength
                        if obj.mockery{i,3} > 0 && ...
                           obj.mockery{i,1}.matchedBy(inv)
                            res = obj.mockery{i,2}{1};
                            obj.mockery{i,3} = obj.mockery{i,3} - 1;
                            if isa(res, 'MException')
                                throw(res);
                            else
                                if length(obj.mockery{i,2}) > 1 && nargout ~= length(obj.mockery{i,2})
                                    ME = MException('mmockito:illegalCall',...
                                    'Expected number of output results must match the mocked call.');
                                    throw(ME);
                                else
                                    varargout = obj.mockery{i,2};
                                    return;
                                end;
                            end;
                        end;
                    end;
                end;

                % if subsref doesn't give us anything, throw an error only
                % if we are in 'strict' mode
                try
                    % FIXME: support multiple return args from builtin
                    if obj.realMocked == true
                        varargout{1} = builtin('subsref', obj.mockedObj, S);
                    else
                        varargout{1} = builtin('subsref', obj, S);
                    end;
                catch ME
                    if obj.strict
                        rethrow(ME)
                    else
                        % NOTE: we could also just pass silently
                        varargout = cell(1, nargout);
                    end;
                end;
            end;
        end;
        
        function when(self, S)
            % substruct('.','when',
            %           '.','asdf',
            %           '()',{[5]},
            %           '.', 'thenReturn',
            %           '()', {[6]})
            import mmockito.internal.*;

            invmatcher = InvocationPattern(Invocation(S(1:2)));

            % use index to handle multiple thenReturn statements
            ind = 3;
            % lastTimes is true if the last keyword was "times" -- it means
            % we shouldn't mock infinitely, only the given number of times
            lastTimes = false;
            while ind <= length(S)
                if strcmp(S(ind).subs, 'thenPass')
                    mockedValue = {true};
                elseif strcmp(S(ind).subs, 'thenReturn')
                    mockedValue = S(ind+1).subs;
                elseif strcmp(S(ind).subs, 'thenThrow')
                    if ~isa(S(ind+1).subs{1}, 'MException')
                        ME = MException('mmockito:illegalCall', ...
                        'Must use a MException object as argument to thenThrow.');
                        throw(ME);
                    end;
                    mockedValue = S(ind+1).subs;
                else
                    ME = MException('mmockito:illegalCall', ...
                    'After defining a function, must use either thenReturn, thenPass or thenThrow.');
                    throw(ME);
                end;

                ind = ind + 2;
                timesMocked = 1;
                lastTimes = false;
                % check for the "times" keyword
                if ind <= length(S) && strcmp(S(ind).subs, 'times')
                    timesMocked = S(ind+1).subs{1};
                    ind = ind + 2;
                    lastTimes = true;
                end;

                self.mockeryLength = self.mockeryLength + 1;
                self.mockery{self.mockeryLength, 1} = invmatcher;
                self.mockery{self.mockeryLength, 2} = mockedValue;
                self.mockery{self.mockeryLength, 3} = timesMocked;
            end;
            
            % the last result should be callable forever unless the keyword
            % chain ended with "times"
            if ~lastTimes
                self.mockery{self.mockeryLength, 3} = inf;
            end;
        end;

        function verify(self, S)
            import mmockito.internal.*;

            invmatcher = InvocationPattern(Invocation(S(1:2)));
            
            matchedCount = 0;
            for i=1:size(self.allInvocations, 1)
                if invmatcher.matchedBy(self.allInvocations{i,1})
                    matchedCount = matchedCount + 1;
                end;
            end;            
            
            if length(S) > 2
                timesExpected = cell2mat(S(4).subs);
                switch S(3).subs
                    case 'times'
                        if timesExpected == matchedCount
                            return;
                        end;
                    case 'never'
                        if matchedCount == 0
                            return
                        end;
                    case 'atLeast'
                        if matchedCount >= timesExpected
                            return;
                        end;
                    case 'atMost'
                        if matchedCount <= timesExpected
                            return;
                        end;
                    otherwise
                        ME = MException('mmockito:illegalCall', ...
                        'When verifying, the only accepted keywords are "times", "never", "atMost" or "atLeast".');
                        throw(ME);
                end;
            else
                % default is atLeast(1)
                if matchedCount >= 1
                    return;
                end;
            end;

            ME = VerificationError();
            throw(ME);
        end;
        
        function verifyZeroInteractions(self)
            import mmockito.internal.*;

            if size(self.allInvocations, 1) > 0
                ME = VerificationError();
                throw(ME);
            end;
        end;
                
    end
    
end

