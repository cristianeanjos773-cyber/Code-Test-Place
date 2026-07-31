# Plants Vs Zombies Replica

**Plants Vs Zombies replica was a solo serious project i started developing in mid 2026
It was a project focused on scalable architecture, Object Oriented Programming, Service Oriented Programming Modular, Single Responsability Principle, Server-Client architecture and clean Code**

## Architecture:

## Models are responsible for:
**-Visual Representation**
**-Animations**
**Factory Pattern**


## OOP Objects are resonsible for:
**Methods (PlantDie, Zombie Die, etc)**
**Status** (HP, Etc)
**Combat Logic** 
**Cooldows management**
**Model LifeCycle** 

## Services

### Server-Sided Services:
**CooldownService** -- This service is responsible for starting the Object cooldown to do its action requested, Start the OOP Object Cooldown on a certain action, and return the remaining cooldown of the object to perform an action. 
**CombatService** -- This service is responsible for creating server-sided hitboxes with spherecasting, it validates the attack and then choose which hitbox it should create based on data. And also what it should do based on the AttackData (that comes from CombatData) 
**SunPlayerService** -- This service is responsible for Tweening the physical suns and managing the Sun's leaderstats on player 
**ZombieSpawnService** -- Takes care of spawning the zombies in an inifite loop 
**PVZObjectDataService** -- Holds the function to connect the OOP to its model and vice versa (BiDirectional Reference with the OOPObjectModel and OOPObject Tables) and to disconnect it, destroy the OOP object and its model. 
**SpawnService** -- SpawnService takes care of Using PVZObject ConnectModelToOOP() function to connect the Model SpawnService creates to it's Object 
**PvZShopService** -- Responsible for validating if the player has enough coins to buy a new plant and calling data stores to put this new plant inside of the player's inventory 

### Client-Sided Services:
**VisualHitboxService** -- As the visuals should be separated from the server, this service does exactly that, it separates the mathematical hitboxes managed by the server and make them client visible 
**VisualObjectsMovement** -- for the same reason as the latter, this controls the object's model movements, movements that are not necessary for the server to update, for example The shooter's aim 

## PlantsClasses:

**RootPlantsClass** -- Holds all the methods every plant will have and creates new objects 
**PlantsClassesData** -- Holds all plant status
**ShooterClass** -- Responsible for shooter methods and shooter logic
**SupportClass** -- Responsible for Support methods and Support logic
**TankClass** -- Responsible for Tank methods and Tank logic

## ZombiesClasses:

**RootZombiesClass** -- Holds all the methods every Zombie will have and creates new objects 
**ClassicZombiesClass** Responsible for Classic Zombies methods and  Classic Zombie logic


**Video showcase:** https://www.youtube.com/watch?v=2GfqCwjA4mo
