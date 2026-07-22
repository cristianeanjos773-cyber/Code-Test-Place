local PlantsClassFolder = script.Parent
local RootPlantsClass = require(PlantsClassFolder.RootPlantsClass)
local PVZFolder = script.Parent.Parent
local PVZPlantaDataService = require(PVZFolder.PVZPlantDataService)

local SupportClass = {}
setmetatable(SupportClass, {__index = RootPlantsClass})
SupportClass.__index = SupportClass

export type Support = {
    ["HP"]: number, 
    ["SpawnSunCooldown"]: number,
    ["Defense"]: number,
    ["Class"]: string,
    ["SunPrice"]: number, 
    ["SpawnCooldown"]: number, 
    ["ModelName"]: string,
}

function SupportClass.new(SupportPlantStats: Support): Support  
    local self = RootPlantsClass.new(SupportPlantStats)
    setmetatable(self, SupportClass)
    return self :: Support
end

local PVZWorkspace = workspace.PlantsVsZombies :: Folder
local SunPartsFolder = PVZWorkspace:FindFirstChild("SunParts") :: Folder

function SupportClass.ApplySunImpulse(SunPart: Part)
    local ForceDirection = Vector3.new(0, 15, 0)
    local SunPartAssemblyMass = SunPart.AssemblyMass
    SunPart:ApplyImpulse(ForceDirection * SunPartAssemblyMass)
end 

function SupportClass.CreatePhysicalSun(SunSpawnPosition: Vector3) 
    local SunPart = Instance.new("Part")
    local ClickDetector = Instance.new("ClickDetector")
    local PointLight = Instance.new("PointLight")
    
    SunPart.Name = "Sun"
    SunPart.Color = Color3.fromRGB(251, 255, 0)
    SunPart:AddTag("SunPartsTag")
    SunPart.Size = Vector3.new(5, 5, 5)
    SunPart.Shape = Enum.PartType.Ball
    SunPart.Position = SunSpawnPosition
    SunPart.Parent = SunPartsFolder
    SupportClass.ApplySunImpulse(SunPart)

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

function SupportClass:GenerateSun(SupportPlantModel: Model)
    local CenterFace = SupportPlantModel:FindFirstChild("CenterFace") :: BasePart
    local CenterFacePos = CenterFace.Position
    local SunSpawnPosition = CenterFacePos + Vector3.new(0, 4, 0)
    local SpawnSunCooldown = self["SpawnSunCooldown"] :: number
    SupportClass.CreatePhysicalSun(SunSpawnPosition)

    if not SpawnSunCooldown or typeof(SpawnSunCooldown) ~= "number" then 
         warn(`[PVZPlayerDataService]: check the cooldown number argument, the type:{SpawnSunCooldown}`)
         return
    end 
end 

return SupportClass 