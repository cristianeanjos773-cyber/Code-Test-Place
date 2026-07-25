--!strict

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

local PVZObjectData = {}

PVZObjectData.ModelOOP = {
    ["Plants"] = {} :: ModelDictionary,
    ["Zombies"] = {} :: ModelDictionary, 
} :: ModelOOP

PVZObjectData.OOPModel = {
    ["Plants"] = {} :: OOPDictionary, 
    ["Zombies"] = {} :: OOPDictionary 
} :: OOPModel 

setmetatable(PVZObjectData.ModelOOP["Plants"], {__mode = "k"})
setmetatable(PVZObjectData.ModelOOP["Zombies"],  {__mode = "k"})
setmetatable(PVZObjectData.OOPModel["Plants"], {__mode = "k"})
setmetatable(PVZObjectData.OOPModel["Zombies"], {__mode = "k"})

return PVZObjectData