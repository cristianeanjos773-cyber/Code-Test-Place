--!strict 
--[[
That'll be the code that will take care of plants with the class "Shooter", peashotooter, snow pea, etc" 
]]

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage 
local UpdateShooterAim =  ReplicatedStorageFolder.Remotes.UpdateShooterAim :: RemoteEvent 

local PlantsClassFolder = script.Parent
local PVZFolder = PlantsClassFolder.Parent
local Services = PVZFolder.Services

local PVZFolderWorkspace = workspace:FindFirstChild("PlantsVsZombies")
local ZombiesFolder = PVZFolderWorkspace:FindFirstChild("ZombiesFolder")

local RootPlantsClass = require(PlantsClassFolder.RootPlantsClass)
local ServerSignals = require(ReplicatedStorageFolder.libs.ServerSignals)

type RootPlant = RootPlantsClass.RootPlant 

local ShooterClass = {}

export type Shooter = typeof(setmetatable({} :: RootPlant & {
    ["Damage"]: number,
    ["HP"]: number,
    ["ShootCooldown"]: number,
    ["SunPrice"]: number,
    ["SpawnCooldown"]: number, 
    ["Range"]: number,
    ["Class"]: string,
    ["ModelName"]: string,
    ["AttackCloseZombie"]: string, 
    ["ProjectileName"]: string,  
    ["ModelInstance"]: Model,
    ["ClosestTarget"]: Model?, 
    ["FindClosestZombie"]: () -> (Model), 
    ["Initialize"]: (self: Shooter) -> (),
    ["RequestShootZombie"]: (self: Shooter) -> (), 
    ["SetUpPhyisicalProjectileProperties"]: () -> (), 
    ["CreatePhysicalProjectile"]: () -> (), 
},
ShooterClass 
))

setmetatable(ShooterClass, {__index = RootPlantsClass})
ShooterClass.__index = ShooterClass


function ShooterClass.new(ShooterPlantStats: {}): Shooter  
    local self = RootPlantsClass.new(ShooterPlantStats) :: Shooter 
    setmetatable(self, ShooterClass)
    return self :: Shooter
end

function ShooterClass:FindClosestZombie(): Model  
    local self = self :: Shooter 
    local ClosestZombie = nil 
    local ClosestDistance = math.huge
    local ShooterModel = self["ModelInstance"]
    local ShooterShootRange = self["Range"]
    local ZombiesArray = ZombiesFolder:GetChildren() :: {Model} 
    local ShooterHead = ShooterModel:FindFirstChild("Head") :: UnionOperation 

    self["ClosestTarget"] = nil 

    for _, ZombiesModels in ZombiesArray do 
        local ZombieHumanoidRootPart = ZombiesModels:FindFirstChild("HumanoidRootPart") :: Part 
        local ZombieDistance = (ZombieHumanoidRootPart.Position - ShooterHead.Position).Magnitude
        
        if not ZombieHumanoidRootPart then 
            continue 
        end

        if ZombieDistance <= ShooterShootRange and ZombieDistance < ClosestDistance then 
            ClosestDistance = ZombieDistance 
            ClosestZombie = ZombiesModels
            self["ClosestTarget"] = ClosestZombie
        end 

    end 
    return ClosestZombie  
end


local OOPAttackRequest = ServerSignals.OOPAttackRequest

function ShooterClass:RequestShootZombie(ClosestZombie: Model)
    local self = self :: Shooter 
    local AttackCloseZombie = self["AttackCloseZombie"]

    if not ClosestZombie or not ClosestZombie:IsA("Model") then 
        warn(`[ShooterClass]: ClosestZombie argument was either not passed or its type is not the one required\n {ClosestZombie.ClassName}`)
        return
    end 

    if not self then
        return -- this return is here because if the shooter dies some milisecs before the zombie kills it
        -- it would still request
    end

    OOPAttackRequest:Fire(self, AttackCloseZombie, ClosestZombie)

end 

function ShooterClass:Initialize() 
    local self = self :: Shooter
    local selfModel = self["ModelInstance"] 

    task.spawn(function()
  
        while true do
            
            if not self then 
                break 
            end

            local ClosestZombie = self:FindClosestZombie() 

            if ClosestZombie then
                self:RequestShootZombie(ClosestZombie)
                UpdateShooterAim:FireAllClients(selfModel, ClosestZombie)
            end 

            task.wait(0.5)

        end

    end)

end 

return ShooterClass