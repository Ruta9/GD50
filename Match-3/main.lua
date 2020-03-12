-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 4 => "Match-3"
-- Made by Ruta Jankauskaite, following the tutorial

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


