--!strict 
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

function SupportClass.new(SupportPlantStats: Support): Support  
    local self = RootPlantsClass.new(SupportPlantStats) :: Support
    setmetatable(self, SupportClass)
    return self 
end

local PVZWorkspace = workspace.PlantsVsZombies :: Folder
local SunPartsFolder = PVZWorkspace:FindFirstChild("SunParts") :: Folder

function SupportClass.ApplySunImpulse(SunPart: Part)
    warn("called apply impulse")
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
    SunPart.Size = Vector3.new(1, 1, 1)
    SunPart.Shape = Enum.PartType.Ball
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
    warn(PlantModelInstance, "PLANTMODEL INSTANCE!")
    local CenterFace = PlantModelInstance:FindFirstChild("CenterFace") :: UnionOperation
    local CenterFacePos = CenterFace.Position
    local SunSpawnPosition = CenterFacePos + Vector3.new(0, 4, 0)
    
    if not SpawnSunCooldown or typeof(SpawnSunCooldown) ~= "number" then 
         warn(`[PVZPlayerDataService]: check the cooldown number argument, the type:{SpawnSunCooldown}`)
         return
    end

    SupportClass.CreatePhysicalSun(SunSpawnPosition)
    warn("Called create physucak syb")

end 

function SupportClass:Initialize() 
    local self = self :: Support
    local SpawnSunCooldown = self["SpawnSunCooldown"]
    CooldownService.StartCooldown(self, "GenerateSun", SpawnSunCooldown)

    warn(self, "plant init has been called")

    task.spawn(function()
        
        while self:IsAlive() do

            if CooldownService.IsCooldownOn(self, "GenerateSun") then 
                task.wait(1)
                continue  
            end

            self:GenerateSun()

         end 

    end)

end 

return SupportClass 