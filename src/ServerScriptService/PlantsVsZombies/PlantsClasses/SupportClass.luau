--!strict 
local Debris = game:GetService("Debris")
local PointsService = game:GetService("PointsService")
local PlantsClassFolder = script.Parent
local PVZFolder = script.Parent.Parent
--local PVZDataFolder = PVZFolder.PVZData

local Services = PVZFolder.Services
--local PlantsData = require(PVZDataFolder.PlantsData)
local SunPlayerService = require(PVZFolder.Services.SunPlayerService)
local RootPlantsClass = require(PlantsClassFolder.RootPlantsClass)
--local PVZObjectDataService = require(Services.PVZObjectDataService)

local CooldownService = require(Services.CooldownService)

local SupportClass = {}

setmetatable(SupportClass, {__index = RootPlantsClass})
SupportClass.__index = SupportClass

type RootPlant = RootPlantsClass.RootPlant 

export type Support = typeof(setmetatable({} ::  RootPlant & {
    ["SpawnSunCooldown"]: number,
    ["ModelInstance"]: Model,
    ["GenerateSun"]: (self: Support) -> (), 
    ["Initialize"]: (self: Support) -> (), 
},
SupportClass
))

SupportClass.SunPhysicalProperties = table.freeze({
    ["Name"] = "Sun", 
    ["Color"] = Color3.fromRGB(255, 251, 0), 
    ["Size"] = Vector3.new(1, 1, 1),
    ["Shape"] = Enum.PartType.Ball, 
})

SupportClass.PhysicalSunPointLightProperties = table.freeze({
    ["Name"] = "SunPointLight",
    ["Brightness"] = 2, 
    ["Color"] = Color3.fromRGB(255, 251, 0),
    ["Shadows"] = true,
})

SupportClass.SupportActions = table.freeze({
    ["GenerateSuns"] = "GenerateSuns",
})

function SupportClass.new(SupportPlantStats: Support): Support  
    local self = RootPlantsClass.new(SupportPlantStats) :: Support
    setmetatable(self, SupportClass)
    return self 
end

local PVZWorkspace = workspace.PlantsVsZombies :: Folder
local SunPartsFolder = PVZWorkspace:FindFirstChild("SunParts") :: Folder
local RandomGenerator = Random.new()


function SupportClass.ApplySunImpulse(SunPart: Part)
    local DirX = RandomGenerator:NextNumber(4, 15)
    local DirY = RandomGenerator:NextNumber(20, 25)
    local DirZ = RandomGenerator:NextNumber(0, 10)
    local ForceDirection = Vector3.new(DirX, DirY, DirZ)
    local SunPartAssemblyMass = SunPart.AssemblyMass
    SunPart:ApplyImpulse(ForceDirection * SunPartAssemblyMass)
end 

function SupportClass.CreatePointLight(SunParent: Part)
    local PointLight = Instance.new("PointLight")

    for Properties, Values in SupportClass.PhysicalSunPointLightProperties do 
        local lightAsAny = PointLight :: any 
        
        if lightAsAny[Properties] == nil then 
            continue 
        end

        lightAsAny[Properties] = Values
    
    end  

    PointLight.Parent = SunParent 

end

function SupportClass.SetUpPhyisicalSunProperties(SunPart: Part)
    for Properties, Values in SupportClass.SunPhysicalProperties do 
        local SunPartAsAny = SunPart :: any 
        
        if SunPartAsAny[Properties] == nil then 
            continue 
        end

        SunPartAsAny[Properties] = Values
    end  
end 

local SunNumber = 20

function SupportClass.OnSunGrabRequest(SunGrabber: ClickDetector, SunPart: Part)
    local SunGrabConn: RBXScriptConnection? = nil 
   
    SunGrabConn = SunGrabber.MouseClick:Connect(function(Player)
    
        if SunGrabConn then 
            SunGrabConn:Disconnect()
            SunGrabConn = nil
        end 

        SunGrabber.MaxActivationDistance = 0 

        SunPlayerService.TweenAndDeleteSun(SunPart)

        if Player then 
            SunPlayerService.ManagePlayerSuns(Player, SunNumber)
        end 

    end)

end 

local GrassPartName = "Grass"

function SupportClass.AnchorPhysicalSun(SunPart: Part)
    local TouchedConn
    
    TouchedConn = SunPart.Touched:Connect(function(OtherPart: BasePart)
        
        if OtherPart.Name ~= GrassPartName then 
            return 
        end
        
        if SunPart.Anchored then 
            return 
        end

        SunPart.Anchored = true 
        TouchedConn:Disconnect()
        TouchedConn = nil
         
    end)
    --[[
        As the sun part falls in the grass part, it gets anchored. we use a :Disconnect() to avoid using memory in an useless way. 
        if the sunPart had already fallen, keeping the .Touched listener would be a waste of resources. 
    ]]
end 

function SupportClass.CreatePhysicalSun(SunSpawnPosition: Vector3) 
    local SunPart = Instance.new("Part")
    local ClickDetector = Instance.new("ClickDetector")
    
    SunPart:AddTag("SunPartsTag")
    SunPart.Position = SunSpawnPosition
    SunPart.Parent = SunPartsFolder

    SupportClass.SetUpPhyisicalSunProperties(SunPart)
    SupportClass.CreatePointLight(SunPart)
    SupportClass.AnchorPhysicalSun(SunPart)
    SupportClass.OnSunGrabRequest(ClickDetector, SunPart)

    ClickDetector.Name = "SunGrabber"
    ClickDetector.Parent = SunPart


    task.defer(function()
        SupportClass.ApplySunImpulse(SunPart) --[[
            a task.defer() is used here because Roblox needs to finish registering and initializing the physicalbody of the body in this frame
            delaying it with taskdefer() guarantees that :ApplyImpulse() is not ignored by the engine 
        ]]
    end)

    Debris:AddItem(SunPart, 15)

end 

function SupportClass:GenerateSun()
    warn("generate sun function called")
    local self = self :: Support 
    local SpawnSunCooldown = self["SpawnSunCooldown"] :: number
    local SupportModelInstance = self["ModelInstance"] :: Model   
    local CenterFace = SupportModelInstance:FindFirstChild("CenterFace") :: UnionOperation
    local CenterFacePos = CenterFace.Position
    local SunSpawnPosition = CenterFacePos + Vector3.new(0, 4, 0)
    
    if not SpawnSunCooldown or typeof(SpawnSunCooldown) ~= "number" then 
         warn(`[PVZPlayerDataService]: check the cooldown number argument, the type:{SpawnSunCooldown}`)
         return
    end

    SupportClass.CreatePhysicalSun(SunSpawnPosition)
    CooldownService.StartCooldown(self, SupportClass.SupportActions["GenerateSuns"], SpawnSunCooldown)

end 

function SupportClass:Initialize() 
    local self = self :: Support
    local SpawnSunCooldown = self["SpawnSunCooldown"]
    local GetRemainingCooldown = CooldownService.GetRemainingCooldown --[[
        we cache these variables because using them in the while loop would affect perfomance, it is a microopt. 
    ]]
    local StartCooldown = CooldownService.StartCooldown
    local GenerateSuns = SupportClass.SupportActions["GenerateSuns"]
    
    CooldownService.StartCooldown(self, SupportClass.SupportActions["GenerateSuns"], SpawnSunCooldown)

    warn(self, "plant init has been called")

    task.spawn(function()

        while self:IsAlive() do

            if not self:IsAlive() then 
                break -- we do this break here before the other lines cuz incase our SupportPLANT dies before the task.wait() finishes counting, it will run 
                -- even if theyre dead 
            end

            task.wait(GetRemainingCooldown(self, GenerateSuns))
            self:GenerateSun()
            StartCooldown(self, GenerateSuns, SpawnSunCooldown)

        end 

    end)

end 

return SupportClass 