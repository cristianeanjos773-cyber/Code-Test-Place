local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage:WaitForChild("ReplicatedStorage")
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes")
local RequestPlantSpawnRE = Remotes:WaitForChild("RequestPlantSpawn") :: RemoteEvent

local function RequestPlantSpawn(NewSpawnButton: TextButton, PlantRequest: string) 
    NewSpawnButton:SetAttribute("PlantSpawntRequested", PlantRequest)
    NewSpawnButton.Activated:Connect(function()
        RequestPlantSpawnRE:FireServer(PlantRequest)
    end )
end 

return RequestPlantSpawn