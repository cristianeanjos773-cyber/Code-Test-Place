--[[
NOTE: this is a module which'll be used to connect Models (PlantsModules, ZombieModules) to their OOP objects 
]]


local PVZFolder  = script.Parent
local PlantsClasses = PVZFolder.PlantsClasses
local OOPObjectFactory = require(PlantsClasses.OOPObjectFactory)

local PVZObjectDataService = {}

type ModelDictionary = {
    [Model]: any
}

type ModelOOP = {
    Plants: ModelDictionary,
    Zombies: ModelDictionary,
}

PVZObjectDataService.ModelOOP = {
    ["Plants"] = {} :: ModelDictionary,
    ["Zombies"] = {} :: ModelDictionary, 
} :: ModelOOP

setmetatable(PVZObjectDataService.ModelOOP["Plants"], {__mode = "k"})
setmetatable(PVZObjectDataService.ModelOOP["Zombies"],  {__mode = "k"})


function PVZObjectDataService.GetObject(Model: Model)
    
    if Model:HasTag("Plant") then
        return PVZObjectDataService.ModelOOP.Plants[Model]
    elseif Model:HasTag("Zombie") then
        return PVZObjectDataService.ModelOOP.Zombies[Model]
    end

    return nil
    
end

function PVZObjectDataService.ConnectOOPModel(ObjectModel: Model, ObjectOOPRequest: string) 

    if not ObjectModel:HasTag("Plant") and not ObjectModel:HasTag("Zombie") then
        return
    end

    local FuncToCall 
    local DictionaryToBePut: "Plants" | "Zombies"

    if ObjectModel:HasTag("Plant") then 
        FuncToCall = OOPObjectFactory.CreatePlantObject
        DictionaryToBePut = "Plants"
    else
        FuncToCall = OOPObjectFactory.CreateZombieObject
        DictionaryToBePut = "Zombies"
    end 

    local ModelObject = FuncToCall(ObjectOOPRequest)
    PVZObjectDataService.ModelOOP[DictionaryToBePut][ObjectModel] = ModelObject 

end

return PVZObjectDataService