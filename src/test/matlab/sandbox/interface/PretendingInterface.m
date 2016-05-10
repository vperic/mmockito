classdef PretendingInterface < handle
    
    properties
        ifaceMetaclass
    end
    
    methods
        function obj = PretendingInterface(ifaceMetaclass)
            obj.ifaceMetaclass = ifaceMetaclass; 
        end
        
        function res = isa(obj, class)
            if strcmp(obj.ifaceMetaclass.Name, class) == 1,
                res = true;
            else
                res = builtin('isa',obj, class);
            end
        end
    end
end
        