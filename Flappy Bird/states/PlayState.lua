PlayState = Class{__includes = BaseState}

PIPE_SCROLL_SPEED = 80
PIPE_HEIGHT = 280
PIPE_WIDTH = 70

GAP_HEIGHT = 100

SPAWN_GAP_MIN_TIME = 1.3

local paused = false
local pauseIcon = love.graphics.newImage('pause.png')
function PlayState:init()
    -- objects
    self.bird = Bird()
    self.pipePairs = {}
    -- calculates when to spawn a new pipe pair
    self.spawnTimer = 0
    -- gaps
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    -- score
    self.score = 0
    self.spawn_gap = SPAWN_GAP_MIN_TIME
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('p') then PlayState:pause() end
    if not paused then

        -- gravity
        self.bird:update(dt)

        -- handle pipes' pairs spawning
        self.spawnTimer = self.spawnTimer + dt
        if self.spawnTimer > self.spawn_gap then
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(self.lastY + math.random(-30, 30), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y
            -- lua tables are indexed at 1!
            table.insert(self.pipePairs, PipePair(y))
            self.spawnTimer = 0
            self.spawn_gap = SPAWN_GAP_MIN_TIME + math.random()
        end

        -- foreach key k object pipe in pairs (like enumerate in Python)
        for k, pair in pairs(self.pipePairs) do

            -- if not already scored
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then
                    -- score
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            -- scroll and set to remove if needed
            pair:update(dt)

            -- Check for collision with pipes
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()
                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end

        -- Check for collision with bottom / top
        if self.bird.y > VIRTUAL_HEIGHT - 15 or self.bird.y < 0 - 2 then
            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end

        -- pipes removal
        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end  
    end
end

function PlayState:render()
    self.bird:render()

    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    if paused then love.graphics.draw(pauseIcon, VIRTUAL_WIDTH/2 - pauseIcon:getWidth()/2, VIRTUAL_HEIGHT / 2 - pauseIcon:getHeight()/2) end
    

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end

function PlayState:pause()
    if paused then
        paused = false
        sounds['pause']:play()
        love.audio.play(sounds['music'])
        scrolling = true
    else
        paused = true
        sounds['pause']:play()
        love.audio.pause(sounds['music'])
        scrolling = false
    end
end