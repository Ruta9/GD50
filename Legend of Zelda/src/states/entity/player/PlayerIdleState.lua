--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        if self.entity.liftedPot then
            self.entity:changeState('walk-with-pot')
        else 
            self.entity:changeState('walk')
        end
    end

    -- if a pot is lifted
    if self.entity.liftedPot then    
        self.entity.liftedPot.x = self.entity.x
        self.entity.liftedPot.y = self.entity.y - 10

        if love.keyboard.wasPressed('space') then
            self.entity.liftedPot.thrown = true
            self.entity.liftedPot.thrownDirection = self.entity.direction
            self.entity.liftedPot.y = self.entity.y
            self.entity.liftedPot = nil
        end

    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end