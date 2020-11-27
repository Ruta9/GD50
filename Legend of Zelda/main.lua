-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 5 => "Legend of Zelda"
-- Made by Ruta Jankauskaite, following the tutorial

--[[ Assignment 5: 
    1. Make some enemies drop hearts that would restore 2 health.
    2. Spawn some pots in dungeon rooms, allow the player to lift it.
    Lifting and pot-carrying animations should be added. Pots can be used to damage the enemies
    by throwing them. They should disappear if they hit a wall, an enemy or traveled
    more than 4 tiles.

    What's done:
    1. Spiders have a change to drop a consumable heart after killing them.
    2. Pots can be lifted and thrown at the enemies. A player cannot leave the room while
    carrying a pot.
    Main changes were done to Player states, the Play state and Game/Entity defs and objects.
]]  

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Legend of Zelda')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
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
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end