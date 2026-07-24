local ZombiesData = {
    
    ["ClassicZombie"] = {
       ["HP"] = 30,
       ["MaxHP"] = 30,
       ["BiteDamage"] = 10, 
       ["BiteCooldown"] = 5,    
       ["ModelName"] = "ClassicZombie", 
       ["Class"] = "CommonZombie",
    },

    ["ConeHeadZombie"] = {
        ["BiteDamage"] = 15,
        ["HP"] = 40, 
        ["MaxHP"] = 40,
        ["BiteCooldown"] = 5,
        ["ModelName"] = "ConeHeadZombie",
        ["Class"] = "CommonZombie",
    },

    ["BucketHeadZombie"] = {
        ["BiteDamage"] = 15,
        ["HP"] = 50,
        ["MaxHP"] = 50,
        ["BiteCooldown"] = 5,
        ["ModelName"] = "BucketHeadZombie",
        ["Class"] = "CommonZombie",
    },


}
return ZombiesData 