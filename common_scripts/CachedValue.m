classdef CachedValue < handle
    %Stores the most recently calculated value and whether it is up-to-date
    %   Note that this is a handle class because of the model of an
    %   internal state being changed my mutators
    %
    % ---------------------------------------------------------------------
    % Examples
    % ---------------------------------------------------------------------
    %
    % %Create uninitialized
    % >> cv = CachedValue    
    %     
    % cv = 
    % 
    %   CachedValue handle
    % 
    %   Properties:
    %     is_updated: 0
    %         value: []
    %         exists: 0
    % 
    %   Methods, Events, Superclasses
    % 
    %
    % % Create and update 
    % >> cv = CachedValue; cv.update_to(1234); cv
    % 
    % cv = 
    % 
    %   CachedValue handle
    % 
    %   Properties:
    %     is_updated: 1
    %          value: 1234
    %         exists: 1
    % 
    %   Methods, Events, Superclasses
    %
    %         
    % % Create, update, and invalidate
    % >> cv = CachedValue; cv.update_to(1234); cv.invalidate; cv
    % 
    % cv = 
    % 
    %   CachedValue handle
    % 
    %   Properties:
    %     is_updated: 0
    %          value: 1234
    %         exists: 1
    % 
    %   Methods, Events, Superclasses
    %
    %
    % % Create, update, and delete
    % >> cv = CachedValue; cv.update_to(1234); cv.update_to([]); cv
    % 
    % cv = 
    % 
    %   CachedValue handle
    % 
    %   Properties:
    %     is_updated: 0
    %          value: []
    %         exists: 0
    % 
    %   Methods, Events, Superclasses
    %
    %
    properties (SetAccess=private)
        %True if the stored value exists and is up-to-date. 
        %False otherwise.
        is_updated
        
        %Either a single value or [] (if no value has been calculated).
        value
    end
    
    properties (Dependent)
        %True if the value has been calculated
        exists
    end
    
    methods
        function obj=CachedValue()
        %Create an empty CachedValue object
            obj.is_updated = 0;
            obj.value = [];
        end
        
        function update_to(obj, value)
        %Sets obj.value to value and is_updated to true.  Special case: value==[] means is_updated=0.
        %
            obj.value = value;
            obj.is_updated = ~isempty(value);
            if length(value) > 1
                error('CachedValue objects can hold at most one value.');
            end
        end
        
        function invalidate(obj)
        %Marks the currently stored value as not up-to-date
            obj.is_updated = 0;
        end
        
        function exists=get.exists(obj)
        %Calculate exists
            exists = ~isempty(obj.value);
        end
    end
    
end

