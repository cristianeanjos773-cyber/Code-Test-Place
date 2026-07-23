--!strict 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage 
local PvZ = script.Parent

local SunPlayerService = require(PvZ.Services.SunPlayerService)
local SpawnService = require(PvZ.Services.SpawnService)
local PlantsClass = require(PvZ.PlantsClasses.RootPlantsClass)
local OOPObjectFactory = require(PvZ.PlantsClasses.OOPObjectFactory)
local PlantsData = require(PvZ.PVZData.PlantsData)
local CooldownService = require(PvZ.Services.CooldownService)
local PlantsClassesData = require(script.Parent.PlantsClasses.PlantsClassesData)
local Remotes = ReplicatedStorageFolder.Remotes 
local RequestPlantSpawn = Remotes.RequestPlantSpawn :: RemoteEvent
local SpawnFailedWarning = Remotes.SpawnFailedWarning :: RemoteEvent
local PlantsMainModule = {}
 

function PlantsMainModule.ReturnObjectClass(PlantName: string): string 
    local PlantClassName = PlantsData[PlantName]["Class"] :: string 
    return PlantClassName
end 


function PlantsMainModule.ValidateSun(Player: Player, PlantRequested): boolean  
    local PlantKey = PlantsData[PlantRequested] :: {[string]: string | number}
    local leaderstats = Player:FindFirstChild("leaderstats") :: Folder
    local PlayerSuns = leaderstats:FindFirstChild("Suns") :: IntValue
    local PlantPrice = PlantKey["SunPrice"] :: number 
    
    if  PlayerSuns.Value >= PlantPrice then 
        return true
    else
        return false   
    end

end 


function PlantsMainModule.SpawnPlant(Player: Player, PlantRequested: string, SpawnPart: Part) 
   
    local CheckClass = PlantsMainModule.ReturnObjectClass(PlantRequested)
    local SpawnPartFolderName = SpawnPart.Parent.Name  
    local FailString = `You can't place Plants from class: {CheckClass} on {SpawnPartFolderName} parts!`

    local IsCooldownOn = CooldownService.IsCooldownOn(Player, PlantRequested) :: boolean 
    local PlayerCooldown = CooldownService.ObjectsInCooldown[Player][PlantRequested] :: number
    
    local FormattedTime =  string.format("%.1f", PlayerCooldown)
    local CooldownFaileString = `You should wait more {FormattedTime} to plant {PlantRequested}!`

    local HasEnoughSuns = PlantsMainModule.ValidateSun(Player, PlantRequested)
    local PlantCooldown = PlantsData[PlantRequested]["SpawnCooldown"] :: number 
    local SunCost = PlantsData[PlantRequested]["SunPrice"] :: number 
    local TagString = "Plant"


    if CheckClass == "Shooter" and SpawnPartFolderName == "NonShooterSpawns" then 
        SpawnFailedWarning:FireClient(Player, {["Text"] = FailString, ["Color"] = Color3.fromRGB(255, 0, 0)})
        warn("FIRST COND")
        return 
    end 

    if CheckClass ~= "Shooter" and SpawnPartFolderName == "ShootersSpawn" then 
        SpawnFailedWarning:FireClient(Player, {["Text"] = FailString, ["Color"] = Color3.fromRGB(255, 0, 0)})
        warn("SECOND COND")
        return 
    end 

    if IsCooldownOn then 
        SpawnFailedWarning:FireClient(Player, {["Text"] = CooldownFaileString, ["Color"] = Color3.fromRGB(255, 0, 0)})
        warn("FAILED BECAUSE PLAYER IS ON COOLDOWN")
        return
    end
   
    if not HasEnoughSuns then
        return
    end

    SpawnService.SpawnObject(PlantRequested, SpawnPart, TagString)
    CooldownService.StartCooldown(Player, PlantRequested, PlantCooldown)
    warn(CooldownService.ObjectsInCooldown)
    SunPlayerService.ManagePlayerSuns(Player, -SunCost)

end



function PlantsMainModule.RequestPlantSpawn(SpawnPart: Part) 
    
    if not SpawnPart or not SpawnPart:IsA("Part") then
        return
    end

    RequestPlantSpawn.OnServerEvent:Connect(function(Player: Player, PlantRequested: string)
        PlantsMainModule.SpawnPlant(Player, PlantRequested, SpawnPart)
    end)

end 

return PlantsMainModule