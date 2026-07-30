local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local Remotes = ReplicatedStorageFolder.Remotes 
local VisualHitboxRemote = Remotes.VisualHitboxRemote :: RemoteEvent

local VisualHitboxBusEvent = {}

function VisualHitboxBusEvent.SendVisualHitboxToClient(AttackName: string, HitboxCFrame: CFrame, EndCFrame: CFrame) 
    VisualHitboxRemote:FireAllClients(AttackName, HitboxCFrame, EndCFrame)
end 

return VisualHitboxBusEvent 