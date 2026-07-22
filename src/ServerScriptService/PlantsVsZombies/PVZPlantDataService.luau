local PVZFolder  = script.Parent
local PlantsClasses = PVZFolder.PlantsClasses
local PlantFactory = require(PlantsClasses.PlantFactory)

local PVZPlantDataService = {}

type ModelOOP = {
    [Model]: {}
}

PVZPlantDataService.ModelOOP = {} :: ModelOOP

setmetatable(PVZPlantDataService.ModelOOP, {__mode = "k"})

function PVZPlantDataService.ConnectOOPModel() 

end 

return PVZPlantDataService