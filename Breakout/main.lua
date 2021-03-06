-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 3 => "Breakout"
-- Made by Ruta Jankauskaite, following the tutorial

--[[ Assignment 2: Breakout, The Powerup Update
     1. Add a powerup which spawns on timer or hitting a brick.
     Once collided with the paddle, 2 more balls should spawn, which
     should disappear after winning the level.
     2. Paddle should shrink if the player loses a heart.
     3. Add a locked brick and a key powerup. The locked Brick should not be breakable by the ball normally, 
     unless they have the key Powerup.

    What's done:
    1. A new class PowerUp.lua added. 2 Types of PowerUps were added in the bricks:
       - One that spawns 2 more balls for each ball visible on the screen. 
         Once they hit bottom, they disappear. If no balls are visible on the screen, game transitions to serve state, one heart is lost.
       - One that makes all of the balls visible not collideable - meaning they will go through the bricks and remove them, but will
         not be sent back (will not 'hit' the brick)
    2. One powerUp was added that spawns with the help of a timer:
       - Key powerUp: if there is a brick that is locked, Key powerUp will spawn occasionally, which removes the lock for small amount of time
         for all of the locked bricks.
    3. every 3000 points a heart is added to the health.
    4. if health < 3 heart, the paddle will be smaller.
    5. PowerUps on the bricks are indicated by brick's tier. Once the powerUp is picked up, the ball changes its color.


]]

require 'src/Dependencies'

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf',8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf',16),
        ['large'] = love.graphics.newFont('fonts/font.ttf',32)
    }
    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['powerups'] = GenerateQuadsPowerups(gTextures['main']),
        ['key-brick'] = GenerateQuadLockedBrick(gTextures['main'])
    }

    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['powerUp'] = love.audio.newSource('sounds/powerUp.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['high-scores'] = function() return HighScoreState() end,
        ['enter-high-score'] = function() return EnterHighScoreState() end,
        ['paddle-select'] = function() return PaddleSelectState() end
    }
    gStateMachine:change('start',{
        highScores = loadHighScores()
    })

    gSounds['music']:play()
    gSounds['music']:setLooping(true)

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

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        0, 0, --  coordinates
        0, -- rotation
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    gStateMachine:render()
    
    displayFPS()

    push:finish()
end

function displayFPS()
	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(0,1,0,1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

-- Global rendering functions, resued in more than 1 state
function renderHealth(health)
    -- place for hearts
    local healthX = VIRTUAL_WIDTH - 100
    -- render unused hearts
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end
    -- render empty hearts
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right') 
end

function loadHighScores()
    love.filesystem.setIdentity('breakout')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'RJ\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end