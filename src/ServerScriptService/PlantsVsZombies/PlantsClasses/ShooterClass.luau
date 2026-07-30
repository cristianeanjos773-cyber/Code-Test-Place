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
    ["ProjectileName"]: string,  
    ["ModelInstance"]: Model,
    ["FindClosestZombie"]: () -> (Model), 
    ["Initialize"]: (self: Shooter) -> (),
    ["ShootZombie"]: (self: Shooter) -> (), 
    ["SetUpPhyisicalProjectileProperties"]: () -> (), 
    ["CreatePhysicalProjectile"]: () -> (), 
},
ShooterClass 
))

setmetatable(ShooterClass, {__index = RootPlantsClass})
ShooterClass.__index = ShooterClass

-- THIS Stores the properties of the physical pea
ShooterClass.ProjectProperties = table.freeze({
    ["Peashooter"] = {
        ["Name"] = "Pea", 
        ["Color"] = Color3.fromRGB(60, 255, 0),
        ["Size"] = Vector3.new(5, 5, 5 ),
        ["Material"] = Enum.Material.Concrete,
        ["CanCollide"] = true, 
        ["Anchored"] = true, 
    }
}) 

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

    for _, ZombiesModels in ZombiesArray do 
        local ZombieHumanoidRootPart = ZombiesModels:FindFirstChild("HumanoidRootPart") :: Part 
        local ZombieDistance = (ZombieHumanoidRootPart.Position - ShooterHead.Position).Magnitude
        
        if not ZombieHumanoidRootPart then 
            continue 
        end

        if ZombieDistance <= ShooterShootRange and ZombieDistance < ClosestDistance then 
            ClosestDistance = ZombieDistance 
            ClosestZombie = ZombiesModels
        end 

    end 
    return ClosestZombie  
end

function ShooterClass:SetUpPhyisicalProjectileProperties(ProjectilePart: Part) 
    local self = self :: Shooter 
    local ShooterName = self["Name"]

    for Properties, Values in ShooterClass.ProjectProperties[ShooterName] do 
        local PeaPartAsAny = ProjectilePart :: any 
        
        if PeaPartAsAny[Properties] == nil then 
            continue 
        end

        PeaPartAsAny[Properties] = Values
    end  

end 

function ShooterClass:CreatePhysicalProjectile() 
    local self = self :: Shooter 
    local ShooterName = self["Name"]
    local Projectile = Instance.new("Part")
    local ProjectileName = ShooterClass.ProjectProperties[ShooterName]

    Projectile.Name = ProjectileName 
    ShooterClass.SetUpPhyisicalProjectileProperties(self, Projectile)
    Debris:AddItem(Projectile, 25)

end 

local OOPAttackRequest = ServerSignals.OOPAttackRequest

function ShooterClass:RequestShootZombie(ClosestZombie: Model)
    local self = self :: Shooter 

    if not ClosestZombie or not ClosestZombie:IsA("Model") then 
        warn(`[ShooterClass]: ClosestZombie argument was either not passed or its type is not the one required\n {ClosestZombie.ClassName}`)
        return
    end 

    if not self then
        return -- this return is here because if the shooter dies some milisecs before the zombie kills it
        -- it would still request
    end

    OOPAttackRequest:Fire(ClosestZombie)

end 

function ShooterClass:Initialize() 
    local self = self :: Shooter
    local selfModel = self["ModelInstance"] 
    local ShootZombie = self:ShootZombie() 
    
    task.spawn(function()
  
        while true do
            
            if not self then 
                break 
            end

            local ClosestZombie = self:FindClosestZombie()
            UpdateShooterAim:FireAllClients(selfModel, ClosestZombie)

            if ClosestZombie then
                ShootZombie(ClosestZombie)
            end 

            task.wait()

        end

    end)

end 

return ShooterClass