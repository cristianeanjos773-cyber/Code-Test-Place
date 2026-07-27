--!strict 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage 
local PvZ = script.Parent

local SunPlayerService = require(PvZ.Services.SunPlayerService)
local SpawnService = require(PvZ.Services.SpawnService)
local PlantsData = require(PvZ.PVZData.PlantsData)

local CooldownService = require(PvZ.Services.CooldownService)
local Remotes = ReplicatedStorageFolder.Remotes 

local RequestPlantSpawn = Remotes.RequestPlantSpawn :: RemoteEvent
local SpawnFailedWarning = Remotes.SpawnFailedWarning :: RemoteEvent

local Services = PvZ.Services 
local ZombieSpawnService = require(Services.ZombieSpawnService)

local SpawnRandomZombie = ZombieSpawnService.SpawnRandomZombie 

local GameplayMainModule = {}
 

function GameplayMainModule.ReturnObjectClass(PlantName: string): string 
    local PlantClassName = PlantsData[PlantName]["Class"] :: string 
    return PlantClassName
end 


function GameplayMainModule.ValidateSun(Player: Player, PlantRequested): boolean  
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

local PlantString = "Plant"

function GameplayMainModule.SpawnPlant(Player: Player, PlantRequested: string, SpawnPart: Part) 
   
    local CheckClass = GameplayMainModule.ReturnObjectClass(PlantRequested)
    local SpawnPartFolderName = SpawnPart.Parent.Name  
    local FailString = `You can't place Plants from class: {CheckClass} on {SpawnPartFolderName} parts!`

    local IsCooldownOn = CooldownService.IsCooldownOn(Player, PlantRequested) :: boolean 
    local PlayerCooldown = CooldownService.ObjectsInCooldown[Player][PlantRequested] :: number
    
    local FormattedTime =  string.format("%.1f", PlayerCooldown)
    local CooldownFaileString = `You should wait more {FormattedTime} to plant {PlantRequested}!`

    local HasEnoughSuns = GameplayMainModule.ValidateSun(Player, PlantRequested)
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

    if not workspace:GetAttribute("WAVESTARTED") then 
        workspace:SetAttribute("WAVESTARTED", true) 
    end 

    SunPlayerService.ManagePlayerSuns(Player, -SunCost)
    CooldownService.StartCooldown(Player, PlantRequested, PlantCooldown)
    SpawnService.SpawnObject(PlantRequested, SpawnPart, PlantString)
    GameplayMainModule.SpawnZombies()

end


function GameplayMainModule.RequestPlantSpawn(SpawnPart: Part) 
    
    if not SpawnPart or not SpawnPart:IsA("Part") then
        return
    end

    RequestPlantSpawn.OnServerEvent:Connect(function(Player: Player, PlantRequested: string)
        GameplayMainModule.SpawnPlant(Player, PlantRequested, SpawnPart)
    end)

end 

function GameplayMainModule.SpawnZombies()
    local WAVESTARTED = workspace:GetAttribute("WAVESTARTED") :: boolean 
  
    if not WAVESTARTED then 
        return
    end 

    SpawnRandomZombie()

end 

return GameplayMainModule