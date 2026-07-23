--!strict 
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUIFolder = script.Parent
local PlantDataHolders = require(GUIFolder:WaitForChild("PlantDataHolders"))
local RequestPlantSpawnFunc = require(GUIFolder:WaitForChild("RequestPlantSpawn"))

local PlayerGui = script.Parent.Parent :: PlayerGui
local PlantInventoryScrollingFrame = PlayerGui:WaitForChild("PlantInvetory"):WaitForChild("PlantInventoryScrollingFrame") :: ScrollingFrame 
local FrameHolder = PlantInventoryScrollingFrame:WaitForChild("FrameHolder") :: Frame 

local ImageTemplate = PlantInventoryScrollingFrame:WaitForChild("ImageTemplate") :: ImageLabel 
local SpawnTemplate = ImageTemplate:WaitForChild("SpawnTemplate")

local ReplicatedStorageFolder = ReplicatedStorage:WaitForChild("ReplicatedStorage") :: Folder
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes") :: Folder

local InventoryPopUp = Remotes:WaitForChild("InventoryPopUp") :: RemoteEvent
local SpawnFailed = Remotes:WaitForChild("SpawnFailedWarning") :: RemoteEvent 
local InventoryDataClientSender = Remotes:WaitForChild("InventoryDataClientSender") :: RemoteEvent 

type SpawnTextConfig = {
    ["Text"]: string, 
    ["Color"]: Color3,  
}

type DataTemplate = {
    ["Coins"]: number,
    ["Level"]: number,
    ["Inventory"]: {},
}

type Inventory = {
    [string]: string 
}

local PVZUIService = {}

function PVZUIService.InventoryVis() 
    InventoryPopUp.OnClientEvent:Connect(function()
        PlantInventoryScrollingFrame.Visible = true   
        FrameHolder.Visible = true   
    end)
end 

function PVZUIService.SpawnFailedReceiver() 
    SpawnFailed.OnClientEvent:Connect(function(TextConfig: SpawnTextConfig)
        TextConfig.Text = TextConfig["Text"]
        TextConfig.Color = TextConfig["Color"]
    end)
end

local leaderstats = Player:WaitForChild("leaderstats") :: Folder
local Suns = leaderstats:WaitForChild("Suns") :: IntValue

function PVZUIService.OrganizeInvData() 
    InventoryDataClientSender.OnClientEvent:Connect(function(PlayerData: DataTemplate) 
        local Inventory = PlayerData["Inventory"] :: Inventory
        local Coins = PlayerData["Coins"] :: number 
        local Level = PlayerData["Level"] :: number 
        warn("invetory signal has been received by client!")
        PVZUIService.SetUpInventory(Inventory)
    end)
end 

function PVZUIService.SetUpInventory(Inventory: Inventory) 
    print("inventory", Inventory)
    for Keys, _ in Inventory do 
        local NewImageTemplate = ImageTemplate:Clone()
        local NewSpawnButton = NewImageTemplate:WaitForChild("SpawnTemplate") :: TextButton
        local PlantSunPrice = PlantDataHolders["PlantSunPrices"][Keys] :: string  
        NewImageTemplate.Parent = FrameHolder 
    NewImageTemplate.Visible = true 
        NewImageTemplate.Image = PlantDataHolders.PlantImages[Keys] :: string
        NewSpawnButton.Text = `Spawn {Inventory[Keys]} for {PlantSunPrice} Suns`
        RequestPlantSpawnFunc(NewSpawnButton, Keys)
    end 
end

local SunsGUI = PlayerGui:WaitForChild("SunsGUI") :: ScreenGui
local SunsFrame = SunsGUI:WaitForChild("SunsFrame") :: Frame
local SunsAmountText = SunsFrame:WaitForChild("SunsAmountText") :: TextLabel 

function PVZUIService.HandleSuns() 
    SunsAmountText.Text = `Suns: {Suns.Value}`
    warn("ffff")
    Suns:GetPropertyChangedSignal("Value"):Connect(function()
        SunsAmountText.Text = `Suns: {Suns.Value}`
    end)
end 

PVZUIService.OrganizeInvData()
PVZUIService.SpawnFailedReceiver() 
PVZUIService.HandleSuns()
PVZUIService.InventoryVis()
warn("PVZUISERVICE LIFE SIGN?")

return PVZUIService 