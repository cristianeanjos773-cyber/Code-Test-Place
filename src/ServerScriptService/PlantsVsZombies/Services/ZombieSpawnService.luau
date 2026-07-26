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

local GetRemainingCooldown = CooldownService.GetRemainingCooldown

local ZombieSpawns = PVZWorskpaceFolder.ZombieSpawns :: Folder 
local ZombieSpawnsArray = ZombieSpawns:GetChildren() :: {Part}

local IsCooldownOn = CooldownService.IsCooldownOn
local SpawnObject = SpawnService.SpawnObject
local CreateZombieObject = OOPObjectFactory.CreateZombieObject

local StartCooldown = CooldownService.StartCooldown

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
    
    local ZombieSpawnsArrayElementNumber = #ZombieSpawnsArray
    local RandomZombieNamesElementsNumber = #RandomZombieNames

    
   task.spawn(function() 
       while workspace:GetAttribute("WAVESTARTED") do 
            local RandomSpawnNumber = math.random(1, ZombieSpawnsArrayElementNumber)
            local RandomNameNumber = math.random(1, RandomZombieNamesElementsNumber)
            local ChosenZombieName = RandomZombieNames[RandomNameNumber] :: string
            local RandomZombieSpawnPart = ZombieSpawnsArray[RandomSpawnNumber] :: Part 
            local RemainingCooldown = GetRemainingCooldown(GameString, SpawnZombieAction)

            if RemainingCooldown > 0 then 
                print("DDDDDDDD",RemainingCooldown)
                task.wait(RemainingCooldown)
            end

            if not IsCooldownOn(GameString, SpawnZombieAction) then 
               CreateZombieObject(ChosenZombieName) 
               SpawnObject(ChosenZombieName, RandomZombieSpawnPart, ZombieTagString)
               StartCooldown(GameString, SpawnZombieAction, ZOMBIESPAWNTIME) 
            end

            warn("DEADLY LOOP RUNNING")
            task.wait() --[[Why is  a task.wait() here if we have remaining cooldown above? 
                Beucase the cooldown starts at 0, if we dont make this task,wait(), the game would crash. 
                the task.wait() above is to make the while true do not waste resources when its unnecessary, we wait for around the remaining time. 
            ]]
        
        end 
    end)
    

end 

return ZombieSpawnService