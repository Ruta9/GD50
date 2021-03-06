# GD50
A repository to hold projects created by following the Harvard Game Development online course (lua + Love2D, Unity)

Author of the games and their code is Colton Ogden, the lecturer of GD50 Hardvard course.
Assignments and various customizations are made by the author of this repository.

##### Games created:

###### Lua + Love2D:
1. [Pong](#1-pong)
2. [Flappy Bird](#2-flappy-bird)
3. [Breakout](#3-breakout)
4. [Match-3](#4-match-3)
5. [Mario](#5-mario)
6. [Legend of Zelda](#6-legend-of-zelda)
7. [Angry Birds](#7-angry-birds)
8. [Pokemon](#8-pokemon)

###### Unity:
9. [Helicopter](#9-helicopter)
10. [Dreadhalls](#10-dreadhalls)
11. [Portal](#11-portal)

## Lua + Love2D

Games created using .lua scripting language and [Love2D](https://love2d.org/) framework. 

#### 1. Pong

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Pong1.PNG" width="600">

Covered topics:
- What is Lua & Love2D
- Drawing shapes & text
- DeltaTime, Velocity
- OOP
- Collisions
- Sound Effects

Assignment:
1. Implement an AI-controlled paddle (either the left or the right will do) such that
	it will try to deflect the ball at all times.

#### 2. Flappy Bird

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Flappy1.png" width="600">

Covered topics:
- Working with sprites
- Infinite Scrolling
- Procedural Generation (Pipes)
- State Machines (for different game states)

Assignment:
1. Randomize gaps between pipes
2. Randomize spawning intervals between pipe pairs
3. Award a medal for scores (3 different medals)
4. Pause feature when pressing "P"

#### 3. Breakout

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Breakout2.PNG" width="600">

Covered topics:
- Sprite Sheets
- Procedural Layout (random level generation)
- Levels
- Player Health
- Particle Systems
- Persistent Save Data (for highscores)

Assignment:
1. Add a powerup which spawns on timer or hitting a brick. Once collided with the paddle, 2 more balls should spawn, which should disappear after winning the level.
2. Paddle should shrink if the player loses a heart.
3. Add a locked brick and a key powerup. The locked Brick should not be breakable by the ball normally, unless they have the key Powerup.

#### 4. Match-3

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Match3_3.PNG" width="600">

Covered topics:
- Anonymous Functions
- Tweening
- Timers
- Procedural Grids
- Solving Matches (algorithm for match checking)

Assignment:
1. Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match
2. Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet),  with later levels generating the blocks with patterns on them (like the triangle, cross, etc.). These should be worth more points, at your discretion.
3. Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row
4. Only allow swapping when it results in a match. 
5. If there are no matches available to perform, reset the board
6. (Optional) Implement matching using the mouse. (Hint: you’ll need push:toGame(x,y); see the push library’s documentation here for details!

#### 5. Mario

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Mario3.png" width="600">

Covered topics:
- 2D Animation
- Tile maps
- Procedural Level Generation
- Basic AI
- Consumables, Game objects
- Player-focused Camera 

Assignment:
1. Program it such that when the player is dropped into the level, they’re always done so above solid ground
2. In LevelMaker.lua, generate a random-colored key and lock block (taken from keys_and_locks.png in the graphics folder of the distro). The key should unlock the block when the player collides with it, triggering the block to disappear.
3. Once the lock has disappeared, trigger a goal post to spawn at the end of the level.
4. When the player touches this goal post, we should regenerate the level, spawn the player at the beginning of it again (this can all be done via just reloading PlayState), and make it a little longer than it was before

#### 6. Legend of Zelda

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/legend-of-zelda-1.png" width="600">

Covered topics:
- Top-Down Perspective
- Infinite Dungeon Generation
- Hitboxes/Hurtboxes
- Events
- Screen Scrolling
- Data-Driven Design

Assignment:
1. Make some enemies drop hearts that would restore 2 health.
2. Spawn some pots in dungeon rooms, allow the player to lift it. Lifting and pot-carrying animations should be added. Pots can be used to damage the enemies by throwing them. They should disappear if they hit a wall, an enemy or traveled more than 4 tiles.

#### 7. Angry Birds

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Angry2.png" width="600">

Covered topics:
- Box2D
- Mouse input

Assignment:
1. Implement it such that when the player presses the space bar after they’ve launched an Alien (and it hasn’t hit anything yet), split the Alien into three Aliens that all behave just like the base Alien. The original Alien should stay the same, while the top Alien should go higher, the bottom one lower and their angle should be changed accordingly.

#### 8. Pokemon

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Pokemon2.png" width="600">

Covered topics:
- State Stacks
- Turn-Based Systems
- GUIs
- RPG Mechanics

Assignment:
1. Implement a Menu that appears during the player Pokémon’s level up that shows, for each stat, ‘X + Y = Z’ where X is the starting stat, Y is the amount it’s increased for this level, and Z is the resultant sum. This Menu should appear right after the “Level Up” dialogue that appears at the end of a victory where the player has indeed leveled up.


## Unity

Games created using Unity engine.

#### 9. Helicopter

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Helicopter1.png" width="600">

Covered topics:
- Unity
- C#
- Blender
- Components
- Colliders and Triggers
- Prefabs and Spawning
- Texture Scrolling
- Audio


Assignment:
1. Add Gems to the game that spawn in much the same way as Coins, though more rarely so. Gems should be worth 5 coins when collected and despawn when off the left edge of the screen.
2. Fix the bug whereby the scroll speed of planes, coins, and buildings doesn’t reset when the game is restarted via the space bar.

#### 10. Dreadhalls

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Dreadhalls4.png" width="600">

Covered topics:
- Texturing
- Materials and Lighting
- 3D Maze Generation
- First-Person Controllers
- Multiple Scenes
- Fog
- UI Components and Unity2D

Assignment:
1. Create gaps in the floor that the player can fall through.
2. When the player falls through the hole (approximately two blocks below), transition to a screen with "Game Over" text. Pressing "Enter" here should loop back to the Title Scene.
3. Add a "Text" object to the Play Scene that keeps track of how many levels the player has navigated through.

#### 11. Portal

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/Portal1.png" width="600">

Covered topics:
- Holding a Weapon
- Raycasting
- RenderTexture
- Texture Masking
- Decals
- Teleporting
- ProBuilder and ProGrids

Assignment:
1. Create your own level using ProBuilder! 
	- Level should be of reasonable complexity and include at least two different textures/materials (not including the default). 
	- Level must include an FPSController.
	- There must be at least one jumping puzzle for the player.
	- At the end of the level, there must be a collider with a trigger that makes "Level Complete" pop up on the screen.

###### Assignment:

<img src="https://github.com/Ruta9/GD50/blob/master/Screenshots/MyLevel3.png" width="600">

A recorded video can be found [here](https://github.com/Ruta9/GD50/blob/master/MyLevelVideo)


