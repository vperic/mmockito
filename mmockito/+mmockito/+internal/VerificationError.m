classdef VerificationError < MException
    %VerificationError is thrown if a verification fails.
    
    properties
    end
    
    methods
        function me = VerificationError()
            me = me@MException('mmockito:VerificationError', ...
                'Verification failure.');
        end;
    end
    
end

