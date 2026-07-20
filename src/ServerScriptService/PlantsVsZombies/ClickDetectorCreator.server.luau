local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local Remotes = ReplicatedStorageFolder.Remotes
local InventoryPopUp = Remotes:FindFirstChild("InventoryPopUp") :: RemoteEvent 
local PlantsMainModule = require(script.Parent.PlantsMainModule)

local function InsertClickDet() 
    warn("ffff")
    for _, Parts in CollectionService:GetTagged("PlantsSpawnParts") do 
        
        if Parts:IsA("BasePart") then 
            
            local ClickDetector = Instance.new("ClickDetector")
            warn(ClickDetector, "life sing")
            ClickDetector.Parent = Parts

            ClickDetector.MouseClick:Connect(function(Player: Player)
                InventoryPopUp:FireClient(Player)
                PlantsMainModule.ValidatePlantSpawnRequest(ClickDetector.Parent)
            end)

        end
    end 
end 

InsertClickDet()