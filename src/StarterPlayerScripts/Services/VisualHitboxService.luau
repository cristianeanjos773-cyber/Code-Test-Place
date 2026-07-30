local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage:WaitForChild("ReplicatedStorage")
local Utils = ReplicatedStorageFolder:WaitForChild("utils")
local PropertySetter = Utils:WaitForChild("PropertySetter")
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes")
local VisualHitboxRemote = Remotes:WaitForChild("VisualHitboxRemote") :: RemoteEvent 


local VisualHitboxService = {}

VisualHitboxService.HitboxProperties = {
    ["PeashooterShoot"] = {
        ["Color"] = Color3.fromRGB(0, 255, 38),
        ["Name"] = "Pea",
        ["Size"] = Vector3.new(3, 3, 3), 
        ["Anchored"] = true, 
        ["CanCollide"] = true, 
    }
}


local VisualHitboxesProperties = VisualHitboxService.HitboxProperties 

VisualHitboxService.HitboxFuncs = {
    
    ["PeashooterShoot"] = function(AttackName: string, HitboxCFrame: CFrame)
        local PeaPart = Instance.new("Part")
        local PropertiesTable = VisualHitboxesProperties[AttackName]
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

return VisualHitboxService 