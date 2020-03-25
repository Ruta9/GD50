-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 4 => "Mario"
-- Made by Ruta Jankauskaite, following the tutorial


--[[
    Assignment 4:
    1. Program it such that when the player is dropped into the level, they’re always done so above solid ground
    2. In LevelMaker.lua, generate a random-colored key and lock block 
    (taken from keys_and_locks.png in the graphics folder of the distro). The key should 
    unlock the block when the player collides with it, triggering the block to disappear.
    3. Once the lock has disappeared, trigger a goal post to spawn at the end of the level. 
    Goal posts can be found in flags.png; feel free to use whichever one you’d like! 
    Note that the flag and the pole are separated, so you’ll have to spawn a GameObject 
    for each segment of the flag and one for the flag itself
    4. When the player touches this goal post, we should regenerate the level, spawn the player at the beginning of it again 
    (this can all be done via just reloading PlayState), and make it a little longer than it was before.
   
    What's done:
    1. LevelMaker.lua -> first tile ignored in empty space generation (otherwise, could be done in a similar
    way on how the Snail is spawned, but then the player should be transfered to some other tile,
    which I did not want to do, as it would look odd)
    2. LevelMaker.lua -> key and lock generation. Key is generated randomly in first 80% of the map,
    and the lock in the rest 20% of the map. GameObject has a property 'scroll', which 
    allows for a fun effect: when a key is picked up, it is shown under the score. (scroll is
    for object scroll with the camera).
    3. LevelMaker.lua -> Flag is generated on lock's consume, randomly in the last 10% of the map.
    4. LevelMaker.lua -> once the flag is consumed, PlayState is re-loaded, with levelLength multiplied by 1.5

    Bonus implementation:
    Player walking speed increases when left/right shift is held down.

]]

require 'src/Dependencies'


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Mario')
    
    math.randomseed(os.time())
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function () return StartState() end,
        ['play'] = function () return PlayState() end
    }

    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.5)
    gSounds['music']:play()
    
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

