--[[
NOTE: this is a module which'll be used to connect Models (PlantsModules, ZombieModules) to their OOP objects 
]]


local PVZFolder  = script.Parent.Parent
local PlantsClasses = PVZFolder.PlantsClasses
local OOPObjectFactory = require(PlantsClasses.OOPObjectFactory)

local PVZObjectDataService = {}

type ModelDictionary = {
    [Model]: any
}

type OOPDictionary = {
    [{}]: Model 
}

type ModelOOP = {
    Plants: ModelDictionary,
    Zombies: ModelDictionary,
}

type OOPModel = {
    Plants: OOPDictionary,
    Zombies: OOPDictionary 
}

PVZObjectDataService.ModelOOP = {
    ["Plants"] = {} :: ModelDictionary,
    ["Zombies"] = {} :: ModelDictionary, 
} :: ModelOOP

PVZObjectDataService.OOPModel = {
    ["Plants"] = {} :: OOPDictionary, 
    ["Zombies"] = {} :: OOPDictionary 
} :: OOPModel 

setmetatable(PVZObjectDataService.ModelOOP["Plants"], {__mode = "k"})
setmetatable(PVZObjectDataService.ModelOOP["Zombies"],  {__mode = "k"})
setmetatable(PVZObjectDataService.OOPModel["Plants"], {__mode = "k"})
setmetatable(PVZObjectDataService.OOPModel["Zombies"], {__mode = "k"})

function PVZObjectDataService.GetObject(Model: Model): {}?
    
    if Model:HasTag("Plant") then
        return PVZObjectDataService.ModelOOP.Plants[Model]
    elseif Model:HasTag("Zombie") then
        return PVZObjectDataService.ModelOOP.Zombies[Model]
    end

    return nil

end

function PVZObjectDataService.GetModel(OOPObject: {}): Model? 
    return OOPObject["ModelInstance"] :: Model?  
end

function PVZObjectDataService.ConnectOOPModel(OOPObjectModel: Model, ObjectOOPRequest: string) 

    if not OOPObjectModel:HasTag("Plant") and not OOPObjectModel:HasTag("Zombie") then
        return
    end

    local FuncToCall 
    local DictionaryToBePut: "Plants" | "Zombies"

    if OOPObjectModel:HasTag("Plant") then 
        FuncToCall = OOPObjectFactory.CreatePlantObject
        DictionaryToBePut = "Plants"
    else
        FuncToCall = OOPObjectFactory.CreateZombieObject
        DictionaryToBePut = "Zombies"
    end 

    local OOPObject = FuncToCall(ObjectOOPRequest)

    OOPObject["ModelInstance"] = OOPObjectModel

    PVZObjectDataService.ModelOOP[DictionaryToBePut][OOPObjectModel] = OOPObject -- THIS CONNECTS MODEL TO OOP 
    PVZObjectDataService.OOPModel[DictionaryToBePut][OOPObject] = OOPObjectModel -- THIS CONNECTS OOP OBJECT TO OOP
    OOPObject:Initialize() 

end

return PVZObjectDataService