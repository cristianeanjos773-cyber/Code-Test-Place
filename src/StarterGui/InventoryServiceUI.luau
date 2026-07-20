--!strict 
local FileManagerService = game:GetService("FileManagerService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUIFolder = script.Parent
local ImageHolder = require(GUIFolder.ImageHolders)

local PlayerGui = script.Parent.Parent :: PlayerGui
local InventoryScrollingFrame = PlayerGui:WaitForChild("PlantInvetory"):WaitForChild("PlantShopScrollingFrame") :: ScrollingFrame 
local FrameHolder = InventoryScrollingFrame:WaitForChild("FrameHolder") :: Frame 

local ImageTemplate = FrameHolder:WaitForChild("ImageTemplate") :: ImageLabel 
local SpawnTemplate = ImageTemplate:WaitForChild("SpawnTemplate")


local ReplicatedStorageFolder = ReplicatedStorage:WaitForChild("ReplicatedStorage") :: Folder
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes") :: Folder

local InventoryPopUp = Remotes:WaitForChild("InventoryPopUp") :: RemoteEvent
local SpawnFailed = Remotes:WaitForChild("SpawnFailedWarning") :: RemoteEvent 

type SpawnTextConfig = {
    ["Text"]: string, 
    ["Color"]: Color3,  
}

local InventoryServiceUI = {}

function InventoryServiceUI.InventoryVis() 
    InventoryPopUp.OnClientEvent:Connect(function()
        InventoryScrollingFrame.Visible = true     
    end)
end 

function InventoryServiceUI.SpawnFailedReceiver() 
    SpawnFailed.OnClientEvent:Connect(function(TextConfig: SpawnTextConfig)
        TextConfig.Text = TextConfig["Text"]
        TextConfig.Color = TextConfig["Color"]
    end)
end

function InventoryServiceUI.OrganizeInvData() 

end 

function InventoryServiceUI.SetUpInventory() 

end

InventoryServiceUI.InventoryVis()
InventoryServiceUI.SpawnFailedReceiver() 

return InventoryServiceUI 