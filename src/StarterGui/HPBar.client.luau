local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local OOPObjectDamaged = ReplicatedStorageFolder.Remotes.OOPObjectDamaged :: RemoteEvent
local GUIFolder = ReplicatedStorageFolder:WaitForChild("GUI")
local HPBarBillboardGui = GUIFolder:WaitForChild("HPBarBillboardGui") :: BillboardGui


--[[
This is planed to be generalized as we'll have more HP bars. 
]]



local function SetUpBillBoardGUI(TankModel: Model) 
    local ClonedHPBarBillboardGui = HPBarBillboardGui:Clone()
    
    local HPBarFrame = ClonedHPBarBillboardGui:WaitForChild("HPBarFrame") :: Frame
    local LifeFrame = HPBarFrame:WaitForChild("LifeFrame") :: Frame
    
    local LifeNumberText = LifeFrame:WaitForChild("LifeNumber") :: TextLabel
    local ModelCurrentHP = TankModel:GetAttribute("HP") :: number  
    local ModelMaxHP = TankModel:GetAttribute("MaxHP") :: number

    ClonedHPBarBillboardGui.Parent = TankModel 
    ClonedHPBarBillboardGui.Adornee = TankModel
    LifeNumberText.Text = `{ModelCurrentHP} / {ModelMaxHP}`

    OOPObjectDamaged.OnClientEvent:Connect(function(DamagedTankModel: Model, SelfCurrentHP: number, SelfMaxHP: number) 

        if DamagedTankModel ~= TankModel then 
            return
        end 

        local HealthRatio = math.clamp(SelfCurrentHP / SelfMaxHP, 0, 1)
        
        LifeNumberText.Text = `{SelfCurrentHP} / {SelfMaxHP}`
        HPBarFrame.Size = UDim2.new(HealthRatio, 0, 1, 0)

    end)

end 

CollectionService:GetInstanceAddedSignal("ActiveTank"):Connect(SetUpBillBoardGUI)

