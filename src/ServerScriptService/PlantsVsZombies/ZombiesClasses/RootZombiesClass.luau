local PlantsVSZombiesFolder = script.Parent.Parent
local PVZWorkspaceFolder = workspace.PlantsVsZombies

local Services = PlantsVSZombiesFolder.Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage

local libs = ReplicatedStorageFolder.libs
local ServerSignals = require(libs.ServerSignals)
local OOPObjectDied = ServerSignals.OOPObjectDied

local ZombieGoal = PVZWorkspaceFolder.ZombieGoal :: Part 

local RootZombiesClass = {}

export type RootZombie = typeof(setmetatable({} :: {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["BiteDamage"]: number, 
    ["BiteCooldown"]: number,    
    ["ModelName"]: string, 
    ["Class"]: string,  
    },  
    RootZombiesClass
))

RootZombiesClass.__index = RootZombiesClass 

function RootZombiesClass.new(StatsTable: {[string]: string | number}): RootZombie
    
    if not StatsTable or typeof(StatsTable) ~= "table" then
        warn(`Stats table doesnt exist or is not a table, check the statstable argument, typeof: {StatsTable}`)
        return 
    end

    local self = setmetatable({}, RootZombiesClass) :: RootZombie 

    for PropertyName, PropertyValue in StatsTable do 
        self[PropertyName] = PropertyValue 
    end 

    print(self, StatsTable)
    return self :: RootZombie 

end 

function RootZombiesClass:OnPlantTouched(ZombieHumanoid: Humanoid) 

end 

function RootZombiesClass:WalkToHouse(ZombieModel: Model) 
    local self = self :: RootZombie
    local ZombieHumanoid = ZombieModel:WaitForChild("Humanoid") :: Humanoid
    local ZombieHumanoidRoot = ZombieModel:WaitForChild("HumanoidRootPart") :: Part
    warn(ZombieModel, ZombieHumanoid)
    ZombieHumanoid:MoveTo(ZombieGoal.Position)

    task.spawn(function() 

        while self:IsAlive() do 
            if (ZombieHumanoidRoot.Position - ZombieGoal.Position).Magnitude <= 2 then 
                break 
            end 
            ZombieHumanoid:MoveTo(ZombieGoal.Position)
            print("walk to loop")
            task.wait(5)
        end 

    end)

end 

function RootZombiesClass:IsAlive(): boolean  
    local self = self :: RootZombie
    local SelfHP = self["HP"] 

    if SelfHP > 0 then 
        return true
    else
        return false 
    end 

end 

function RootZombiesClass:TakeDamage(Damage: number) 
    local self = self :: RootZombie
    local SelfHP = self["HP"] 
    
    local FinalDamageResult = math.max(Damage - self["Defense"], 0)
    local FinalSelfHP = SelfHP - FinalDamageResult
    
    self["HP"] = FinalSelfHP
    
    if self["HP"] <= 0 then
        self:PlantDie() 
    end

end

function RootZombiesClass:ZombieDie() 
    local self = self :: RootZombie
    OOPObjectDied:Fire(self)
end 

function RootZombiesClass:HealZombie(HealAmount: number) 
    local self = self :: RootZombie
    self["HP"] = math.min(self["HP"] + HealAmount, self["MaxHP"])
end 

return RootZombiesClass