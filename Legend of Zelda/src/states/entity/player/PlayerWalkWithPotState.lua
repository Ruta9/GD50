
PlayerWalkWithPotState = Class{__includes = EntityWalkState}

function PlayerWalkWithPotState:init(player, dungeon) 
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.entity:changeAnimation('walk-with-pot-' .. self.entity.direction)
end

function PlayerWalkWithPotState:update(dt)

    -- walking animation
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-with-pot-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-with-pot-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-with-pot-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-with-pot-down')
    else
        self.entity:changeState('idle')
    end

    -- draw the pot above the player
    self.entity.liftedPot.x = self.entity.x
    self.entity.liftedPot.y = self.entity.y - 10

    
    if love.keyboard.wasPressed('space') then
        self.entity.liftedPot.thrown = true
        self.entity.liftedPot.thrownDirection = self.entity.direction
        self.entity.liftedPot.y = self.entity.y
        self.entity.liftedPot = nil
        self.entity:changeState('walk');
    end

    EntityWalkState.update(self, dt)

end