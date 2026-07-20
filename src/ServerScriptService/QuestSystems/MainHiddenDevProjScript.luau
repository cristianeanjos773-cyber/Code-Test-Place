--Discord name:cri5one --Roblox Username: Cri5one

--[[

This code is a task system, which follows a scope like:
[
----------------------------------------------------------
Player receives CurrentQuest attribute thourgh the function called "InsertAttributes()" 
Player activates proximity prompt related to the quest ->
The Quest Validator function called "InsertQuestRequest" validates whether the player can get that task ->
Puts QuestName as an Attribute Into Player's Current Quest Attribute
The QuestName string goes to the QuestFunctions
The CleanTaskQuest then puts the player as a key to a value (which is the amount of times that player has cleaned the trash)
then pseudo classes are created for each type of trash "lighttrash", etc, these classes determine the trash properties (color, size, etc)
Then we generate a random string for the next trash that is gonna spawn, on the function "ReturnTrashString()"
Then The CrateAndSpawn() function is called, it creates the trash parts, sets the trash properties including position (SpawnPointPosition variable) based on the chosen string returned by ReturnTrashString()
OnCleaned() function gets activated, the proximity prompt gets connect then each time the event fires, it:
Checks if the trigerring player is the same player received in the CleanQuestTask function (to avoid someone from stealing another's player task
Increases the Player's trash claned value on the dictionary called .PlayersInCleanTask, using the player key to access its value 
Calls OnCleanedPartEffects() to tween the trash part after it gets cleaned
Disconnect the OnCleanedConnection
Verifies if the value of the player in PlayersInCleanTask is equal to 5
if it is it calls the function OnTaskCompleted() 
if it is not it calls the function CreateAndSpawnTrash()

    (this only counts for the first task, clean part task)
----------------------------------------------------------
]

The DataModuleManager only takes care of changing the player's data with profile store. Its a wrapper around profile store, it doesnt manipulate the Quest Logic seen on the script.
The Reason why the ProfileStore system is not inside this module is because both have different resposabilities, (SRP)
Instead, its in a separate folder called Data in ServerSciptServer on the repository.
]]

local Players = game:GetService("Players")
local ServerScriptServiceFolder = game:GetService("ServerScriptService"):FindFirstChild("ServerScriptService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local DataFolder = ServerScriptServiceFolder:FindFirstChild("Data") :: Folder
local DataModuleManager = require(DataFolder:FindFirstChild("DataModuleManager"))

local ParkourFolder = workspace:FindFirstChild("ParkourFolder")
local ParkourEndPart = ParkourFolder:FindFirstChild("ParkourEndPart") :: Part
local ParkourPart3 = ParkourFolder:FindFirstChild("ParkourPart3") :: Part

local MainModule = {}


MainModule.PlayersInQuest = {
    ["CleanTaskQuest"] = {},
    ["ParkourQuest"] = {},
}

--MainModule.PlayerConnections = {} -- this table will store Connections to each player, so we can disconnect all connections at the same time in a for loop, avoiding memory leaks. (not to be used now as theres no need.)

MainModule.MaxTrash = 5 
MainModule.ParkourEndPartSpeed = 90 

setmetatable(MainModule.PlayersInQuest["CleanTaskQuest"], {__mode = "k"}) -- in a real project we would use this to avoid a memory leak. 
setmetatable(MainModule.PlayersInQuest["ParkourQuest"], {__mode = "k"})
--setmetatable(MainModule.PlayerConnections, {__mode = "k"})

-- if the player leaves and we dont use this, the data related to that player will be in the server's RAM 
-- if we had for example 100 and 100 of these players left, we'd have 100 ghost players, gone from the workspace, but still occupying RAM. This can cause severe lags and crash if taken to extremes. 

--table.freeze() will be used for tables that aren't supposed to change, in a project with many scripters this could prevent bugs. 
--If someone added something that for example, if a table that maps strings to certain functions (dispatch table) doesnt have the new element someone added in a table which has these strings, the system may glitch somehow.

MainModule.PlayerAttributes = table.freeze({ -- this table holds all values that will be inserted in player's instance
    ["CurrentQuest"] = "",
})

function MainModule.InsertAttributes() 
    
    -- that's an internal function to avoid using unnecessary repetition using duplicated code on the event AND in the for loop. 
    local function SetUpPlayerAttributes(Player: Player) 
         for AttributeNames, AttributesValues in MainModule.PlayerAttributes do --[[When the player joins, the for loop does:
            1. Loops through PlayerAttributes Dictionary
            2. Gets its keys and its values 
            ]] 
            Player:SetAttribute(AttributeNames, AttributesValues) 
            --[[
            And after doing so, this line inserts The AttributeKey as the name of the Player's attribute and also the value of said attribute
            This way is better because if we want to add lots of attributes in the future, we dont need to repeat many times Player:SetAttribute(X, Y)
            instead we need to just add one key and one new value on the PlayerAttributes string             
            ]] 
        end 
    end
    
    --this event listens do the players that joined now 
    Players.PlayerAdded:Connect(SetUpPlayerAttributes)
    
    -- this for loop makes sure that the players who joined before the module script loaded also receive the attributes 
    for _, PlayersInstances in Players:GetPlayers() do 
        task.spawn(SetUpPlayerAttributes, PlayersInstances)
    end 

end 

MainModule.InsertAttributes()

MainModule.QuestConfig = table.freeze({
    
    ["CleanTaskQuest"] = {
        ["LevelRequired"] = 0, 
        ["QuestName"] = "CleanTaskQuest",
        ["CoinsReward"] = 70, 
        ["XPReward"] = 60, 
    }, 

    ["ParkourQuest"] = {
        ["LevelRequired"] = 2,
        ["QuestName"] = "ParkourQuest",
        ["CoinsReward"] = 90,
        ["XPReward"] = 100, 
    },

})

MainModule.TrashTagTraits  = table.freeze({ -- a table is made to save the information each port will have according to their tag 
                
    ["LightTrash"] = {
        ["SecondsToClean"] = 3,
        ["InitialColor"] = Color3.fromRGB(51, 0, 255),
        ["InitialSize"] = Vector3.new(1,1,1),
    },

    ["MediumTrash"] = {
        ["SecondsToClean"] = 7, 
        ["InitialColor"] = Color3.fromRGB(255, 230, 2),
        ["InitialSize"] = Vector3.new(5,5,5),
    }, 

    ["HeavyTrash"] = {
        ["SecondsToClean"] = 12, 
        ["InitialColor"] = Color3.fromRGB(255, 6, 6),
        ["InitialSize"] = Vector3.new(10,10,10),
     }, 

})

MainModule.TweenGoals = table.freeze({
                
    ["LightTrashTweenGoals"] = {
        ["Size"] = Vector3.new(0, 0,  0),
        ["Color"] = Color3.fromRGB(255, 255, 255),
    },

    ["MediumTrashTweenGoals"] = {
        ["Size"] = Vector3.new(0, 0,  0),
        ["Color"] = Color3.fromRGB(155, 211, 55),
    },

     ["HeavyTrashTweenGoals"] = {
        ["Size"] = Vector3.new(0, 0,  0),
        ["Color"] = Color3.fromRGB(15, 255, 55),
    }, 

    ["ParkourEndPartGoal"] = {
        ["Transparency"] = 1, 
        ["Color"] = Color3.fromRGB(0, 3, 2)
    },

    ["ParkourPart3Goal1"] = {
        ["Position"] = Vector3.new(-23, 8.5, -18),
        ["Color"] = Color3.fromRGB(255, 0, 0)
    },

    ["ParkourPart3Goal2"] = {
        ["Position"] = Vector3.new(-54, 8.5, -18),
        ["Color"] = Color3.fromRGB(0, 0, 0)
    },

})

MainModule.TrashTagsArray = table.freeze({
    "LightTrash",
    "MediumTrash",
    "HeavyTrash",
})

MainModule.TweenInfoMoveParkourPart3 = TweenInfo.new(5)

MainModule.Tweens = table.freeze({
    ["PartParkourtween1"] = TweenService:Create(ParkourPart3, MainModule.TweenInfoMoveParkourPart3, MainModule.TweenGoals["ParkourPart3Goal1"]),
    ["PartParkourtween2"] = TweenService:Create(ParkourPart3, MainModule.TweenInfoMoveParkourPart3, MainModule.TweenGoals["ParkourPart3Goal2"]),
    ["ParkourEndPartGoaltween"] = TweenService:Create(ParkourEndPart, MainModule.TweenInfoMoveParkourPart3, MainModule.TweenGoals["ParkourEndPartGoal"]),
})


MainModule.QuestFunctions = table.freeze({ --[[
    this table holds all functions that can be called depending on the key of the question, 
    so it centralizes all functions in a compact table
    helping debugging because it removes the need to search for bugs in many nested if's, and also improving code readability
    ]]
    

    ["CleanTaskQuest"] = function(Player: Player)
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local TrashFolder = workspace:FindFirstChild("TrashFolder") :: Folder

            MainModule.PlayersInQuest["CleanTaskQuest"][Player] = 0 :: number -- Still hasnt cleaned any trash 

            local function ReturnTrashString() 
                local RandomNumberChoise = math.random(1, #MainModule.TrashTagsArray) -- this is the number the code will use to determine the trash's tag
                local ChosenString = MainModule.TrashTagsArray[RandomNumberChoise] :: string
                return ChosenString
            end

        local function OnCleanedPartEffects(TrashPart: Part)
             
             local RNG = Random.new()

             local tweeinfo = TweenInfo.new(RNG:NextNumber(0, 1)) -- we use random.new() instead of math.random to be able to get decimate numbers between 0.1 to 1. 
             
             local TableGoalString = TrashPart.Name .. "TweenGoals" :: string 

             local TrashTween = TweenService:Create(TrashPart, tweeinfo, MainModule.TweenGoals[TableGoalString]) 

             TrashTween:Play() 
             
             TrashTween.Completed:Connect(function() 
                TrashTween:Destroy() -- as the tween instance would still be alive consuming memory even though not being used anymore, we destroy it. 
                TrashPart:Destroy()
                TrashTween = nil -- but the script reference would still be alive, so we set the variable to nil for the GC to collect it 
                -- here there is no need to disconnect the connection because when TrashTween is deleted, it destroys everything connected to it due to GC (Garbage Collector), avoiding memory h leak. 
             end)

        end    

        local function CreateAndSpawnTrash()
                
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") :: BasePart              
                local ChosenTag = ReturnTrashString()
            
                local TrashPart = Instance.new("Part")
                local TrashProximityPrompt = Instance.new("ProximityPrompt")
                local RandomCFrameNumber = math.random(1, 5)

                local HumanoidRootPosition = HumanoidRootPart.Position
                local HumanoidRootLookVector = HumanoidRootPart.CFrame.LookVector

                TrashPart.Name = ChosenTag -- the tag string is also used for the Part's name 
                TrashPart.Color = MainModule.TrashTagTraits[ChosenTag]["InitialColor"]
                TrashPart.Size = MainModule.TrashTagTraits[ChosenTag]["InitialSize"]


                local SpawnPointPosition = HumanoidRootPosition + HumanoidRootLookVector * RandomCFrameNumber 

                TrashPart.CFrame = CFrame.new(SpawnPointPosition) --[[
                This line makes the position of the trashpart to be chosen according to the specific positions of each lookvector element.
                ]]
                TrashPart.Parent = TrashFolder -- insted of passing the parent as a second argument of instance.new() we declare it as the last property for optimization purposes

                local ProxActionText = `Clean {TrashPart.Name}`

                TrashProximityPrompt.Name = "Clean Trash"
                TrashProximityPrompt.ObjectText = "Press To Start Cleaning"
                TrashProximityPrompt.ActionText = ProxActionText
                TrashProximityPrompt.HoldDuration = MainModule.TrashTagTraits[ChosenTag]["SecondsToClean"]
                TrashProximityPrompt.Parent = TrashPart

                local function OnCleaned() 
                    local OnCleanedConnection
                   
                    
                    OnCleanedConnection = TrashProximityPrompt.Triggered:Connect(function(TriggeringPlayer: Player) -- we assign the connection variable to the connection function so we can disconnect it when its purpose is finished.
                        if TriggeringPlayer ~= Player then
                            return -- this Return avoids other players from cleaning trash that belongs to another player's task 
                        end

                        MainModule.PlayersInQuest["CleanTaskQuest"][Player] = MainModule.PlayersInQuest["CleanTaskQuest"][Player] + 1 
                        OnCleanedPartEffects(TrashPart) 
                        OnCleanedConnection:Disconnect() -- we disconnect the connection to avoid a memory leak, which in a game with many players could become a problem.  
                        OnCleanedConnection = nil

                        if MainModule.PlayersInQuest["CleanTaskQuest"][Player] == MainModule.MaxTrash then 
                            MainModule.OnTaskFinished(Player, MainModule.QuestConfig["CleanTaskQuest"]["QuestName"])
                        else
                            CreateAndSpawnTrash()
                        end 

                    end)
                end
            CollectionService:AddTag(TrashPart, ChosenTag)
            OnCleaned()
        end
        CreateAndSpawnTrash() 
    end,

    ["ParkourQuest"] = function() end,

    -- The reason why the parkourquest is empty is because there are no individual things that should be supposed to be used to the player specifically, most of the parkour mechanics can be managed globally
})


function MainModule.InsertQuestRequest(Player: Player, RequestedQuest: string) -- this is a function which'll take care of Receveiving wished requested Quests and approving them or not.
    -- in this function we use the Early return method some times to avoid IF and ELSEIF nesting once again. This also improves readability 
    local CurrentPlayerQuest = Player:GetAttribute("CurrentQuest") :: string
    
    if CurrentPlayerQuest ~= "" then 
        return -- If the player tries to somehow ask for another task while doing another task OR trying to request the same quest, this return cancels the request  
         -- this prevents from the player requesting the task if theyre already doing it 
         -- the reason of why not sending a remote event and making the proximity prompt locally deacticvated is to obey the rule of not spreading the code
    end 
    
    local QuestLevelRequired = MainModule.QuestConfig[RequestedQuest]["LevelRequired"] 
    local PlayerLevel = DataModuleManager.Profile[Player].Data["Level"] :: number

    if QuestLevelRequired > PlayerLevel then 
        return -- if the Level required to do the task is greater than player level, cancel the request.
    end

    local QuestTableFunction = MainModule.QuestFunctions[RequestedQuest]

    Player:SetAttribute("CurrentQuest", RequestedQuest) -- after all of the above conditions are NOT met, the player finally gets assigned to their task
    QuestTableFunction(Player) -- The Quest Function gets called, passing Player as its first argument. 

end 

function MainModule.QuestProximityPromptFunction() -- this function requests the quest based on the proximity prompt attribute which holds the task name
    -- its made like this so we dont need to make a new event for each proximity prompt task trigger, it scales better that way and makes developing faster 
    local QuestProximityPromptTag = CollectionService:GetTagged("QuestProximityPrompt")


    
    for _, ProximityPrompts in QuestProximityPromptTag do 
         ProximityPrompts.Triggered:Connect(function(Player) 
            local QuestRequest = ProximityPrompts:GetAttribute("QuestRequest") :: string 
            MainModule.InsertQuestRequest(Player, QuestRequest)
        end)
    end 

end 

MainModule.QuestProximityPromptFunction()

-- this is the function that'll be used to disconnect player RBXConnections. 
--[[function MainModule.DisconnectPlayerConns(Player: Player) 
    for _, Connections in MainModule.PlayerConnections[Player] do 
        Connections:Disconnect() 
        Connections = nil 
    end 
end (just saving it.)]]

function MainModule.OnTaskFinished(Player: Player, QuestName: string) -- everytime a task is completed, a task function will call this function and pass its questName 
    --This makes us not repeat the effects of each task manually for EACH task.
    local QuestConfigTable = MainModule.QuestConfig[QuestName] :: {{[string]: any}}
    MainModule.PlayersInQuest[QuestName][Player] = nil 
    Player:SetAttribute("CurrentQuest", "")
    DataModuleManager.ManageLevel(Player, QuestConfigTable["XPReward"])
    DataModuleManager.ManageCoins(Player, QuestConfigTable["CoinsReward"])
end 

function MainModule.MovePartParkour3()            
    
    local PartParkourTween1 = MainModule.Tweens["PartParkourtween1"]
    local PartParkourtween2 = MainModule.Tweens["PartParkourtween2"]
    PartParkourTween1:Play()

    PartParkourTween1.Completed:Connect(function() 
        PartParkourtween2:Play()
    end)

    PartParkourtween2.Completed:Connect(function() 
        PartParkourTween1:Play()
    end)

end

function MainModule.SpinParkourEndPart()
    RunService.Heartbeat:Connect(function(DeltaTime)
        local Rotation = CFrame.Angles(0, math.rad(MainModule.ParkourEndPartSpeed * DeltaTime), 0)
        ParkourEndPart.CFrame = ParkourEndPart.CFrame * Rotation
    end)
end

function MainModule.ParkourEndPartTouched()

    if ParkourEndPart.Transparency ~= 0 then 
        ParkourEndPart.Transparency = 0 
    end 
    
    ParkourEndPart.Touched:Connect(function(OtherPart: BasePart) 

        if not OtherPart.Parent:FindFirstChild("Humanoid") then
            return 
        end

        local Player = Players:GetPlayerFromCharacter(OtherPart.Parent) :: Player?

        if Player:GetAttribute("CurrentQuest") ~= "ParkourQuest" then 
            return
        end

        ParkourEndPart.CanTouch = false 

        local TweeInfoParkourEnd = TweenInfo.new(1) 
        local ParkourEndTween = TweenService:Create(ParkourEndPart, TweeInfoParkourEnd, MainModule.TweenGoals["ParkourEndPartGoal"])   

        ParkourEndTween:Play()
             
        ParkourEndTween.Completed:Connect(function()
            ParkourEndTween:Destroy()
            ParkourEndTween = nil 
        end)
            
        MainModule.OnTaskFinished(Player, "ParkourQuest")

        task.wait(5)

        ParkourEndPart.CanTouch = true 
        ParkourEndPart.Color = Color3.fromRGB(255, 255, 127)
        ParkourEndPart.Transparency = 0 
    end)
end

MainModule.MovePartParkour3()
MainModule.SpinParkourEndPart()
MainModule.ParkourEndPartTouched()

return MainModule