
local PlantsClassesData = {
    
    ["Shooter"] = {
       ["CanBePlacedInLine"] = false, 
    },

    ["Tank"] = {
        ["CanBePlacedInLine"] = true, 
    },

    ["Support"] = {
        ["CanBePlacedInLine"] = true, 
    },

}

return table.freeze(PlantsClassesData)