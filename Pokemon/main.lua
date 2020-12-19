-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 6 => "Pokemon"
-- Made by Ruta Jankauskaite, following the tutorial

--[[ Assignment 7: 
    1. Implement a Menu that appears during the player Pokémon’s level up that shows, 
    for each stat, ‘X + Y = Z’, where X is the starting stat, Y is the amount it’s increased for this level,
    and Z is the resultant sum. This Menu should appear right after the “Level Up” dialogue that appears at 
    the end of a victory where the player has indeed leveled up.

    What's done:
    1. gui -> selection and menu modified, cursorEnabled field added which decides whether to render the cursor.
    2. BattleStatsMenuState created
    3. TakeTurnState modified - victory message is shown and right after a stats state is also pushed.
    
]]  

require 'src/Dependencies'

function love.load()

    love.window.setTitle('Pokemon')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateStack = StateStack()
    gStateStack:push(StartState())

    love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end