--[[
Purpose: take care of each Object's states and allow states to change and validate them. 
also to store thesee states. 
]]

local PVZMachineStatesService = {}

PVZMachineStatesService.ZombieStates = {
    ["NULL"] = 0, 
    ["Walking"] = 1,
    ["Idle"] = 2,
    ["EatingPlants"] = 3, 
}

PVZMachineStatesService.ZombieStatesEnumKey = {
    [1] = "NULL",
    [2] = "Walking",
    [3] = "Idle",
    [4] = "EatingPlant",
}

function PVZMachineStatesService.RequestStateChange(StateRequsted: string) 

end

--TODO: Finish this module. 

return PVZMachineStatesService