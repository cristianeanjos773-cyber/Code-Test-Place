--[[
NOTE: this is a module which'll be used to connect Models (PlantsModules, ZombieModules) to their OOP objects 
]]

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

function PVZObjectDataService.InsertAttributesInModel() 
    -- TODO: make the function go through a loop in the plant object making it connect all its stats to the model
end

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

function PVZObjectDataService.DisconnectOOP(OOPObjectKey: {}) 
    
    if not OOPObjectKey then 
        return
    end
    
    local OOPObject = PVZObjectDataService.GetObject(OOPObjectKey["ModelInstance"])
    
    if not OOPObject then 
        return
    end 

end 


return PVZObjectDataService