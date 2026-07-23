local PlantsClassFolder = script.Parent
local RootPlantsClass = require(PlantsClassFolder.RootPlantsClass)

export type Tank = {
    ["HP"]: number,
    ["Defense"]: number,
    ["Class"]: string,
    ["SunPrice"]: number,
    ["SpawnCooldown"]: number, 
    ["ModelName"]: string,
}

local TankClass = {}
setmetatable(TankClass, {__index = RootPlantsClass})
TankClass.__index = TankClass

function TankClass.new(SupportPlantStats: Tank): Tank  
    local self = RootPlantsClass.new(SupportPlantStats)
    setmetatable(self, TankClass)
    return self :: Tank
end

return TankClass