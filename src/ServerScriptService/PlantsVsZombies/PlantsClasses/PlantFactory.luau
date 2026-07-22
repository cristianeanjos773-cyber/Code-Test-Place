local PlantsClasses = script.Parent
local PVZFlder = PlantsClasses.Parent
local PVZData = PVZFlder.PVZData
local PlantsMainModule = require("../PlantsMainModule")
local PlantsData = require(PVZData.PlantsData)
local SupportClass = require(PlantsClasses.SupportClass)
local PlantFactory = {}

PlantFactory.ClassesToConstructors = {
    ["Support"] = SupportClass.new, 
}

function PlantFactory.CreatePlantObject(PlantName: string)
    local PlantStatus = PlantsData[PlantName]
    local PlantClassToConstruct = PlantsData[PlantName]["Class"]
    return PlantFactory.ClassesToConstructors[PlantClassToConstruct](PlantStatus)
end 

return PlantFactory 