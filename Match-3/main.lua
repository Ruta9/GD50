-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 4 => "Match-3"
-- Made by Ruta Jankauskaite, following the tutorial

--[[ Assignment 3: Match-3, The Shiny Update
    1. Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match
    2. Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), 
    with later levels generating the blocks with patterns on them (like the triangle, cross, etc.). 
    These should be worth more points, at your discretion.
    3. Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row
    4. Only allow swapping when it results in a match. 
    5. If there are no matches available to perform, reset the board
    6. (Optional) Implement matching using the mouse. (Hint: you’ll need push:toGame(x,y); see the push library’s documentation here for details!

    What's done:
    1. Easy change in PlayState.lua
    2. 
        2.1 Board.lua gets currentLevel and generates the board's tile's variety by taking the current level into account.
            Every 6th level tiles' variety pattern repeats.
        2.2 PlayState.lua adds additional 10 * tile's variety score when the match is found.
    3.  in Board.lua, 2 new functions added: countPowerups, to determine how many powerups on the board we already have, and
        setAsPowerUp, which determines whether the generated tile can be a powerup. For "shiny", color change was implemented,
        similar to the StartState screen (different variantions of yellow used).
    4.  
        4.1 new function in Board.lua: randomizeColors, which sets current level's tile's colors (number of colors taking into account the 
            current level + randomizing the colors)
        4.2 new function in PlayState.lua: revertLatestSwap, which reverts latest swap, saved in self.swappedTiles right after the initial swap.
    5.  Board.lua 2 new functions: isAPotentialMatch and calculatePotentialMatches. 
        PlayState.lua function: shuffle, which suffles the board if there are no potential matches. The shuffling is repeated as long as
        there are no potential matches found (potential matches check is also added to the initial board generation check)
    6.  Not implemented.

    // After getting the needed score to pass to another level, it was a bit confusing as it happened immediately.
       1 second delay was added.


]]

require 'src/Dependencies'


-- Init
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Match 3')

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
 
    -- Global game music
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- Init state machine
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }

    -- set state to start
    gStateMachine:change('start')

    -- input
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
	love.graphics.clear(0,0,0,1)
    gStateMachine:render()
    push:finish()
end


