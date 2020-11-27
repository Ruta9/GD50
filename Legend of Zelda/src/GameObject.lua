--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- delete flag
    self.remove = false

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.size = def.size or 1

    self.thrown = false
    self.thrownDirection = nil
    self.thrownDistance = 0
    self.throwingSpeed = def.throwingSpeed or 0.05
    self.throwingDistance = def.throwingDistance or 4

    -- default empty collision callback
    self.onCollide = function() end
end

function GameObject:update(dt)

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY, 0, self.size, self.size)
end