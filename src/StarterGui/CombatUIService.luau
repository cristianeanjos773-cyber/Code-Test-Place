--!strict

--[[
Purpose: To take care of creating UIs
]]


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGUIScripts = script.Parent
local SFXService = require(StarterGUIScripts:WaitForChild("SFXService"))
local GameSFXs = require(StarterGUIScripts:WaitForChild("GameSFXs"))

local ReplicatedStorageFolder = ReplicatedStorage:WaitForChild("ReplicatedStorage")
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes")
local OOPObjectDamaged = Remotes:WaitForChild("OOPObjectDamaged") :: RemoteEvent 
local UIPartTweenInfo = TweenInfo.new(0.5)

local CombatUIService = {}

function CombatUIService.TweenPart(UIPart: Part) 
    local UIPartYResult = UIPart.Position.Y + 10 
    local UIPartGoalTween = {Position = Vector3.new(UIPart.Position.X, UIPartYResult, UIPart.Position.Z)}
    local UIPartTween = TweenService:Create(UIPart, UIPartTweenInfo, UIPartGoalTween)

    UIPartTween:Play()

    UIPartTween.Completed:Connect(function()
        UIPartTween:Destroy()
        UIPart:Destroy()
        UIPart = nil 
        UIPartTween = nil 
    end)

end 

function CombatUIService.SetUIPartsProperties(UIPart: Part) 
    UIPart.Anchored = true
    UIPart.CanCollide = false 
    UIPart.Transparency = 1
    UIPart.Size = Vector3.new(3, 3, 3)
    UIPart.Name = "UIPart"
    CombatUIService.TweenPart(UIPart)
end 

function CombatUIService.SetTextProperties(DamageLabel: TextLabel, Damage: number) 
    DamageLabel.Font = Enum.Font.Arcade
    DamageLabel.Text = tostring(Damage)
    DamageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    DamageLabel.Size = UDim2.fromScale(1, 1)
    DamageLabel.BackgroundTransparency = 1 
    DamageLabel.TextScaled = true 
end 

CombatUIService.UITypes = table.freeze({
    
    ["BillboardGui"] = function(PartPosition: Vector3, Damage: number, AttackName: string): BillboardGui 
        local BillBoardGui = Instance.new("BillboardGui")
        local Frame =  Instance.new("Frame")
        local UIPart = Instance.new("Part")
        local DamageLabel = Instance.new("TextLabel")
        local SoundID = GameSFXs[AttackName] 

        UIPart.Position = PartPosition
        UIPart.Parent = workspace 

        BillBoardGui.Parent = UIPart  
        BillBoardGui.Size = UDim2.fromScale(5, 5)

        Frame.Parent = BillBoardGui 
        Frame.BackgroundTransparency = 1 
        Frame.Size = UDim2.fromScale(1, 1) 
        
        DamageLabel.Parent = Frame
     
        local DamageSoundProperties = {
            ["Parent"] = UIPart, 
            ["Name"] = "DamageSound", 
            ["SoundId"] = SoundID,
        }

        local DamageSound = SFXService.SpawnSFX(DamageSoundProperties)

        DamageSound:Play()

        --warn("IsDamageSoundPlaying?", DamageSound.IsPlaying, DamageSound.Parent)

        CombatUIService.SetUIPartsProperties(UIPart)
        CombatUIService.SetTextProperties(DamageLabel, Damage)
        
        --warn(BillBoardGui, BillBoardGui.Parent, DamageLabel.Text, "print debug billboardgui")
        return BillBoardGui 
    end,

    ["SurfaceGui"] = function(PartPosition: Vector3, Damage: number): SurfaceGui 
        local SurfaceGui = Instance.new("SurfaceGui")
        local Frame = Instance.new("Frame")
        local UIPart = Instance.new("Part")

        UIPart.Position = PartPosition
        Frame.Parent = SurfaceGui
        CombatUIService.SetUIPartsProperties(UIPart)
        
        Frame.Parent = SurfaceGui 
        SurfaceGui.Parent = UIPart  
        return SurfaceGui 
    end, 

})

function CombatUIService.SpawnUI() 
    OOPObjectDamaged.OnClientEvent:Connect(function(ZombieRootPos: Vector3, ObjectHP: number, ObjectDamage: number, UIString: string, AttackName: string)

        if not ZombieRootPos then 
            return
        end
        
        if not ObjectHP or not ObjectDamage then
            return
        end

        local ChosenUIfunc = CombatUIService.UITypes["BillboardGui"]

        if not ChosenUIfunc then
            return
        end

        ChosenUIfunc(ZombieRootPos, ObjectDamage, AttackName)

    end)
end 

CombatUIService.SpawnUI()

return CombatUIService