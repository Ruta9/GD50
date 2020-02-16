Brick = Class{}

-- Particles
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

function Brick:init(x, y, powerUp)
    self.tier = 0
    self.color = 1
    self.isLocked = false

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    self.powerUp = powerUp

    -- render boolean, not a good practice for a bigger game, but a nice shortcut in this case.
    self.inPlay = true

    -- Particles:
    
    -- particle system belonging to the brick, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform, which is clumpy; numbers
    -- are amount of standard deviation away in X and Y axis
    self.psystem:setEmissionArea('normal', 10, 10)
end

function Brick:hit()

    if not self.isLocked then
        -- Particles
        self.psystem:setColors(
            paletteColors[self.color].r/255,
            paletteColors[self.color].g/255,
            paletteColors[self.color].b/255,
            55 * (self.tier + 1),
            paletteColors[self.color].r/255,
            paletteColors[self.color].g/255,
            paletteColors[self.color].b/255,
            0
        )
        self.psystem:emit(64)

        gSounds['brick-hit-2']:stop()
        gSounds['brick-hit-2']:play()

        -- if we're in the the base color, remove brick from play
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end


        -- play a second layer sound if the brick is destroyed
        if not self.inPlay then
            gSounds['brick-hit-1']:stop()
            gSounds['brick-hit-1']:play()
        end
    end 
end

function Brick:render()
    if self.inPlay then
        if self.isLocked then
            love.graphics.draw(gTextures['main'], gFrames['key-brick'][1], self.x, self.y)
        else
            love.graphics.draw(gTextures['main'], gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier], self.x, self.y)
        end
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end