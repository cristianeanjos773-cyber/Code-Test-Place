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

local  ConnectModelToOOP = PVZObjectService.ConnectModelToOOP

local SpawnService = {}


function SpawnService.SetUpModel(ObjectModel: Model, SpawnPart: Part, TagString: string): Model  
    
    if not ObjectModel then
        warn("objectmodel argument not passed") 
        return 
    end

    local ObjModelClone = ObjectModel:Clone()
    local PlantsVsZombiesFolder = workspace:FindFirstChild("PlantsVsZombies") :: Folder
    local PlantsFolder = PlantsVsZombiesFolder:FindFirstChild("PlantsFolder") :: Folder

    ObjModelClone.Parent = PlantsFolder
    ObjModelClone:AddTag(TagString)  
    ObjModelClone:MoveTo(SpawnPart.Position)

    
    return ObjModelClone 

end

function SpawnService.FindObjectModel(ObjectRequested: string): Model | nil 
    local ObjectModel = ServerStorage.PlantsModels:FindFirstChild(ObjectRequested) or ServerStorage.ZombiesModels:FindFirstChild(ObjectRequested)   :: Model

    if not ObjectModel or not ObjectModel:IsA("Model") then
        warn(`either plantmodel doesnt exist or plantmodel or someone put a nommodel instance with the same name as of a normal plant model {ObjectModel.ClassName}`)
        return
    end 
                                
    return ObjectModel 

end

--ConnectModelToOOP



function SpawnService.SpawnObject(ObjectRequested: string, SpawnPart: Part, TagString: string): Model | nil 
    local ObjectModel = SpawnService.FindObjectModel(ObjectRequested) :: Model  
    local CloneModule = SpawnService.SetUpModel(ObjectModel, SpawnPart, TagString)
    --local Class
    --[[if CloneModule:HasTag("Plant") then 
        Class = PlantsDataModule[ObjectRequested]["Class"]
    else
        Class = ZombiesDataModule[ObjectRequested]["Class"]
    end ]]

    if not CloneModule:HasTag("Plant") and not CloneModule:HasTag("Zombie") then
        return
    end

    ConnectModelToOOP(CloneModule, ObjectRequested)
    
    return CloneModule  

end 

return SpawnService 