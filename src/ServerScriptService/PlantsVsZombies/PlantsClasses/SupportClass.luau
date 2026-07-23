--!strict 
local PointsService = game:GetService("PointsService")
local PlantsClassFolder = script.Parent
local PVZFolder = script.Parent.Parent
--local PVZDataFolder = PVZFolder.PVZData

local Services = PVZFolder.Services
--local PlantsData = require(PVZDataFolder.PlantsData)
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
    ["Size"] = Vector3.new(2, 2, 2),
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

end 

function SupportClass.CreatePhysicalSun(SunSpawnPosition: Vector3) 
    local SunPart = Instance.new("Part")
    local ClickDetector = Instance.new("ClickDetector")
    local PointLight = Instance.new("PointLight")
    
    SunPart.Name = "Sun"
    SunPart.Color = SupportClass.SunPhysicalProperties["Color"]
    SunPart:AddTag("SunPartsTag")
    SunPart.Size = SupportClass.SunPhysicalProperties["Size"]
    SunPart.Shape = SupportClass.SunPhysicalProperties["Shape"]
    SunPart.Position = SunSpawnPosition
    SunPart.Parent = SunPartsFolder
    SupportClass.ApplySunImpulse(SunPart)
    warn("Called create phyasdasd")
    --[[task.defer(function()
        SupportClass.ApplySunImpulse(SunPart)
    end)]]
    
    ClickDetector.Name = "SunGrabber"
    ClickDetector.Parent = SunPart
    
    PointLight.Name = "SunPointLight"
    PointLight.Brightness = 2
    PointLight.Color = SunPart.Color
    PointLight.Enabled = true
    PointLight.Shadows = true 
    PointLight.Parent = SunPart

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

        local IsCooldownOnB = CooldownService.IsCooldownOn
        
        while self:IsAlive() do
   
            if CooldownService.IsCooldownOn(self, "GenerateSun") then 
                task.wait(0.2)
                continue  
            end

            self:GenerateSun()
            task.wait()
   
        end 

    end)

end 

return SupportClass 