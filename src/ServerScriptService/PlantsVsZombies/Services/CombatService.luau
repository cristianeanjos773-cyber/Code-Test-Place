--!strict 
--[[
Purpose: Abstract the logic behind hitbox generating, being able to generate hitboxes and other attacks depending on the data of the attack asked. 
The Root Types are here because we dont need to call the actual classes as ClassicZombies or 
TankClasses type.
]]

type RootPlant = {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["Defense"]: number,
    ["SpawnCooldown"]: number,
    ["SunPrice"]: number,
    ["ModelName"]: string,
    ["ZombieHumanoid"]: Humanoid,
    ["IsAliveBool"]: boolean,  
    ["IsAlive"]: () -> (),
    ["TakeDamage"]: () -> (),
    ["HealPlant"]: () -> (),  
    ["PlantDie"]: () -> ()
}

type RootZombie =  {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["ModelName"]: string, 
    ["Class"]: string,  
}  


local CombatService = {}

CombatService.AttackTypesFunctions = {
    ["Projectile"] = CombatService.SetUpRaycast(),
}

function CombatService.SetUpRaycast() 

end 

function CombatService.ApplyDamageOnObject(OOPObject: RootPlant | RootPlant) 

end

function CombatService.ValidateAttackRequest(OOPObject: RootPlant | RootZombie)

end

function CombatService.CreatePhysicalHitbox() 

end 

function CombatService.CreateHitbox() 

end 

return CombatService