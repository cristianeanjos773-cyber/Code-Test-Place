local PlantsClasses = script.Parent
local PVZFlder = PlantsClasses.Parent
local PVZData = PVZFlder.PVZData
local PlantsData = require(PVZData.PlantsData)
local ZombiesData = require(PVZData.ZombiesData)
local SupportClass = require(PlantsClasses.SupportClass)
local OOPObjectFactory = {}

OOPObjectFactory.ClassesToConstructors = {
    
    ["PlantConstructors"] = {
        ["Support"] = SupportClass.new, 
    },
    
    ["ZombieConstructors"] = {
        
    }

}

function OOPObjectFactory.CreatePlantObject(PlantName: string)
    local PlantStatus = PlantsData[PlantName]
    local PlantClassToConstruct = PlantsData[PlantName]["Class"]
    return OOPObjectFactory.ClassesToConstructors["PlantConstructors"][PlantClassToConstruct](PlantStatus)
end


function OOPObjectFactory.CreateZombieObject(ZombieName: string)
    local ZombieStatus = ZombiesData[ZombieName]
    local ZombieClassToConstruct = ZombiesData[ZombieName]["Class"]
    return OOPObjectFactory.ClassesToConstructors["ZombieConstructors"][ZombieClassToConstruct](ZombieStatus)
end


return OOPObjectFactory 