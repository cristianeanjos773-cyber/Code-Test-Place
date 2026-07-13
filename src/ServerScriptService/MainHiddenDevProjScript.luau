--Discord name:cri5one --Roblox Username: Cri5one

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

local DataFolder = ServerScriptService:FindFirstChild("Data") :: Folder
local DataModuleManager = require(DataFolder:FindFirstChild("DataModuleManager"))

local CleanTaskProx = workspace:FindFirstChild("CleanPartTask"):FindFirstChild("TaskCleanProx") :: ProximityPrompt

local MainModule = {}
MainModule.PlayersInCleanTask = {}

setmetatable(MainModule.PlayersInCleanTask, {__mode = "k"}) -- in a real project we would use this to avoid a memory leak. 
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

MainModule.QuestStrings = table.freeze({
    ["GeneratorQuest"] = {
        ["LevelRequired"] = 0, 
        ["QuestName"] = "GeneratorQuest",
        ["CoinsReward"] = 30, 
        ["XPReward"] = 20, 
    }, 

    ["CleanTaskQuest"] = {
        ["LevelRequired"] = 2, 
        ["QuestName"] = "CleanTaskQuest",
        ["CoinsReward"] = 70, 
        ["XPReward"] = 60, 
    }, 
})

MainModule.QuestFunctions = table.freeze({ --[[
    this table holds all functions that can be called depending on the key of the question, 
    so it centralizes all functions in a compact table
    helping debugging because it removes the need to search for bugs in many nested if's, and also improving code readability
    ]]
    
    ["GeneratorQuest"] = function(Player: Player) 

    end, 

    ["CleanQuestTask"] = function(Player: Player)
            local Character = Player.Character
            local TrashFolder = workspace:FindFirstChild("TrashFolder") :: Folder

            MainModule.PlayersInCleanTask[Player] = 0 :: number -- Still hasnt cleaned any trash 

            local function ReturnTrashString() 

                local TrashTagsArray = table.freeze({
                    "LightTrash",
                    "MediumTrash",
                    "HeavyTrash",
                 })
            
                local RandomNumberChoise = math.random(1, #TrashTagsArray) -- this is the number the code will use to determine the trash's tag
                local ChosenString = TrashTagsArray[RandomNumberChoise] :: string
                return ChosenString

            end         

        local function CreateAndSpawnTrash()

                local TrashTagTraits = table.freeze({ -- a table is made to save the information each port will have according to their tag 
                
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

                
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") :: BasePart              
                local ChosenTag = ReturnTrashString()
            
                local TrashPart = Instance.new("Part")
                local TrashProximityPrompt = Instance.new("ProximityPrompt")
                local RandomCFrameNumber = math.random(1, 5)

                local HumanoidRootPosition = HumanoidRootPart.Position
                local HumanoidRootLookVector = HumanoidRootPart.CFrame.LookVector

                TrashPart.Name = ChosenTag -- the tag string is also used for the Part's name 
                TrashPart.Color = TrashTagTraits[ChosenTag]["InitialColor"]
                TrashPart.Size = TrashTagTraits[ChosenTag]["InitialSize"]


                local SpawnPointPosition = HumanoidRootPosition + HumanoidRootLookVector * RandomCFrameNumber 

                TrashPart.CFrame = CFrame.new(SpawnPointPosition) --[[
                This line makes the position of the trashpart to be chosen according to the specific positions of each lookvector element.
                ]]
                TrashPart.Parent = TrashFolder -- insted of passing the parent as a second argument of instance.new() we declare it as the last property for optimization purposes

                local ProxActionText = `Clean {TrashPart.Name}`

                TrashProximityPrompt.Name = "Clean Trash"
                TrashProximityPrompt.ObjectText = "Press To Start Cleaning"
                TrashProximityPrompt.ActionText = ProxActionText
                TrashProximityPrompt.HoldDuration = TrashTagTraits[ChosenTag]["SecondsToClean"]

                CollectionService:AddTag(TrashPart, ChosenTag)

        end

        CreateAndSpawnTrash() 


        local function OnCleanedPartEffects(TrashPart: Part)
             
            local tweeinfo = TweenInfo.new(Random.new():NextNumber(0, 1)) -- we use random.new() instead of math.random to be able to get decimate numbers between 0.1 to 1. 
             
             local TweenGoals = {
                
                ["LightTrashTweenGoals"] = {
                    ["Size"] = Vector3.new(0, 0,  0),
                    ["Color"] = Color3.fromRGB(255, 255, 255),
                },

                ["MediumTrashGoals"] = {
                    ["Size"] = Vector3.new(0, 0,  0),
                    ["Color"] = Color3.fromRGB(155, 211, 55),
                },

                ["HeavyTrashGoals"] = {
                    ["Size"] = Vector3.new(0, 0,  0),
                    ["Color"] = Color3.fromRGB(15, 255, 55),
                }, 

             }

             local TableGoalString = TrashPart.Name .. "Goals" :: string 

             local TrashTween = TweenService:Create(TrashPart, tweeinfo, TweenGoals[TableGoalString]) 

             TrashTween:Play() 
             
             TrashTween.Completed:Connect(function() 
                TrashTween:Destroy() -- as the tween instance would still be alive consuming memory even though not being used anymore, we destroy it. 
                TrashTween = nil -- but the script reference would still be alive, so we set the variable to nil for the GC to collect it 
             end)
                
             
        end

        local function OnCleanEvent() 
            for _, ProximityPrompts in DataFolder:GetDescendants() do 
                if ProximityPrompts:IsA("ProximityPrompt") then 
                    ProximityPrompts.Triggered:Connect(function()
                        local TrashPart = ProximityPrompts.Parent :: BasePart
                        OnCleanedPartEffects(TrashPart)
                        MainModule.PlayersInCleanTask[Player] = MainModule.PlayersInCleanTask[Player] + 1 
                    end)
                end 
            end 
        end 

        local function OnTaskCompleted() 
            local CleanQuest = MainModule.QuestStrings["CleanTaskQuest"]
            DataModuleManager.ManageLevel(Player, CleanQuest["XPReward"])
            DataModuleManager.ManageCoins(Player, CleanQuest["CoinsReward"])
        end
        
        if MainModule.PlayersInCleanTask[Player] == 5 then 
            OnTaskCompleted()
        end 

    end,
    

})



function MainModule.InsertQuestRequest(Player: Player, RequestedQuest: string) -- this is a function which'll take care of Receveiving wished requested Quests and approving them or not.
    -- in this function we use the Early return method some times to avoid IF and ELSEIF nesting once again. This also improves readability 
    local CurrentPlayerQuest = Player:GetAttribute("CurrentQuest") :: string

    if RequestedQuest == CurrentPlayerQuest then
        return -- Cancels the requestedquest because the player is already doing the quest requested
    end

    if CurrentPlayerQuest ~= "" then 
        return -- If the player tries to somehow ask for another task while being on another task, this return cancels the request  
    end 
    
    local QuestLevelRequired = MainModule.QuestStrings[RequestedQuest]["LevelRequired"] 
    local PlayerLevel = DataModuleManager.Profile[Player].Data["Level"] :: number

    if QuestLevelRequired > PlayerLevel then 
        return -- if the Level required to do the task is greater than player level, cancel.
    end

    local QuestTableFunction = MainModule.QuestFunctions[RequestedQuest]

    Player:SetAttribute("CurrentQuest", RequestedQuest) -- after all of the above conditions are NOT met, the player finally gets assigned to their task
    QuestTableFunction(Player) -- The Quest Function gets called, passing Player as its first argument. 

end 

CleanTaskProx.Triggered:Connect(function(Player)
    MainModule.InsertQuestRequest(Player, MainModule.QuestStrings["CleanTaskQuest"])
end)

return MainModule