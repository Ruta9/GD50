PlayerLiftingState = Class{__includes = BaseState}

function PlayerLiftingState:init(player)
    self.player = player

    -- render offset for spaced character sprite
    self.offsetY = 5
    self.offsetX = 0

    -- get the lifted pot, make it not solid so it would not collide
    self.liftedPot = player.liftedPot
    self.liftedPot.solid = false

    gSounds['pot-lift']:play()

    self.player:changeAnimation('lift-' .. self.player.direction)
end

function PlayerLiftingState:update(dt)

    self.liftedPot.x = self.player.x
    self.liftedPot.y = self.player.y - 10

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('walk-with-pot')
    end

    if love.keyboard.wasPressed('space') then
        -- change to throwing
        --self.player:changeState('swing-sword')
    end
end

function PlayerLiftingState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.offsetX), math.floor(self.player.y - self.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(1, 0, 1, 1)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.setColor(1, 1, 1, 1)
end