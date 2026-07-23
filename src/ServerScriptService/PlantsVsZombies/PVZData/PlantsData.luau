local PlantsData = {
    
    ["Peashooter"] = {
        ["Damage"] = 20, 
        ["HP"] = 100, 
        ["MaxHP"] = 100, 
        ["ShootCooldown"] = 3,
        ["Defense"] = 20,
        ["Class"] = "Shooter",
        ["SunPrice"] = 100, 
        ["SpawnCooldown"] = 20,

    },

    ["Wallnut"] = {
        ["HP"] = 400,
        ["MaxHP"] = 400, 
        ["Defense"] = 150,
        ["Class"] = "Tank",
        ["SunPrice"] = 50,
        ["SpawnCooldown"] = 100, 
        ["ModelName"] = "Wallnut",
    },

    ["Sunflower"] = {
        ["HP"] = 15,
        ["MaxHP"] = 15,
        ["SpawnSunCooldown"] = 10,
        ["Defense"] = 1,
        ["Class"] = "Support",
        ["SunPrice"] = 50, 
        ["SpawnCooldown"] = 10, 
        ["ModelName"] = "Sunflower"
    }   

}

return table.freeze(PlantsData)