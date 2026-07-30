--!strict

--[[
Purpose: To create visual hitboxes
"Why not make it in the server?"
A:
The server should not have any responsability for making visual-only things, that is up to the client, using them in the server is
overloading the server
with no purpose (because we can put these in the Client.)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ReplicatedStorageFolder = ReplicatedStorage:WaitForChild("ReplicatedStorage")
local Utils = ReplicatedStorageFolder:WaitForChild("utils")
local PropertySetter = require(Utils:WaitForChild("PropertySetter"))
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes")
local VisualHitboxRemote = Remotes:WaitForChild("VisualHitboxRemote") :: RemoteEvent 



local VisualHitboxService = {}

VisualHitboxService.HitboxProperties = {
    ["PeashooterShoot"] = {
        ["Color"] = Color3.fromRGB(0, 255, 38),
        ["Name"] = "Pea",
        ["Size"] = Vector3.new(2, 2, 2), 
        ["Shape"] = Enum.PartType.Ball,
        ["Material"] = Enum.Material.Asphalt, 
        ["Anchored"] = true, 
        ["CanCollide"] = false, 
    },
}

VisualHitboxService.HitboxTweens = {

    ["PeashooterShoot"] = function(PeaPart: Part, tweenInfo: TweenInfo, propertyTable: {}): Tween
        return TweenService:Create(PeaPart, tweenInfo, propertyTable)
    end, 

}

local VisualHitboxesProperties = VisualHitboxService.HitboxProperties 
local HitboxTweens = VisualHitboxService.HitboxTweens

VisualHitboxService.HitboxFuncs = {
    
    ["PeashooterShoot"] = function(AttackName: string, HitboxCFrame: CFrame,  EndCFrame: CFrame)
        local PeaPart = Instance.new("Part")
        local PropertiesTable = VisualHitboxesProperties[AttackName]
        local PeaTweenInfo = TweenInfo.new(1) 
        
        local PeaTween = HitboxTweens[AttackName](PeaPart, PeaTweenInfo, {CFrame = EndCFrame}) :: Tween
        
        PeaPart.Parent = workspace
        PeaPart.CFrame = HitboxCFrame

        PeaTween:Play()
        PropertySetter(PeaPart, PropertiesTable)

        PeaTween.Completed:Connect(function()
            PeaTween:Destroy()
            PeaPart:Destroy()
            PeaPart = nil
            PeaPart = nil  
        end)

    end,

}

local HitboxFuncs = VisualHitboxService.HitboxFuncs 

function VisualHitboxService.SpawnVisualHitbox() 
    VisualHitboxRemote.OnClientEvent:Connect(function(AttackName: string, HitboxCFrame: CFrame, EndCFrame: CFrame)
        local HitboxFuncChosen = HitboxFuncs[AttackName]

        if not HitboxFuncChosen then
            return
        end 

        HitboxFuncChosen(AttackName, HitboxCFrame, EndCFrame) 

    end)
end 

VisualHitboxService.SpawnVisualHitbox()

return VisualHitboxService 