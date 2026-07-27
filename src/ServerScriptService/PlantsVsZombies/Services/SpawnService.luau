--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local SSSFolder = ServerScriptService.ServerScriptService

local PVZFolder = SSSFolder.PlantsVsZombies
local PVZDataFolder = PVZFolder.PVZData

local PlantsDataModule = require(PVZDataFolder.PlantsData)
local ZombiesDataModule = require(PVZDataFolder.ZombiesData)
local PVZObjectService = require(PVZFolder.Services.PVZObjectDataService)
local ObjectDataService = require(PVZFolder.Services.PVZObjectDataService) 
local PlantsVsZombiesFolder = workspace:FindFirstChild("PlantsVsZombies") :: Folder

local PlantsFolder = PlantsVsZombiesFolder:FindFirstChild("PlantsFolder") 
local ZombiesFolder = PlantsVsZombiesFolder:FindFirstChild("ZombiesFolder")

local PlantsModelsFolder = ServerStorage.PlantsModels
local ZombiesModelsFolder = ServerStorage.ZombiesModels 


local ConnectModelToOOP = PVZObjectService.ConnectModelToOOP

local SpawnService = {}



function SpawnService.SetUpModel(ObjectModel: Model, SpawnPart: Part, TagString: string): Model | nil 
    
    if not ObjectModel or not ObjectModel:IsA("Model") then
        warn("objectmodel argument not passed") 
        return 
    end

    if not SpawnPart or not SpawnPart:IsA("Part") then
        warn(`[SpawnService]: Err in SpawnPart: {SpawnPart} \n Type of ObjectRequested: {typeof(SpawnPart)}`) 
        return 
    end

    if not SpawnPart or typeof(TagString) ~= "string" then
        warn(`[SpawnService]: Err in TagString: {TagString} \n Type of TagString: {typeof(TagString)}`) 
        return 
    end

    local ObjModelClone = ObjectModel:Clone()
   
    local ObjModelCloneParent


    if TagString == "Plant" then 
        ObjModelCloneParent = PlantsFolder 
    else 
        ObjModelCloneParent = ZombiesFolder 
    end 

    ObjModelClone.Parent = ObjModelCloneParent
    ObjModelClone:AddTag(TagString)  
    ObjModelClone:MoveTo(SpawnPart.Position)

    return ObjModelClone :: Model 

end

function SpawnService.FindObjectModel(ObjectRequested: string): Model | nil 

    if not ObjectRequested then 
        warn(`[SpawnService]: Err in ObjectRequestedParam: {ObjectRequested} \n Type of ObjectRequested: {typeof(ObjectRequested)}`)
        return 
    end 

    local ObjectModel =  PlantsModelsFolder:FindFirstChild(ObjectRequested) or ZombiesModelsFolder:FindFirstChild(ObjectRequested) :: Model
    
    if not ObjectModel or not ObjectModel:IsA("Model") then
        warn(`either plantmodel doesnt exist or plantmodel or someone put a nommodel instance with the same name as of a normal plant model {ObjectModel.ClassName}`)
        return
    end 
                                
    return ObjectModel 

end


function SpawnService.SpawnObject(ObjectRequested: string, SpawnPart: Part, TagString: string): Model | nil 
    
    if not ObjectRequested or typeof(ObjectRequested) ~= "string" then
        warn(`[SpawnService]: Err in ObjectRequestedParam: {ObjectRequested} \n Type of ObjectRequested: {typeof(ObjectRequested)}`) 
        return 
    end

    if not SpawnPart or not SpawnPart:IsA("Part") then
        warn(`[SpawnService]: Err in SpawnPart: {SpawnPart} \n Type of ObjectRequested: {typeof(SpawnPart)}`) 
        return 
    end

    if not SpawnPart or typeof(TagString) ~= "string" then
        warn(`[SpawnService]: Err in TagString: {TagString} \n Type of TagString: {typeof(TagString)}`) 
        return 
    end

    
    local ObjectModel = SpawnService.FindObjectModel(ObjectRequested) :: Model  

    if not ObjectModel or not ObjectModel:IsA("Model") then 
        print(`[SpawnService]: Err in TagString: {ObjectModel} \n Type of TagString: {typeof(ObjectModel)}`)
        return 
    end 

    local CloneModule = SpawnService.SetUpModel(ObjectModel, SpawnPart, TagString) 

    if not CloneModule or not CloneModule:IsA("Model") then 
        print(`[SpawnService]: Err in TagString: {CloneModule} \n Type of TagString: {typeof(CloneModule)}`)
        return 
    end 
    
    --local Class
    --[[if CloneModule:HasTag("Plant") then 
        Class = PlantsDataModule[ObjectRequested]["Class"]
    else
        Class = ZombiesDataModule[ObjectRequested]["Class"]
    end ]]

    if not CloneModule:HasTag("Plant") and not CloneModule:HasTag("Zombie") then
        warn("[SpawnService]: not found tags.")
        return
    end

    ConnectModelToOOP(CloneModule, ObjectRequested)
    return CloneModule  

end 

return SpawnService 