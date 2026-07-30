local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local Remotes = ReplicatedStorageFolder.Remotes 
local VisualHitboxRemote = Remotes.VisualHitboxRemote :: RemoteEvent

local VisualHitboxBusEvent = {}

function VisualHitboxBusEvent.SendVisualHitboxToClient(AttackName: string, HitboxCFrame: CFrame) 
    VisualHitboxRemote:FireAllClients(AttackName, HitboxCFrame)
end 

return VisualHitboxBusEvent 