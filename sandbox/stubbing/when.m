classdef when
    %WHEN Summary of this class goes here
    %   Detailed explanation goes here

    properties
    end

    methods
        function obj = when(mock)
            % constructor
            mock.when
        end;

        function answer = subsref(obj, S)
            disp('This is what the when class sees:');
            for i=1:length(S)
                S(i)
            end;
            
            % the actual class would probably have an empty constructor and
            % then just forward the call to subsref to the mock object.
        end;
    end

end
