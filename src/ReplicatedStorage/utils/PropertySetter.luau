--[[
Purpose: this is an util function created because in many parts of the project we repeated setting up the instance properties with for loop, but now we automatize this 
]]

function PropertySetter(Instance, PropertiesTable: {}) 
    for Properties, Values in PropertiesTable do 
        
        if not Instance[Properties] then
            continue
        end

        Instance[Properties] = Values 

    end 
end 

return PropertySetter 