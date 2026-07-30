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
        ["CanCollide"] = true, 
    },
}


local VisualHitboxesProperties = VisualHitboxService.HitboxProperties 

VisualHitboxService.HitboxFuncs = {
    
    ["PeashooterShoot"] = function(AttackName: string, HitboxCFrame: CFrame)
        local PeaPart = Instance.new("Part")
        local PropertiesTable = VisualHitboxesProperties[AttackName]
        PeaPart.Parent = workspace
        PeaPart.CFrame = HitboxCFrame
        PropertySetter(PeaPart, PropertiesTable) 
    end,

}

local HitboxFuncs = VisualHitboxService.HitboxFuncs 

function VisualHitboxService.SpawnVisualHitbox() 
    VisualHitboxRemote.OnClientEvent:Connect(function(AttackName: string, HitboxCFrame: CFrame)
        local HitboxFuncChosen = HitboxFuncs[AttackName]

        if not HitboxFuncChosen then
            return
        end 

        HitboxFuncChosen(AttackName, HitboxCFrame) 

    end)
end 

VisualHitboxService.SpawnVisualHitbox()

return VisualHitboxService 