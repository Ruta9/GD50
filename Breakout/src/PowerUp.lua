PowerUp = Class{}

PowerUpTypes = {
    ['add-balls'] = 9,
    ['remove-ball-collision'] = 8,
    ['key'] = 10
}

function PowerUp:init(type, x, y)
    self.type = type
    self.x = x
    self.y = y
    self.visible = false
    self.height = 16
    self.width = 16
end

function PowerUp:update(dt)
    if self.visible then
        self.y = self.y + POWERUP_SPEED * dt
        if self.y > VIRTUAL_HEIGHT + 16 then
            self.visible = false
        end
    end
end

function PowerUp:render(dt)
    if self.visible then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][PowerUpTypes[self.type]],
        self.x, self.y)
    end
end

function PowerUp:collides(target)
    --AABB
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    return true
end