local PlantsVSZombiesFolder = script.Parent.Parent
local PVZWorkspaceFolder = workspace.PlantsVsZombies

local Services = PlantsVSZombiesFolder.Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage

local libs = ReplicatedStorageFolder.libs
local Remotes = ReplicatedStorageFolder.Remotes 
local OOPDamagedRemote = Remotes.OOPObjectDamaged :: RemoteEvent 
local CombatData = require(PlantsVSZombiesFolder.PVZData.CombatData)
local ServerSignals = require(libs.ServerSignals)
local OOPObjectDied = ServerSignals.OOPObjectDied
local OOPAttackRequest = ServerSignals.OOPAttackRequest

local ZombieGoal = PVZWorkspaceFolder.ZombieGoal :: Part 

local ZombieActions = {
    ["Bite"] = "Bite",
}

local RootZombiesClass = {}

export type RootZombie = typeof(setmetatable({} :: {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["ModelName"]: string, 
    ["Class"]: string,  
    ["Name"]: string, 
    ["AttackClosePlant"]: string, 
    ["ModelInstance"]: Model,
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
        --warn("First attempt to check self: ", self)
    end 

    return self :: RootZombie 

end 


function RootZombiesClass:AttackPlant(ActionWhenTouched: string) 
   

    local self = self :: RootZombie 
    local ZombieModel = self["ModelInstance"]
    local ZombieHumanoid = ZombieModel:WaitForChild("Humanoid") :: Humanoid

    ZombieHumanoid.WalkSpeed = 0
    OOPAttackRequest:Fire(self, ActionWhenTouched)

end 

local PlantTag: string = "Plant"

function RootZombiesClass:WalkToHouse() 
    local self = self :: RootZombie
    local ZombieModel = self["ModelInstance"] 
    local ZombieOOPName = self["Name"]
    local AttackClosePlant = self["AttackClosePlant"] :: string
    local ZombieHumanoid = ZombieModel:WaitForChild("Humanoid") :: Humanoid
    local ZombieHumanoidRoot = ZombieModel:WaitForChild("HumanoidRootPart") :: Part

    ZombieHumanoid.WalkSpeed = 7 
    ZombieHumanoid:Move(Vector3.new(0,0,1))

    task.spawn(function() 

        while self:IsAlive() do 
            if (ZombieHumanoidRoot.Position - ZombieGoal.Position).Magnitude <= 2 then 
                break 
            end 
            ZombieHumanoid:Move(Vector3.new(0,0,1))
            task.wait(5)
        end 
    end)


    ZombieHumanoid.Touched:Connect(function(OtherPart: BasePart)
        local PlantModel = OtherPart.Parent :: Model? 

        if not PlantModel or not PlantModel:IsA("Model") then 
            return
        end
        
        if not PlantModel:HasTag(PlantTag) then 
            return
        end
        
        task.spawn(function()
            while true do -- THE OOPMODEL REPRESENTS THE PHYSICAL BODY OF THE OOP OBJECCT
                -- IF ITS DESTROYED, IT MEANS THAT  THE OOP IS **DEAD**
               
                if PlantModel == nil or PlantModel.Parent == nil then 
                    self:WalkToHouse()
                    break 
                end  

                self:AttackPlant(AttackClosePlant)
                task.wait(3)

            end 
        end)

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
    local ZombieHP = self["HP"] 
    local ZombieModel = self["ModelInstance"]
    local ZombieHumanoidRootPart = ZombieModel:FindFirstChild("HumanoidRootPart") :: Part
    local ZombieRootPos = ZombieHumanoidRootPart.Position

    local FinalDamageResult = math.max(Damage - self["Defense"], 0)
    local FinalSelfHP = ZombieHP - FinalDamageResult
    
    self["HP"] = FinalSelfHP
    OOPDamagedRemote:FireAllClients(ZombieRootPos, ZombieHP, FinalDamageResult, "BillboardGui")

    if not self:IsAlive() then
        self:ZombieDie() 
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