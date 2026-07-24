local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local GUIFolder = ReplicatedStorageFolder:WaitForChild("GUI")
local HPBarBillboardGui = GUIFolder:WaitForChild("HPBarBillboardGui") :: BillboardGui


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
    
    TankModel:GetAttributeChangedSignal("HP"):Connect(function()
        
        local ModelCurrentHP = TankModel:GetAttribute("HP") :: number  
        local ModelMaxHP = TankModel:GetAttribute("MaxHP") :: number 
        local HealthRatio = math.clamp(ModelCurrentHP / ModelMaxHP, 0, 1)
        
        LifeNumberText.Text = `{ModelCurrentHP} / {ModelMaxHP}`
        HPBarFrame.Size = UDim2.new(HealthRatio, 0, 1, 0)

    end)

end 

CollectionService:GetInstanceAddedSignal("ActiveTank"):Connect(SetUpBillBoardGUI)