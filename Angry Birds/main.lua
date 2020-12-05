-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 6 => "Angry Birds"
-- Made by Ruta Jankauskaite, following the tutorial

--[[ Assignment 6: 
    1.Implement it such that when the player presses the space bar after 
    they’ve launched an Alien (and it hasn’t hit anything yet), split the 
    Alien into three Aliens that all behave just like the base Alien.

    What's done:
    1. in Level.lua, 2 new flags added, multiplied and playerCollided, which are used for
    checking if we are still able to use the spacebar feature. playerCollided is set in
    the callbacks for box2d, while multiplied is set after pressing the spacebar.
    A rule for respawning launchMarker also changed - now we check if all aliens have stopped.
    2. AlienLaunchMarker.lua now has a table of player aliens instead a field containing
    only one alien. All update and render functions changed accordingly.
    
]]  

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Angry 50')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    paused = false
end

function push.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'p' then
        paused = not paused
    end

    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.update(dt)
    if not paused then
        gStateMachine:update(dt)

        love.keyboard.keysPressed = {}
        love.mouse.keysPressed = {}
        love.mouse.keysReleased = {}
    end
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end