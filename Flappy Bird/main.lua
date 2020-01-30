-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 2 => "Flappy Bird"
-- Made by Ruta Jankauskaite, following the tutorial

--[[ Assignment 1: Flappy Bird, The Reward Update
     1. Randomize gaps between pipes
     2. Randomize spawning intervals between pipe pairs
     3. Award a medal for scores (3 different medals)
     4. Pause feature when pressing "P":
            4.1 Gameplay and Music should pause
            4.2 There should be a sound effect for pausing
            4.3 There should be an icon in the middle of the screen to indicate that the game is paused

    What's done:
    1. In PipePair.lua the lower pipe's y is randomized according to the GAP_HEIGHT constant.
    2. In PlayState.lua there's SPAWN_GAP_MIN_TIME, and it can be prolonged by math.random() (<= 1 sec).
    3. In ScoreState.lua render function, the awards are given (1/3 -> score > 0, 2/3 score >= 5, 3/3 >= 10).
    4. "scrolling" field added in main.lua, so that it would be possible to stop the background scrolling (otherwise, it looks more like a bug than a pause)
       Pause logic written in PlayState.lua
       Pause sound effect added.
]]

push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

-- State Machine 
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280 
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

BACKGROUND_SCROLL_SPEED = 30
GROUND_SCROLL_SPEED = 60

--[[ 2 copies of image or smth, looping point is where
it is again the same]]
BACKGROUND_LOOPING_POINT = 413

-- images
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Birdy')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- keys pressed table for accessing in other classes
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    math.randomseed(os.time())

    -- Fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- Init State Machine (g stands for 'global')
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end
    }

    -- Init sounds table
    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }
    
    --[[ This will be global, so start playing it here
        + Set looping to true ]]
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- Scrolling var for pausing the background movement
    scrolling = true

    gStateMachine:change('title')
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end 
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)


    backgroundScroll = scrolling and (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT or backgroundScroll
    groundScroll = scrolling and (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH or groundScroll

    gStateMachine:update(dt)

    -- flush pressed keys table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    -- The order of drawing matters!
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end