--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ServerScriptServiceFolder = ServerScriptService:FindFirstChild("ServerScriptService") :: Folder
local DataFolder = ServerScriptServiceFolder:FindFirstChild("Data") :: Folder
local DataModuleManager = require(DataFolder:FindFirstChild("DataModuleManager"))

local PlantsVsZombies = ServerScriptServiceFolder:FindFirstChild("PlantsVsZombies") :: Folder 
local PVZData = PlantsVsZombies:FindFirstChild("PVZData") :: Folder

local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local Remotes = ReplicatedStorageFolder.Remotes :: Folder
local PurchasePlantRequest  = Remotes:FindFirstChild("PurchasePlantRequest")  :: RemoteEvent
local PurchaseStatusWarner = Remotes:FindFirstChild("PurchaseStatusWarner") :: RemoteEvent

local PlantsShopData = require(PVZData:FindFirstChild("PlantsShopData"))

local PVZShopService = {}

function PVZShopService.AddPlantToInv(Player: Player, Plant: string) 
    DataModuleManager.Profile[Player].Data.Inventory[Plant] = Plant
    warn(DataModuleManager.Profile[Player].Data.Inventory)
end 

function PVZShopService.OnPlantRequest()
    print("fdddd")
    PurchasePlantRequest.OnServerEvent:Connect(function(Player: Player, PlantRequest: string)
        warn(PlantRequest)

        local PlantPrice = PlantsShopData[PlantRequest]["Price"] :: number
        
        local PlayerInventory = DataModuleManager.Profile[Player]["Data"]["Inventory"] :: {[string]: string}
        local PlayerCoins = DataModuleManager.Profile[Player]["Data"]["Coins"] :: number 
        
        warn(PlayerInventory, PlayerCoins)
        if PlayerInventory[PlantRequest] then
            PurchaseStatusWarner:FireClient(Player, `You Already have {PlantRequest}!`)
            return 
        end

        if PlantPrice > PlayerCoins then 
            PurchaseStatusWarner:FireClient(Player, `You dont have enough coins to buy: {PlantRequest}!`)
            return 
        end 
        
        PVZShopService.AddPlantToInv(Player, PlantRequest)
        DataModuleManager.ManageCoins(Player, -PlantPrice)

    end)

end 

PVZShopService.OnPlantRequest()

return PVZShopService