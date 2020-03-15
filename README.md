# GD50
A repository to hold projects created by following the Harvard Game Development online course (lua + Love2D, Unity)

Games created:
1. [Pong](https://github.com/Ruta9/GD50/blob/master/README.md#1-pong)
2. [Flappy Bird](https://github.com/Ruta9/GD50/blob/master/README.md#2-flappy-bird)
3. [Breakout](https://github.com/Ruta9/GD50/blob/master/README.md#3-breakout)
4. [Match-3](https://github.com/Ruta9/GD50/blob/master/README.md#3-match-3)

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

#### 3. Match-3

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
