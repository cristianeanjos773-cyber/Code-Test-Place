--!strict 
local ServerScriptService = game:GetService("ServerScriptService")
local ServerScriptServiceFolder = ServerScriptService.ServerScriptService
local ServerStorage = game:GetService("ServerStorage")
local PlantsModelFolder = ServerStorage:FindFirstChild("PlantsModels") :: Folder 
local PlantsVsZombiesFolder = ServerScriptServiceFolder.PlantsVsZombies :: Folder
local PlantsDataFolder = PlantsVsZombiesFolder:FindFirstChild("PVZData") :: Folder

local PlantsClassesData = require(script.Parent.PlantsClassesData)
local PVZGameplayMainModule = require(PlantsVsZombiesFolder:FindFirstChild("PlantsMainModule"))
local PlantsData = require(PlantsDataFolder:FindFirstChild("PlantsData"))

local PlantsClass = {}
PlantsClass.__index = PlantsClass 

function PlantsClass.new(StatsTable: {[string]: string | number}) 
    
    if not StatsTable or typeof(StatsTable) ~= "table" then
        warn(`Stats table doesnt exist or is not a table, check the statstable argument, typeof: {StatsTable}`)
        return 
    end

    local self = setmetatable({}, PlantsClass)
    print(self, StatsTable)
    return self 

end 

function PlantsClass.IsAShooter(PlantName: string) : boolean
    local PlantClassName = PlantsData[PlantName]["Class"] :: string 
    
    if PlantsClassesData[PlantClassName]["CanBePlacedInLine"] then 
        return true 
    else
        return false
    end 

end

function PlantsClass:Spawn(Player: Player, Plant: string, SpawnPart: Part) 
    local PlayerInCooldownTable = PVZGameplayMainModule.PlayersInCooldown :: {[Player]: {[string]: number}}

    if not PlayerInCooldownTable[Player] then
        PlayerInCooldownTable[Player] = {}
    end

    local PlayerKey = PlayerInCooldownTable[Player] :: {}
    local SpawnPartSpawnFolder = SpawnPart.Parent :: Folder
    local IsAShooter = PlantsClass.IsAShooter(Plant) :: boolean 

    if not IsAShooter and SpawnPartSpawnFolder.Name == "ShootersSpawn" then 
        return  
    end
    
    if IsAShooter and SpawnPartSpawnFolder.Name == "NonShooterSpawns" then 
        return  
    end

    local PlantCooldownDuration = PlantsData[Plant]["SpawnCooldown"] :: number
    local PlantModel = PlantsModelFolder:FindFirstChild(Plant) :: Model

    if not PlantModel then 
        return
    end

    local PlantModelClone = PlantModel:Clone()
    local PlayerFinalCooldown = os.clock() + PlantCooldownDuration :: number -- that calculates the playercooldown final number, adding Current Time with The plant cooldown (ex: 30)

    PlayerKey[Plant] = PlayerFinalCooldown
    PlantModelClone.Parent = workspace  
    PlantModelClone:MoveTo(SpawnPart.Position)
    
end


return PlantsClass 