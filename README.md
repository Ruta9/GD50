# GD50
A repository to hold projects created by following the Harvard Game Development online course (lua + Love2D, Unity)

Author of the games and their code is Colton Ogden, cogden@cs50.harvard.edu.
Assignments and various customizations are made by the author of this repository.

Games created:
1. [Pong](https://github.com/Ruta9/GD50/blob/master/README.md#1-pong)
2. [Flappy Bird](https://github.com/Ruta9/GD50/blob/master/README.md#2-flappy-bird)
3. [Breakout](https://github.com/Ruta9/GD50/blob/master/README.md#3-breakout)
4. [Match-3](https://github.com/Ruta9/GD50/blob/master/README.md#4-match-3)
5. [Mario](https://github.com/Ruta9/GD50/blob/master/README.md#5-mario)
6. [Legend of Zelda](https://github.com/Ruta9/GD50/blob/master/README.md#6-legend-of-zelda)
7. [Angry Birds](https://github.com/Ruta9/GD50/blob/master/README.md#7-angry-birds)

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



