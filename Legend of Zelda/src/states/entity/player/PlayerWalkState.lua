--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkState:adjustPosition(dt)
     -- adjust player position temporarily
     if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
    else
        self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
    end 
end

function PlayerWalkState:readjustPosition(dt)
    -- readjust player position 
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
    else
        self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
    end 
end

function PlayerWalkState:collidesWithPot(dt)

    self:adjustPosition(dt)

    local collides = false;
    for i, pot in pairs(self.dungeon.currentRoom.pots) do
        if self.entity:collides(pot) then
            self.entity.liftedPot = pot
            collides = true
            break
        end
    end

    self:readjustPosition(dt)

    return collides
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') then
        if self:collidesWithPot(dt) then
            self.entity:changeState('lift');
        else
            self.entity:changeState('swing-sword');
        end
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position
            self:adjustPosition(dt)
            
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end

            -- readjust
            self:readjustPosition(dt)
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self:adjustPosition(dt)
            
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end

            -- readjust
            self:readjustPosition(dt)
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self:adjustPosition(dt)
            
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end

            -- readjust
            self:readjustPosition(dt)
        else
            
            -- temporarily adjust position
            self:adjustPosition(dt)
            
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end

            -- readjust
            self:readjustPosition(dt)
        end
    end
end