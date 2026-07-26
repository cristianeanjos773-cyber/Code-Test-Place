--[[
Purpose: to store the attack data being able to make the data readable by the combat service, making hitbox and attack managing data driven. 
]]
local CombatData = {}

CombatData.ZombiesAttacks = {
    
    ["ClassicZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["Damage"] = 10, 
            ["BiteCooldown"] = 5,  
        }
    },

    ["ConeHeadZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["Damage"] = 15, 
            ["BiteCooldown"] = 5,  
        }
    },

    ["BucketHeadZombie"] = {
        ["Bite"] = {
            ["Size"] = Vector3.new(5, 5, 5),
            ["AttackType"] = "Melee",
            ["Damage"] = 15, 
            ["BiteCooldown"] = 5,  
        }
    },

}

CombatData.PlantsAttacks = {
    
    ["Peashooter"] = {
        ["Shoot"] = {
            ["Size"] = 4,
            ["AttackType"] = "Projectile",
            ["ShootCooldown"] = 3, 
        }, 
    }, 
}

return CombatData 