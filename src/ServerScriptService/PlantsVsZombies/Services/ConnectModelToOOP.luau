local PVZFolder  = script.Parent.Parent
local OOPFolder = PVZFolder.OOP
local OOPObjectFactory = require(OOPFolder.OOPObjectFactory)
local PVZObjectDataService = require(script.Parent.PVZObjectDataService)

--[[
Purpose: To connect OOP objects to their respective models.
"why is this here instead of being inside PVZObjectDataService?" due to Circular Modular Dependendancy. When we required this module inside of RootPlants
It tried requiring our PVZOBjectDataService, this previous module already called OOPObjectFactory. which calls SupportClass, ShooterClass and TankClass
Which are all modules that call rootplants, causing the circular dependency. 
"Why not just not stop requiring PVZObjectDataService inside of RootPlants?"
Beacuse when a plant dies we need to get its model through the function called .GetModel() in the PVZObjectDataService module. This is exactly why this function is separated
]]

local function ConnectModelToOOP(OOPObjectModel: Model, ObjectOOPRequest: string) 

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

return ConnectModelToOOP