--!strict 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage :: Folder 
local PvZ = script.Parent

local PlantsClass = require(PvZ.PlantsClasses.RootPlantsClass)
local PlantFactory = require(PvZ.PlantsClasses.PlantFactory)
local PlantsData = require(PvZ.PVZData.PlantsData)
local CooldownService = require(PvZ.Services.CooldownService)
local Remotes = ReplicatedStorageFolder.Remotes 
local RequestPlantSpawn = Remotes.RequestPlantSpawn :: RemoteEvent
local SpawnFailedWarning = Remotes.SpawnFailedWarning :: RemoteEvent

local PlantsMainModule = {}

function PlantsMainModule.SpawnPlant() 

end 

function PlantsMainModule.CheckClass(): boolean 
    
end 

function PlantsMainModule.ValidatePlantSpawnRequest(SpawnPart: Part) 
    
    if not SpawnPart or not SpawnPart:IsA("Part") then
        return
    end

    RequestPlantSpawn.OnServerEvent:Connect(function(Player: Player, PlantRequested: string)
        local PlantKey = PlantsData[PlantRequested] :: {[string]: string | number}
        local leaderstats = Player:FindFirstChild("leaderstats") :: Folder
        local PlayerSuns = leaderstats:FindFirstChild("Suns") :: IntValue
        local PlantPrice = PlantKey["SunPrice"] :: number 
        
        local CurrentTime = os.clock()

        if PlantPrice > PlayerSuns.Value then 
            return  
        end

        if not CooldownService.ObjectsInCooldown[Player] then
            CooldownService.ObjectsInCooldown[Player] = {}
        end

        local PlayerCooldownKey = CooldownService.ObjectsInCooldown[Player]  

        warn("TYPEOF", typeof(PlantRequested))
        if CooldownService.IsCooldownOn(Player, PlantRequested) then
            local TimeLeft =  PlayerCooldownKey[PlantRequested] - CurrentTime 
            local FormattedTime = string.format("%.1f", TimeLeft)
            local TextConfig = {
                ["TextString"] = `You need to wait more {FormattedTime} to be able to plant this plant!`, 
                ["TextColor"] = Color3.fromRGB(255, 0, 0)
            }
            SpawnFailedWarning:FireClient(Player, TextConfig)
            return
        end
        PlantsClass:Spawn(Player, PlantRequested, SpawnPart)
    end)
end 

--[[TODO:
Colocar toda a logica de plantsclass:Spawn() nesse modulo de forma segura, separando as responsabilidades por funçao e melhorando esse codigo. 
]]

return PlantsMainModule