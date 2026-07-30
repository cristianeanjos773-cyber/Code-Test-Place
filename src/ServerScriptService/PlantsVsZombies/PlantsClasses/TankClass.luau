--!strict 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlantsClassFolder = script.Parent
local RootPlantsClass = require(PlantsClassFolder.RootPlantsClass)

local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local libs = ReplicatedStorageFolder.libs
local GUIFolder = ReplicatedStorageFolder.GUI 

local ServerSignals = require(libs.ServerSignals)
local TankDamagedSignal = ServerSignals.TankDamaged

local TankClass = {}

setmetatable(TankClass, {__index = RootPlantsClass})
TankClass.__index = TankClass

type RootPlant = RootPlantsClass.RootPlant 

export type Tank = typeof(setmetatable({} :: RootPlant & {
    ["Phase1Scale"]: number,
    ["FinalPhaseScale"]: number, 
    ["ModelInstance"]: Model, 
    ["Initialize"]: (self: Tank) -> (),
    ["SpawnLifeGUI"]: (self: Tank) -> (),
    ["ShrinkTank"]: (self: Tank) -> (), 
    ["CreateLifeGUI"]: (self: Tank) -> (), 
},
TankClass
)) 

TankClass.TankShrinkageChanges = {
 
    ["Stage1"] = {
        ["EyesColor"] = Color3.fromRGB(0, 255, 234),
    },

    ["FinalStage"] = {
        ["EyesColor"] = Color3.fromRGB(255, 0, 0),
    },

}

-- SHRINKS THE TANK'S SIZE
function TankClass:ShrinkTank(TankModel: Model, ShrinkageNumber: number) 
    
    if not TankModel or not ShrinkageNumber then 
        return
    end
    
    local TankEye1 = TankModel:FindFirstChild("Eye1") :: MeshPart
    local TankEye2 = TankModel:FindFirstChild("Eye1") :: MeshPart


    if ShrinkageNumber == 0.7 then 
        TankEye1.Color = TankClass.TankShrinkageChanges["Stage1"]["EyesColor"]
        TankEye2.Color = TankClass.TankShrinkageChanges["Stage1"]["EyesColor"]
    else
        TankEye1.Color = TankClass.TankShrinkageChanges["FinalStage"]["EyesColor"]
        TankEye2.Color = TankClass.TankShrinkageChanges["FinalStage"]["EyesColor"]
    end

    TankModel:ScaleTo(ShrinkageNumber)

end

function TankClass.new(SupportPlantStats: Tank): Tank  
    local self = RootPlantsClass.new(SupportPlantStats) :: Tank
    setmetatable(self, TankClass)
    return self 
end

function TankClass:Initialize() 
    local self = self :: Tank

    local TankModel = self["ModelInstance"]
    local Phase1ModelScale = self["Phase1Scale"]
    local FinalModelPhaseScale = self["FinalPhaseScale"]
    local Stage1HP = 200
    local FinalStageHP = 100 

    TankModel:AddTag("ActiveTank") -- THIS TAG WILL BE USED FOR THE CLIENT TO USE TAGS AND MANAGE UI FOR THESE MODELS!
    TankModel:SetAttribute("HP", self["HP"])
    TankModel:SetAttribute("MaxHP", self["MaxHP"])

    TankDamagedSignal:Connect(function()
        local TankHP = self["HP"]
        self:SpawnLifeGUI()

        if Stage1HP >= TankHP then 
            TankClass:ShrinkTank(TankModel, Phase1ModelScale)
            elseif FinalStageHP >= TankHP then 
                TankClass:ShrinkTank(TankModel, FinalModelPhaseScale)
        end

    end)

end 

return TankClass