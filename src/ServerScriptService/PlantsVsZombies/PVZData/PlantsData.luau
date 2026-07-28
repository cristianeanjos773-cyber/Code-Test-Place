local PlantsData = {
    
    ["Peashooter"] = {
        ["Damage"] = 20, 
        ["HP"] = 100, 
        ["MaxHP"] = 100, 
        ["Defense"] = 20,
        ["Name"] = "Peashooter",
        ["Class"] = "Shooter",
        ["Team"] = "Plants",
        ["SunPrice"] = 100, 
        ["SpawnCooldown"] = 20,
    },

    ["Wallnut"] = {
        ["HP"] = 400,
        ["MaxHP"] = 400, 
        ["Defense"] = 3,
        ["Name"] = "Wallnut",
        ["Team"] = "Plants",
        ["Class"] = "Tank",
        ["SunPrice"] = 50,
        ["SpawnCooldown"] = 100,
        ["Phase1Scale"] = 0.7,
        ["FinalPhaseScale"] = 0.5, 
        ["ModelName"] = "Wallnut",
    },

    ["Sunflower"] = {
        ["HP"] = 30,
        ["MaxHP"] = 30,
        ["SpawnSunCooldown"] = 10,
        ["Defense"] = 1,
        ["Team"] = "Plants",
        ["Class"] = "Support",
        ["Name"] = "Sunflower",
        ["SunPrice"] = 50, 
        ["SpawnCooldown"] = 10, 
        ["ModelName"] = "Sunflower"
    }   

}

return table.freeze(PlantsData)