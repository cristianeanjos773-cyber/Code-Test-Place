--!strict 

--[[
Purpose: Check, Initialize and spawn zombie classes AND their Models. 
]]

local Services = script.Parent
local PVZFolder = Services.Parent
local OOPFolder = PVZFolder.OOP

local PVZWorskpaceFolder = workspace.PlantsVsZombies


local SpawnService = require(Services.SpawnService)
local CooldownService = require(Services.CooldownService)
local OOPObjectFactory = require(OOPFolder.OOPObjectFactory)
local PVZObjectDataService = require(Services.PVZObjectDataService)

local ZombieSpawns = PVZWorskpaceFolder.ZombieSpawns :: Folder 

local ZombieSpawnsArray = ZombieSpawns:GetChildren() :: {Part}

local IsCooldownOn = CooldownService.IsCooldownOn
local SpawnObject = SpawnService.SpawnObject
local CreateZombieObject = OOPObjectFactory.CreateZombieObject

local ZombieTagString = "Zombie"
local GameString = "Game" -- these strings are put here to reduce the chances of typos 
local SpawnZombieAction = "SpawnZombie"

local ZOMBIESPAWNTIME = 15 

local ZombieSpawnService = {}

ZombieSpawnService.RandomZombieNames = {
    "BucketHeadZombie",
    "ClassicZombie",
    "ConeHeadZombie", 
} -- This array'll be used to randomize the ZombieFinding in the .FindModule function  


local RandomZombieNames = ZombieSpawnService.RandomZombieNames 

function ZombieSpawnService.SpawnRandomZombie() 
    

    if IsCooldownOn(GameString, SpawnZombieAction) then 
        return 
    end 

    local RandomSpawnNumber = math.random(1, #ZombieSpawnsArray)
    local RandomNameNumber = math.random(1, #RandomZombieNames)
    local ChosenZombieName = RandomZombieNames[RandomNameNumber] :: string 
    local RandomZombierSpawnPart = ZombieSpawnService[RandomSpawnNumber]

    local Humanoid = Instance.new("Humanoid")
    local ZombieObject = CreateZombieObject(ChosenZombieName) 
    local ZombieModel = SpawnObject(ChosenZombieName, RandomZombierSpawnPart, ZombieTagString) :: Model 
    
    Humanoid.Parent = ZombieModel
    ZombieObject:Initialize() 
    CooldownService.StartCooldown(GameString, SpawnZombieAction, ZOMBIESPAWNTIME) 

    --[[TODO: find a way to make zombies spawn]]
    

end 

return ZombieSpawnService