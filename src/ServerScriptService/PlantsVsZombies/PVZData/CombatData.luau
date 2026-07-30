--[[
Purpose: to store the attack data being able to make the data readable by the combat service, making hitbox and attack managing data driven. 

REMINDER: EVERY STATUS RELATED TO THE GAME'S COMBAT SHOULD BE PUT HERE, NOT IN THE PLANTS DATA OR ZOMBIES DATA.

]]
local CombatData = {}

CombatData.ZombiesAttacks = {
    
    ["ClassicZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["AttackName"] = "ClassicZombieBite",
            ["PartShape"] = Enum.PartType.Block,
            ["AttackTime"] = 1,
            ["Damage"] = 10, 
            ["Cooldown"] = 3,  
        }
    },

    ["ConeHeadZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["Color"] = Color3.fromRGB(85, 255, 0),
            ["AttackName"] = "ConeHeadZombieBite",
            ["PartShape"] = Enum.PartType.Block,
            ["AttackTime"] = 1, 
            ["Damage"] = 10, 
            ["Cooldown"] = 3,  
        }
    },

    ["BucketHeadZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["Color"] = Color3.fromRGB(85, 255, 0),
            ["PartShape"] = Enum.PartType.Block,
            ["AttackName"] = "BucketHeadZombieBite",
            ["Damage"] = 10, 
            ["AttackTime"] = 1,
            ["Cooldown"] = 3,  
        }
    },

}

CombatData.PlantsAttacks = {
    
    ["Peashooter"] = {
        ["Shoot"] = {
            ["Damage"] = 14, 
            ["Size"] = Vector3.new(4, 4, 4),
            ["Color"] = Color3.fromRGB(85, 255, 0),
            ["AttackType"] = "Projectile",
            ["RaycastType"] = "Spherecast", 
            ["AttackName"] = "PeashooterShoot",
            ["PartShape"] = Enum.PartType.Ball,
            ["Cooldown"] = 3, 
            ["MaxTime"] = 10,
            ["ProjectileSpeed"] = 35,
            ["Radius"] = 4, 
        },

    }, 
}

return table.freeze(CombatData)