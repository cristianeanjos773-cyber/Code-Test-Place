local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local SSSFolder = ServerScriptService.ServerScriptService

local PVZFolder = SSSFolder.PlantsVsZombies
local PVZDataFolder = PVZFolder.PVZData
local PlantsDataModule = require(PVZDataFolder.PlantsData)
local ZombiesDataModule = require(PVZDataFolder.ZombiesData)
local PVZObjectDataService =  require(PVZFolder.PVZObjectDataService)

local SpawnService = {}


function SpawnService.SetUpModel(ObjectModel: Model, SpawnPart: Part) 
    
    if not ObjectModel then
        warn("objectmodel argument not passed") 
        return 
    end
    
    local ObjModelClone = ObjectModel:Clone()
    local PlantsVsZombiesFolder = workspace:FindFirstChild("PlantsVsZombies") :: Folder
    local PlantsFolder = PlantsVsZombiesFolder:FindFirstChild("PlantsFolder") :: Folder

    ObjModelClone.Parent = PlantsFolder  
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


function SpawnService.SpawnObject(ObjectRequested: string, SpawnPart: Part) 
    local ObjectModel = SpawnService.FindObjectModel(ObjectRequested)
    local Class

    if not ObjectModel:HasTag("Plant") and not ObjectModel:HasTag("Zombie") then
        return
    end

    if ObjectModel:HasTag("Plant") then 
        Class = PlantsDataModule[ObjectRequested]["Class"]
    else
        Class = ZombiesDataModule[ObjectRequested]["Class"]
    end 

    local CloneModule = SpawnService.SetUpModel(ObjectModel, SpawnPart)
    PVZObjectDataService.ConnectOOPModel(CloneModule, Class)
    
end 

return SpawnService 