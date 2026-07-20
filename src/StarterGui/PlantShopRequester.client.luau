local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorageSER = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ReplicatedStorageFolder = ReplicatedStorageSER:WaitForChild("ReplicatedStorage") :: Folder 
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes") :: Folder
local PurchasePlantRequest = Remotes:WaitForChild("PurchasePlantRequest") :: RemoteEvent

local function BindButtonsToRequest()
    print("hgwi") 
    for _, TextButtons in CollectionService:GetTagged("PlantShopPurchase") do 
        print(TextButtons)
        if TextButtons:IsA("TextButton") then 
            print("yes its a button")
            local PlantRequest = TextButtons:GetAttribute("PlantRequested") :: string
            warn(PlantRequest)
            TextButtons.Activated:Connect(function()
                warn("gwelo")
                PurchasePlantRequest:FireServer(PlantRequest)
            end)

        end   
    end 
end 

BindButtonsToRequest()