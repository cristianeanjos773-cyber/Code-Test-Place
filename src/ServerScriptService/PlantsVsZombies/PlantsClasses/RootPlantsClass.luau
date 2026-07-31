--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local HPBarUpdater = ReplicatedStorageFolder.Remotes.HPBarUpdater :: RemoteEvent


local libs = ReplicatedStorageFolder.libs

local ServerSignals = require(libs.ServerSignals)
local OOPObjectDied = ServerSignals.OOPObjectDied

local PlantsClass = {}

PlantsClass.__index = PlantsClass 

export type RootPlant = typeof(setmetatable({} :: {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["Defense"]: number,
    ["SpawnCooldown"]: number,
    ["ModelName"]: string,
    ["Name"]: string, 
    ["SunPrice"]: number,
    ["ZombieHumanoid"]: Humanoid,
    ["SpawnPart"]: Part, 
    ["IsAliveBool"]: boolean,  
    ["IsAlive"]: () -> (boolean),
    ["TakeDamage"]: (Damage: number) -> (),
    ["HealPlant"]: (HealAmount: number) -> (),  
    ["PlantDie"]: () -> ()
    },  
    PlantsClass
))

function PlantsClass.new(StatsTable: {[string]: string | number}): RootPlant  
    
    if not StatsTable or typeof(StatsTable) ~= "table" then
        warn(`Stats table doesnt exist or is not a table, check the statstable argument, typeof: {StatsTable}`)
        return 
    end

    local self = setmetatable({}, PlantsClass) :: RootPlant 

    for PropertyName, PropertyValue in StatsTable do 
        self[PropertyName] = PropertyValue 
    end 

    print(self, StatsTable)
    return self :: RootPlant 

end 

function PlantsClass:IsAlive(): boolean  
    local self = self :: RootPlant
    local PlantHP = self["HP"] 

    if PlantHP > 0 then 
        return true
    else
        return false 
    end 

end 

function PlantsClass:TakeDamage(Damage: number) 
    local self = self :: RootPlant
    local PlantHP = self["HP"] 
    local PlantMaxHP = self["MaxHP"]
    local PlantModel = self["ModelInstance"] 
    
    local FinalDamageResult = math.max(Damage - self["Defense"], 0)
    local FinalSelfHP = PlantHP - FinalDamageResult
    
    self["HP"] = FinalSelfHP

    HPBarUpdater:FireAllClients(PlantModel, PlantHP, PlantMaxHP)

    
    if self["HP"] <= 0 then
        self:PlantDie() 
    end

end

function PlantsClass:PlantDie() 
    local self = self :: RootPlant
    local PlantSpawnPart = self["SpawnPart"]

    warn("SPAWNPART", PlantSpawnPart, PlantSpawnPart:GetAttribute("Occupied"))

    self["IsAliveBool"]= false 

    if PlantSpawnPart:GetAttribute("Occupied") then 
        PlantSpawnPart:SetAttribute("Occupied", false)
        warn("SET TO FALSE???", PlantSpawnPart:GetAttribute("Occupied"))
    end 

    OOPObjectDied:Fire(self)

end 

function PlantsClass:HealPlant(HealAmount: number) 
    local self = self :: RootPlant
    self["HP"] = math.min(self["HP"] + HealAmount, self["MaxHP"])
end 

return PlantsClass 