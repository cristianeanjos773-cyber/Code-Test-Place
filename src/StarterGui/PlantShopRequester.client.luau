local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorageSER = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ReplicatedStorageFolder = ReplicatedStorageSER:WaitForChild("ReplicatedStorage") :: Folder 
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes") :: Folder
local PurchasePlantRequest = Remotes:WaitForChild("PurchasePlantRequest") :: RemoteEvent

local function BindButtonsToRequest()
    for _, TextButtons in CollectionService:GetTagged("PlantShopPurchase") do 
        if TextButtons:IsA("TextButton") then 
            local PlantRequest = TextButtons:GetAttribute("PlantRequested") :: string
            warn(PlantRequest)
            TextButtons.Activated:Connect(function()
                PurchasePlantRequest:FireServer(PlantRequest)
            end)
        end   
    end 
end 

BindButtonsToRequest()