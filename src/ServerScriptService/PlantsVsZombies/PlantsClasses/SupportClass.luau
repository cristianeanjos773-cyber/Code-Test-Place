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
    local DirX = RandomGenerator:NextNumber(-1, 1)
    local DirY = RandomGenerator:NextNumber(15, 25)
    local DirZ = RandomGenerator:NextNumber(-2, 2)
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

function SupportClass.CreatePhysicalSun(SunSpawnPosition: Vector3) 
    local SunPart = Instance.new("Part")
    local ClickDetector = Instance.new("ClickDetector")
    
    SupportClass.SetUpPhyisicalSunProperties(SunPart)
    SunPart:AddTag("SunPartsTag")
    SunPart.Position = SunSpawnPosition
    SunPart.Parent = SunPartsFolder
    SupportClass.CreatePointLight(SunPart)

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
    local PlantModelInstance = self["ModelInstance"] :: Model   
    local CenterFace = PlantModelInstance:FindFirstChild("CenterFace") :: UnionOperation
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
    
    CooldownService.StartCooldown(self, SupportClass.SupportActions["GenerateSuns"], SpawnSunCooldown)

    warn(self, "plant init has been called")

    task.spawn(function()

        local IsCooldownOn = CooldownService.IsCooldownOn
        
        while self:IsAlive() do
   
            if IsCooldownOn(self, SupportClass.SupportActions["GenerateSuns"]) then 
                task.wait(0.2)
                continue  
            end

            self:GenerateSun()
            task.wait()
   
        end 

    end)

end 

return SupportClass 