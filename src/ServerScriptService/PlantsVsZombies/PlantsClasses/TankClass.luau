--!strict 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlantsClassFolder = script.Parent
local RootPlantsClass = require(PlantsClassFolder.RootPlantsClass)

local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local libs = ReplicatedStorageFolder.libs

local ServerSignals = require(libs.ServerSignals)
local TankDamagedSignal = ServerSignals.TankDamaged

local TankClass = {}

setmetatable(TankClass, {__index = RootPlantsClass})
TankClass.__index = TankClass


type RootPlant = RootPlantsClass.RootPlant 

export type Tank = typeof(setmetatable({} :: RootPlant & {
    ["HP"]: number,
    ["Defense"]: number,
    ["Class"]: string,
    ["SunPrice"]: number,
    ["SpawnCooldown"]: number, 
    ["ModelName"]: string,
    ["ModelInstance"]: Model, 
    ["Initialize"]: (self: Tank) -> (),
    ["SpawnLifeGUI"]: (self: Tank) -> (),
},
TankClass
)) 


function TankClass:CreateLifeGUI(TankModel: Model) 
    local self = self :: Tank 
end 

function TankClass:ShrinkTank(TankModel: Model) end

function TankClass:SpawnLifeGUI() 
    local self = self :: Tank
    local TankModel = self["ModelInstance"]
end 

function TankClass.new(SupportPlantStats: Tank): Tank  
    local self = RootPlantsClass.new(SupportPlantStats) :: Tank
    setmetatable(self, TankClass)
    return self 
end

function TankClass:Initialize() 
    local self = self :: Tank
    
    TankDamagedSignal:Connect(function()
        local TankHP = self["HP"]
        self:SpawnLifeGUI()


    end)

end 

return TankClass