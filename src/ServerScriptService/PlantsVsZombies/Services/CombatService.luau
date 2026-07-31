--!strict 

--[[
Purpose: Abstract the logic behind hitbox generating, being able to generate hitboxes and other attacks depending on the data of the attack asked. 
The Root Types are here because we dont need to call the actual classes as ClassicZombies or 
TankClasses type.

NOTE REMINDER: The & symbol does not mean the OOPOBject can be both root plant and root zombies, its just a trick to deceive the type checking.
it doesnt reperesnt the actual types of the OOOP Objects. 

NOTE2: EVERY request related to combat should be asked to this combat service thorough the server signalsHandler server script 
and should also be validated with CooldownService 

]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Services = script.Parent
local PVZFolder = Services.Parent
local PVZFDataFolder = PVZFolder.PVZData

local ObjectsInCombatModule = require("../PVZData/ObjectsInCombatModule")
local CombatData = require(PVZFDataFolder.CombatData)
local CooldownService = require(Services.CooldownService)
local PVZObjectDataService = require(Services.PVZObjectDataService)
local VisualHitBoxBusEvent = require(Services.VisualHitboxBusEvent)
--local ObjectsInCombatModule = require(PVZFDataFolder.ObjectsInCombatModule)


export type Plant = PVZObjectDataService.Plant
export type Zombie = PVZObjectDataService.Zombie

type AttackStatus = {
    ["Size"]: Vector3, 
    ["Color"]: Color3, 
    ["Anchored"]: boolean, 
    ["CanCollide"]: boolean,
    ["AttackType"]: string,
    ["AttackName"]: string, 
    ["Cooldown"]: number,
    ["Transparency"]: number, 
    ["Damage"]: number,
    ["ProjectileSpeed"]: number, 
    ["RaycastType"]: number,
    ["Radius"]: number, 
    ["Size"]: Vector3, 
    ["PartShape"]: Enum.PartType,
}

type ObjectsInCombat = {
    [Plant | Zombie]: Plant | Zombie 
}

local IsCooldownOn = CooldownService.IsCooldownOn
local StartCooldown = CooldownService.StartCooldown 
local GetObject = PVZObjectDataService.GetObject
local CombatService = {}

CombatService.RaycastTypes = table.freeze({

    ["Raycast"] = function(Position: Vector3, ...: any) 
       return workspace:Raycast(Position, ...)
    end,
    
    ["Spherecast"] = function(Position: Vector3, ...: any) 
       return workspace:Spherecast(Position, ...)
    end,

}) -- this is a dispatch table i'll be usiing to determine wihich
-- raycast function the SetUpRayCast should call instead of throwing 1000 ifs elseifs  
-- and it will also return the results and make the actual raycast method 



function CombatService.SetUpMelee(OOPObject: Plant & Zombie, AttackStatus: AttackStatus) 
    local ObjectModel = OOPObject["ModelInstance"] :: Model 
    local HumanoidRootPart = ObjectModel:FindFirstChild("HumanoidRootPart") :: Part
    local Distance = 3
    
    local HitboxPosition = CFrame.new(HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * Distance)
    local HitboxSize = AttackStatus["Size"]
    local AttackDamage = AttackStatus["Damage"]
    local AttackTime = AttackStatus["Cooldown"]
    local AttackStart = os.clock()

    local HitModels = {}


    while os.clock() - AttackStart < AttackTime do 
        local ObjectsHit = workspace:GetPartBoundsInBox(HitboxPosition, HitboxSize)

        if #ObjectsHit == 0 then 
            continue 
        end
 
        -- THIS TABLE WILL BE USED TO KEEP MODELS THAT WERE ALREADY HIT TO NOT DAMAGE THE OOP OBJECT MORE THAN ONCE. 

        for _, PartsHit in ObjectsHit do 

            local ObjectHitModel = PartsHit.Parent :: Model? 

            if not ObjectHitModel then 
                continue
            end 

            if not ObjectHitModel:HasTag("Plant") and not ObjectHitModel:HasTag("Zombie") then 
                continue 
            end 

            local OOPObjectHit = GetObject(ObjectHitModel) 

            if not OOPObjectHit then
               continue
            end     
        
            if HitModels[ObjectHitModel] then
                continue
             end 
             
            if ObjectModel == ObjectHitModel then 
                continue 
            end

            if ObjectHitModel == ObjectModel then 
                continue 
            end 

            CombatService.ApplyDamageOnObject(OOPObjectHit, AttackDamage)
            --CombatService.CreatePhysicalHitbox(AttackStatus, HitboxPosition, AttackTime)
            HitModels[ObjectHitModel] = true 
        

        end
        task.wait(AttackTime)
    end 
    
end    

local PlantFolder = workspace:FindFirstChild("PlantsVsZombies"):FindFirstChild("PlantsFolder") :: Folder 
local PlantsFolderDescArr = PlantFolder:GetDescendants()
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.FilterDescendantsInstances = PlantsFolderDescArr 

function CombatService.SetUpRayCast(OOPObject: Plant & Zombie, AttackStatus: AttackStatus, ObjectTarget: Model) 
    local ObjectModel = OOPObject["ModelInstance"]
    local ObjectCastType = AttackStatus["RaycastType"]
    local ProjectileSpeed = AttackStatus["ProjectileSpeed"]
    local ProjectileRadius = AttackStatus["Radius"]
    local MaxDuration = AttackStatus["MaxTime"]
    local ProjectileName = AttackStatus["AttackName"] 
    

    local ObjectPos = ObjectModel.PrimaryPart.Position 
    local TargetumanoidRootPart = ObjectTarget:FindFirstChild("HumanoidRootPart") :: Part  
    
    local TargetPos = TargetumanoidRootPart.Position 
    local TargetVelocity = TargetumanoidRootPart.AssemblyLinearVelocity

    local Distance = (ObjectPos - TargetPos).Magnitude
    local TravelTime = Distance / ProjectileSpeed 

    local PredictedTargetPos = TargetPos + (TargetVelocity * TravelTime) 

    local ProjectileDirection = (PredictedTargetPos - ObjectPos).Unit
    local ProjectileVelocity = ProjectileDirection * ProjectileSpeed 
    local TimeElapsed = 0 

    local HeartbeatConn 
    local CurrentProjectilePos = ObjectPos

    task.spawn(function()
        
        HeartbeatConn = RunService.Heartbeat:Connect(function(DeltaTime)
            TimeElapsed = TimeElapsed + DeltaTime

            if TimeElapsed >= MaxDuration then
                HeartbeatConn:Disconnect()
                HeartbeatConn = nil  
                return
            end

            local Displacement = ProjectileVelocity * DeltaTime

            if Displacement.Magnitude <= 0 then
                return
            end
          
            local CastFunction =  CombatService.RaycastTypes[ObjectCastType] :: (Origin: Vector3, Radius: number, Displacement: Vector3, raycastParams: RaycastParams) -> RaycastResult? 
            local RayCastResult = CastFunction(CurrentProjectilePos, ProjectileRadius, Displacement, raycastParams) 
            --warn(`[CombatService]: RayCastResult print: ({RayCastResult})`)
            
            if RayCastResult then
                
                HeartbeatConn:Disconnect()
                local TargetModel = RayCastResult.Instance:FindFirstAncestorOfClass("Model")
                
                --warn("RaycastResult found:", RayCastResult.Instance)
               
                local IsAPlayer = Players:GetPlayerFromCharacter(TargetModel)

                if IsAPlayer then 
                    return
                end 

                local ProjectileDamage = AttackStatus["Damage"]
                local TargetOOPObject = PVZObjectDataService.GetObject(TargetModel) :: Plant | Zombie
                --warn("HGEYY", TargetModel, "Instance:", RayCastResult.Instance)
                
                if not TargetOOPObject then
                    --warn(`[CombatService]: not found TargetOOP: {TargetOOPObject}`)
                    return
                end
                
                CombatService.ApplyDamageOnObject(TargetOOPObject, ProjectileDamage, ProjectileName)
                --CombatService.CreatePhysicalHitbox(AttackStatus, Displacement, MaxDuration)

            else
                CurrentProjectilePos = CurrentProjectilePos + Displacement
            end 
        end)
    end)

end

CombatService.AttackTypesFunctions = {
    ["Projectile"] = CombatService.SetUpRayCast,
    ["Melee"] = CombatService.SetUpMelee, 
}


function CombatService.ApplyDamageOnObject(OOPObjectHit: Plant | Zombie, Damage: number, AttackName: string) 
    --print("printing OOPobject that was hit:", OOPObjectHit)
    OOPObjectHit:TakeDamage(Damage, AttackName)
end

--[[function CombatService.CreatePhysicalHitbox(PartStatus: AttackStatus, HitboxPartPosition: CFrame, AttackTime: number) 
    local HitboxPart = Instance.new("Part")

    HitboxPart.Name = PartStatus["AttackName"]
    HitboxPart.Transparency = PartStatus["Transparency"]
    HitboxPart.Size = PartStatus["Size"]
    HitboxPart.Shape = PartStatus["PartShape"]
    HitboxPart.Anchored = PartStatus["Anchored"]
    HitboxPart.CanCollide = PartStatus["CanCollide"]

    HitboxPart.CFrame = HitboxPartPosition
    HitboxPart.Parent = workspace

    task.wait(AttackTime)

    HitboxPart:Destroy()

    if typeof(HitboxPartPosition) == "Vector3" then
        HitboxPart.Position = HitboxPartPosition
    elseif typeof(HitboxPartPosition) == "CFrame" then
        HitboxPart.CFrame = HitboxPartPosition
    end

    HitboxPart.Parent = workspace

    task.wait(AttackTime)

    HitboxPart:Destroy()
end]]


--[[function CombatService.CreateAttackHitbox(OOPObject: Plant & Zombie, AttackType: string)   
   
end]]

function CombatService.PrepareVisualHitboxCFrame(ObjectModel: Model): CFrame 
    local ObjectPrimaryPart = ObjectModel.PrimaryPart :: Part? 
    local ObjectHumanoid = ObjectModel:FindFirstChild("Humanoid") :: Humanoid 
       
    if ObjectHumanoid.MoveDirection.Magnitude < 0 then 
        return ObjectPrimaryPart.CFrame -- this is here incase the zombie is staying still so it just doesnt predict its next movemnt for the client. 
    end 

    local LatencyCompensation = 0.1
    local ObjectSpeed = ObjectHumanoid.WalkSpeed 
    local EndPosition = ObjectPrimaryPart.Position + ObjectPrimaryPart.CFrame.LookVector * ObjectSpeed * LatencyCompensation
    local EndCFrame = CFrame.new(EndPosition) * ObjectPrimaryPart.CFrame.Rotation

    return EndCFrame 

end 

function CombatService.ValidateAttackRequest(OOPObject: Plant & Zombie, AttackRequest: string, ObjectTarget: Model?)
    --warn("VALIDATION REACHED")
    
    if not OOPObject then 
        --warn("KEINE OOP")
        return
    end
    
    local ObjectName = OOPObject["Name"]
    local OOPObjectTeam =  OOPObject["Team"] .. "Attacks"
    
    local ObjectAttackDict = CombatData[OOPObjectTeam][ObjectName]

    --print("SEAHFJSAJF" , "DEBUGS ->", ObjectAttackDict, CombatData[OOPObjectTeam], OOPObjectTeam)


    if not ObjectAttackDict then 
        warn(`[CombatService]: Couldnt't find AttackDictionary in CombatData, review the thing, Received: {ObjectAttackDict}`)
        return
    end 

    local AttackRequestedStatus = ObjectAttackDict[AttackRequest] :: AttackStatus
   -- warn(AttackRequestedStatus, "THIS IS THE ATACCK RQUESTED TABLW!")
    local AttackCooldown = AttackRequestedStatus["Cooldown"] 
    local AttackRequestedName = AttackRequestedStatus["AttackName"] 
    local AttackType = AttackRequestedStatus["AttackType"]


    if IsCooldownOn(OOPObject, AttackRequestedName) == nil then 
        warn("WE CREATED ANOTHER TBLE!")
        StartCooldown(OOPObject, AttackRequestedName, 0) --[[
        This is supposed to just make the Action and
        The OOPObject in the cooldown dictionary, Or Else IsCooldownOn() Would fail
        Why do i not just make IsCooldownOn() fix this problem? because of the SRP. Its not CooldownService's reponsability
        to take care of Inserting things into the Cooldown Dictionary.
        the 0 cooldown means it starts fresh, without any cooldown, in the end of the code
        When the attack has been finished we will set this function's paremeters to (OOPObject, AttackRequestedName, AttackCooldown) 
        ]]
    end 

    if IsCooldownOn(OOPObject, AttackRequestedName) then 
        --warn("COOLDOWN IS ON", OOPObject, AttackRequestedName)
        return 
    end 

    StartCooldown(OOPObject, AttackRequestedName, AttackCooldown)
    --warn(AttackType, CombatService.AttackTypesFunctions["Melee"])


    CombatService.AttackTypesFunctions[AttackType](OOPObject, AttackRequestedStatus, ObjectTarget)

    if CombatData.PlantsAttacks.Peashooter[AttackRequest] ~= nil then
        local ObjectModel = OOPObject["ModelInstance"]
        local ClosestTarget = OOPObject["ClosestTarget"]
        local PrimaryPartCFrame = ObjectModel.PrimaryPart.CFrame
        local ClosestTargetCFrame = CombatService.PrepareVisualHitboxCFrame(ClosestTarget)
        VisualHitBoxBusEvent.SendVisualHitboxToClient(AttackRequestedName, PrimaryPartCFrame, ClosestTargetCFrame)
    end

end

return CombatService
