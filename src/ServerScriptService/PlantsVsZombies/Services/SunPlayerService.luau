local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local Remotes = ReplicatedStorageFolder.Remotes 

local SunGUIRE = Remotes.SunGUIRE :: RemoteEvent

local SunGoal = {Transparency = 0}

local SunPlayerService = {}
SunPlayerService.SunTweenInfo = TweenInfo.new(1)


function SunPlayerService.TweenAndDeleteSun(SunPart: Part) 
    local SunTween = TweenService:Create(SunPart, SunPlayerService.SunTweenInfo, SunGoal)
    SunTween:Play()
    
    SunTween.Completed:Connect(function()
        SunPart:Destroy()
        SunTween:Destroy()
        SunPart = nil 
        SunTween = nil 
    end)

end

function SunPlayerService.ManagePlayerSuns(Player: Player, Amount: number)
    local leaderstats = Player:FindFirstChild("leaderstats") :: Folder
    local SunsInt = leaderstats:FindFirstChild("Suns") :: IntValue
    SunsInt.Value = SunsInt.Value + Amount
end 


return SunPlayerService 