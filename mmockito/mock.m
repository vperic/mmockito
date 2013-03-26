classdef mock < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mockery = struct(); % struct of mocked objects
    end
    
    methods
        function obj = mock
            obj;
        end;
        
        function answer = subsref(obj, S)
%             for i=1:length(S)
%                 S(i)
%             end;
            % TODO: error checking etc
            if S(1).type ~= '.'
                ME = MException('mmockito:illegalCall', ...
                                'Must call a function on the mock object');
                throw(ME);
            end;
            
            if strcmp(S(1).subs, 'when')
                % substruct('.','when',
                %           '.','asdf',
                %           '()',{[5]},
                %           '.', 'thenReturn',
                %           '()', {[6]})
                % TODO: error checking
                func_name = S(2).subs;
                % we must defer to builtin for this to work
                obj.mockery.(func_name) = {}; 
                obj.mockery.(func_name) = subsasgn(obj.mockery.(func_name), S(3), S(5).subs);
                
            elseif strcmp(S(1).subs, 'verify')
                % TODO: implement this
            else
                % TODO: error checking!
                %answer = subsref(obj.mockery, S);
                answer = builtin('subsref', obj, S);
            end;
            
            
        end;
    end
    
end

