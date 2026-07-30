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
            ["AttackTime"] = 3,
            ["Damage"] = 10, 
            ["Cooldown"] = 3,  
        }
    },

    ["ConeHeadZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["AttackName"] = "ConeHeadZombieBite",
            ["AttackTime"] = 3, 
            ["Damage"] = 10, 
            ["Cooldown"] = 3,  
        }
    },

    ["BucketHeadZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["AttackName"] = "BucketHeadZombieBite",
            ["Damage"] = 10, 
            ["AttackTime"] = 3,
            ["Cooldown"] = 3,  
        }
    },

}

CombatData.PlantsAttacks = {
    
    ["Peashooter"] = {
        ["Shoot"] = {
            ["Damage"] = 14, 
            ["Size"] = Vector3.new(4, 4, 4),
            ["AttackType"] = "Projectile",
            ["RaycastType"] = "Spherecast", 
            ["AttackName"] = "PeashooterShoot",
            ["Cooldown"] = 3,
            ["PeaSpeed"] = 5, 
        },

    }, 
}

return table.freeze(CombatData)