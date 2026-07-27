--[[
NOTE: this is a module which'll be used to connect Models (PlantsModules, ZombieModules) to their OOP objects 
]]
--local Services = PVZFolder.Services 

local PVZFolder = script.Parent.Parent
local PlantsData = PVZFolder.PVZData
local OOPFolder = PVZFolder.OOP 
local PVZObjectData = require(PlantsData.PVZObjectData)
local OOPObjectFactory = require(OOPFolder.OOPObjectFactory)

export type Plant = OOPObjectFactory.ShooterClass & OOPObjectFactory.ShooterClass & OOPObjectFactory.TankClass
export type Zombie =  OOPObjectFactory.ClassicZombie 

local PVZObjectDataService = {}


function PVZObjectDataService.InsertAttributesInModel() 
    -- TODO: make the function go through a loop in the plant object making it connect all its stats to the model
end

function PVZObjectDataService.GetObject(Model: Model): Plant | Zombie?
    
    if Model:HasTag("Plant") then
        return PVZObjectData.ModelOOP.Plants[Model]
    elseif Model:HasTag("Zombie") then
        return PVZObjectData.ModelOOP.Zombies[Model]
    end

    return nil

end

function PVZObjectDataService.GetModel(OOPObject: {}): Model? 
    return OOPObject["ModelInstance"] :: Model?  
end

function PVZObjectDataService.DisconnectOOP(OOPObjectKey: {}) 
    
    if not OOPObjectKey then 
        return
    end
    
    local OOPObject = PVZObjectDataService.GetObject(OOPObjectKey["ModelInstance"])
    local OOPModel = PVZObjectDataService.GetModel(OOPObject)

    if not OOPObject then 
        return
    end 

    if not OOPModel then 
        return 
    end 

    OOPModel:Destroy()
    OOPObject = nil 

end 

function PVZObjectDataService.ConnectModelToOOP(OOPObjectModel: Model, ObjectOOPRequest: string) 

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

    PVZObjectData.ModelOOP[DictionaryToBePut][OOPObjectModel] = OOPObject -- THIS CONNECTS MODEL TO OOP 
    PVZObjectData.OOPModel[DictionaryToBePut][OOPObject] = OOPObjectModel -- THIS CONNECTS OOP OBJECT TO OOP

    task.spawn(function()
       OOPObject:Initialize() 
    end)

end 


return PVZObjectDataService