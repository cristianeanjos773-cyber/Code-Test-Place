local PlantsClassFolder = script.Parent
local RootPlantsClass = require(PlantsClassFolder.RootPlantsClass)

export type Shooter = {
    ["Damage"]: number,
    ["HP"]: number,
    ["ShootCooldown"]: number,
    ["Class"]: string,
    ["SunPrice"]: number,
    ["SpawnCooldown"]: number, 
    ["ModelName"]: string,
}

local ShooterClass = {}
setmetatable(ShooterClass, {__index = RootPlantsClass})
ShooterClass.__index = ShooterClass

function ShooterClass.new(SupportPlantStats: Shooter): Shooter  
    local self = RootPlantsClass.new(SupportPlantStats)
    setmetatable(self, ShooterClass)
    return self :: Shooter
end

return ShooterClass