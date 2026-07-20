--!strict 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PvZ = script.Parent

local PlantsClass = require(PvZ.PlantsClasses.RootPlantsClass)

local PlantsData = require(PvZ.PVZData.PlantsData)
local Remotes = ReplicatedStorage.Remotes

local RequestPlantSpawn = Remotes.RequestPlantSpawn :: RemoteEvent
local SpawnFailedWarning = Remotes.SpawnFailedWarning :: RemoteEvent

local PVZGameplayMainModule = {}

export type PlantsOwnerTable = {
    [Player]: Model 
}

export type PlayersInCooldownTable = {
    [Player]: {[string]: number}
}

PVZGameplayMainModule.PlantsOwners = {} :: PlantsOwnerTable 
PVZGameplayMainModule.PlayersInCooldown = {} :: PlayersInCooldownTable 

--[[TODO:
Today we should make a module exclusive for managing the player PVZ data instead of leaving in this module 
because of cyclic dependence
i should make functions, like a "PVZPlayerData.RemovePlrFromTable()" etc
]]

setmetatable(PVZGameplayMainModule.PlayersInCooldown, {__mode = "k"})
setmetatable(PVZGameplayMainModule.PlantsOwners, {__mode =  "vk"}) --[[
    As both ´plants and players are instances and so theyre strong refenrences, if we just use k or v as the mode, the garbage collector will refuse to delete some of them.
    if k, the GC will refuse to delete it if plant gets destroyed, because the value is a stroong refenrece, and the mode is k, so it will refuse to delete the key because it would ALSO destroy the value 
    if v, the GC will refuse to be delete it, EVEN if its gone 
    both would cause memory leaks
    the solution is to simply declare with setmetables that both the value and the key are weak, so the GC works.
]]

function PVZGameplayMainModule.ValidatePlantSpawnRequest(SpawnPart: Part) 
    
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

       -- local PlantModelName = PlantKey["ModelName"] :: string

        if not PVZGameplayMainModule.PlayersInCooldown[Player] then
            PVZGameplayMainModule.PlayersInCooldown[Player] = {}
        end

        local PlayerCooldownKey = PVZGameplayMainModule.PlayersInCooldown[Player]  
        local CooldownNumber = PlayerCooldownKey[PlantKey] or 0 :: number


        if PlayerCooldownKey[PlantRequested] and CurrentTime < CooldownNumber then
            local TimeLeft =  CooldownNumber - CurrentTime 
            local FormattedTime = string.format("%.1f", TimeLeft)
            local TextConfig = {
                ["TextString"] = `You need to wait more {FormattedTime} to be able to plant this plant!`, 
                ["TextColor"] = Color3.fromRGB(255, 0, 0)
            }
            SpawnFailedWarning:FireClient(Player, TextConfig)
            return -- Player is still on cooldown in this return
        end 
        PlantsClass:Spawn(Player, PlantRequested, SpawnPart)
    end)
end 



return PVZGameplayMainModule