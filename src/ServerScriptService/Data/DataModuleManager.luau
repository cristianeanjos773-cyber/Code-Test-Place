local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local Remotes = ReplicatedStorageFolder.Remotes
local InventoryDataClientSender = Remotes:FindFirstChild("InventoryDataClientSender") :: RemoteEvent
local DataTemplate = require(script.Parent.DataTemplate)

local DataModuleManager = {}
DataModuleManager.Profile = {}

function DataModuleManager.ManageCoins(Player: Player, amount: number)
    
    local leaderstats = Player:FindFirstChild("leaderstats") :: Folder
    local Coins: IntValue = leaderstats.Coins
    local profile = DataModuleManager.Profile[Player]
    
    if not Player or not amount or not profile then return end
    
    profile.Data.Coins = math.clamp(profile.Data.Coins + amount, 0, 1000000) 
    Coins.Value = profile.Data.Coins
    DataModuleManager.SendDataToClient(Player)
    
end

function DataModuleManager.ManageLevel(Player: Player, amount: number)
    
    local leaderstats = Player:FindFirstChild("leaderstats") :: Folder
    local Level: IntValue = leaderstats.Level
    local profile = DataModuleManager.Profile[Player]

    if not Player or not amount or not profile then return end 
    
    profile.Data.Level = math.clamp(profile.Data.Level + amount , 0, 1000000)
    Level.Value = profile.Data.Level
    DataModuleManager.SendDataToClient(Player)
    
end

function DataModuleManager.SendDataToClient(Player: Player) 
    InventoryDataClientSender:FireClient(Player, DataModuleManager.Profile[Player].Data)
end 


return DataModuleManager