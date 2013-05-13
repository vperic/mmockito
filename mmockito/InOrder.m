classdef InOrder < handle
    %InOrder is a special-case Mock-like object supporting verification.
    %   In order verification is a special case compared to standard
    %   verification, and needs to work even over multiple Mock objects. It
    %   is constructed with the interesting mocks as arguments, after the
    %   expected interactions are performed; internal data is then used to
    %   collate all Invocations into one, in order, list. Not all
    %   interactions need to be verified.
    
    %   We use invID from each individual mock to ensure correct ordering. 
    %   Once the list of all Invocations is created, it is passed through
    %   sequentially for each verification requested; a variable is used to
    %   note the current "position". The variable never decreases --- if it
    %   surpasses the number of Invocations, then in order verification
    %   failed.
    %
    %   allInvocations is a tuple of:
    %           (mock, Invocation, InvocationID)
    %   where mock is a reference to a mock object. 
    
    properties
        allInvocations = {};
        
        currentPos = 0;
    end
    
    methods
        function self = InOrder(varargin)
            if nargin == 0
                ME = MException('mmockito:illegalInOrder', ...
                'Must construct InOrder object with at least one Mock.');
                throw(ME);
            end;
            
            for i=1:nargin
                mock = varargin{i};
                % have to access like this, else a tolerant mock will
                % consider the call to allInvocations a separate function
                allMockInvs = mock.allInvocations;

                for j=1:size(allMockInvs, 1)
                    newRow = {mock allMockInvs{j,1} allMockInvs{j,2}};
                    self.allInvocations = [self.allInvocations; newRow];
                end;
                
                self.allInvocations = sortrows(self.allInvocations, 3);
            end;
        end;
        
        function answer = subsref(self, S)
            if strcmp(S(1).subs, 'verify')
                self.verify(S(2:end));
            elseif strcmp(S(1).subs, 'verifyNoMoreInteractions')
                self.verifyNoMoreInteractions();
            else
                answer = builtin('subsref', self, S);
            end;
        end;
        
        function verify(self, S)
            import mmockito.internal.*;
            
            % TODO: error-handling, more than one mock, no mocks etc.
            mock = S(1).subs{1};
            invmatcher = InvocationMatcher(Invocation(S(2:3)));
            
            for i = self.currentPos+1:size(self.allInvocations, 1)
                self.currentPos = self.currentPos + 1;
                if invmatcher.matches(self.allInvocations{i,2}) && ...
                   self.allInvocations{i, 1} == mock
                    return;
                end;
            end;
            
            ME = VerificationError();
            throw(ME);            
        end;
        
        function verifyNoMoreInteractions(self)
            if self.currentPos < size(self.allInvocations,1)
                ME = VerificationError();
                throw(ME);
            end;
        end;
    end
    
end

