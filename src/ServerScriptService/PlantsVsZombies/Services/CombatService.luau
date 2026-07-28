--!strict 
--[[
Purpose: Abstract the logic behind hitbox generating, being able to generate hitboxes and other attacks depending on the data of the attack asked. 
The Root Types are here because we dont need to call the actual classes as ClassicZombies or 
TankClasses type.

NOTE REMINDER: The & symbol does not mean the OOPOBject can be both root plant and root zombies, its just a trick to deceive the type checking.
it doesnt reperesnt the actual types of the OOOP Objects. 

]]

local Services = script.Parent
local PVZFolder = Services.Parent
local PVZFDataFolder = PVZFolder.PVZData

local CombatData = require(PVZFDataFolder.CombatData)
local CooldownService = require(Services.CooldownService)
local PVZObjectDataService = require(Services.PVZObjectDataService)

export type Plant = PVZObjectDataService.Plant
export type Zombie = PVZObjectDataService.Zombie


type AttackStatus = {
    ["Size"]: Vector3, 
    ["AttackType"]: string,
    ["AttackName"]: string, 
    ["Cooldown"]: number,
    ["Damage"]: number,
}

local IsCooldownOn = CooldownService.IsCooldownOn
local StartCooldown = CooldownService.StartCooldown 
local GetObject = PVZObjectDataService.GetObject


local CombatService = {}



function CombatService.SetUpRaycast() 

end

function CombatService.SetUpMelee(OOPObject: Plant & Zombie, AttackStatus: AttackStatus) 
    local ZombieModel = OOPObject["ModelInstance"] :: Model 
    local HumanoidRootPart = ZombieModel:FindFirstChild("HumanoidRootPart") :: Part
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
        
            if ZombieModel == ObjectHitModel then 
                continue 
            end

            if ObjectHitModel == ZombieModel then 
                continue 
            end 
            
            CombatService.ApplyDamageOnObject(OOPObjectHit, AttackDamage)
            HitModels[ObjectHitModel] = true 
        

        end
        task.wait(AttackTime)
    end 
    CombatService.CreatePhysicalHitbox(AttackStatus, HitboxPosition, AttackTime)
end 



CombatService.AttackTypesFunctions = {
    ["Projectile"] = CombatService.SetUpRaycast,
    ["Melee"] = CombatService.SetUpMelee, 
}


function CombatService.ApplyDamageOnObject(OOPObjectHit: Plant | Zombie, Damage: number) 
    OOPObjectHit:TakeDamage(Damage)
end

function CombatService.CreatePhysicalHitbox(PartStatus: AttackStatus, HitboxPartPosition: CFrame, AttackTime: number) 
    local HitboxPart = Instance.new("Part")
    HitboxPart.Name = PartStatus["AttackName"]
    HitboxPart.Transparency = 0.5
    HitboxPart.Color = Color3.fromRGB(255, 1, 1)
    HitboxPart.CFrame = HitboxPartPosition
    HitboxPart.Size = PartStatus["Size"]
    HitboxPart.Anchored = true
    HitboxPart.CanCollide = false 
    HitboxPart.Parent = workspace
    task.wait(1)
    HitboxPart:Destroy()
end

function CombatService.CheckObjectInSideHitbox() 

end 

--[[function CombatService.CreateAttackHitbox(OOPObject: Plant & Zombie, AttackType: string)   
   
end ]]

function CombatService.ValidateAttackRequest(OOPObject: Plant & Zombie, AttackRequest: string)
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

    --[[the reason why I use an AttackName is because if we didnt, we'd have to use the whole AttackDataDict
       In the CooldownService, which would be unnecessary and less readable, a string is lighter than a dictionary, having only some bytes
       But the main puporse is to make it more readable. 
    ]]

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
    CombatService.AttackTypesFunctions[AttackType](OOPObject, AttackRequestedStatus)


end

return CombatService
