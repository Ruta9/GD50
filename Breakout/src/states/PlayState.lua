PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paused = false
    self.balls = {}
    self.ballsToAdd = {}
    self.powerUps = {
        ballCollisionPowerUpIsActive = false,
        ballCollisionPowerUpTimer = 0,
        KeyPowerUpIsActive = false,
        KeyPowerUpDropTimer = KEY_POWERUP_DROP,
        KeyPowerUpTimer = KEY_POWERUP_LENGHT,
        keyPowerUp = nil
    }
    self.lockedBricksIndeces = {}
end

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level
    self.ball.dx = math.random(2) == 1 and -200 or 200
    self.ball.dy = math.random(2) == 1 and -70 or 70
    self.highScores = params.highScores
    table.insert(self.balls, self.ball)
    for k, brick in pairs(params.bricks) do
        if brick.isLocked then 
            table.insert(self.lockedBricksIndeces, k)
        end
    end

end

function PlayState:update(dt)

    -- PowerUp timers
    if self.powerUps.ballCollisionPowerUpIsActive then 
        self.powerUps.ballCollisionPowerUpTimer = self.powerUps.ballCollisionPowerUpTimer - dt
        if self.powerUps.ballCollisionPowerUpTimer <= 0 then
            for i, ball in pairs(self.balls) do
                ball.collision = true
                ball.skin = 1
            end            

            self.powerUps.ballCollisionPowerUpIsActive = false
            self.powerUps.keyPowerUp = nil
        end
    end

    if self.powerUps.KeyPowerUpIsActive then
        self.powerUps.KeyPowerUpTimer = self.powerUps.KeyPowerUpTimer - dt
        if self.powerUps.KeyPowerUpTimer <= 0 then 
            self.powerUps.KeyPowerUpIsActive = false 
            for i, ind in pairs(self.lockedBricksIndeces) do
                self.bricks[ind].isLocked = true
            end
            for i, ball in pairs(self.balls) do
                if self.powerUps.ballCollisionPowerUpIsActive then 
                    ball.skin = 2
                else
                    ball.skin = 1
                end
            end
        end 
    end

    if #self.lockedBricksIndeces > 0 and (not self.powerUps.KeyPowerUpIsActive) then
        self.powerUps.KeyPowerUpDropTimer = self.powerUps.KeyPowerUpDropTimer - dt
        if self.powerUps.KeyPowerUpDropTimer <= 0 then
            self.powerUps.keyPowerUp = PowerUp('key', math.random(20,VIRTUAL_WIDTH-20), -16)
            self.powerUps.keyPowerUp.visible = true
            self.powerUps.KeyPowerUpDropTimer = KEY_POWERUP_DROP
            self.powerUps.KeyPowerUpTimer = KEY_POWERUP_LENGHT
        end
    end

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.paddle:update(dt)
    for i, ball in pairs(self.balls) do
        ball:update(dt)
    end  


    -- check if the ball collided with the paddle
    for i, ball in pairs(self.balls) do
        if ball:collides(self.paddle) then
            ball.dy = -ball.dy
            -- reset the position so that the collision would be reset
            ball.y = self.paddle.y - 8
    
            -- Make the angle of bounce more logical, meaning we can impact the ball's direction
            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
                -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
    
            gSounds['paddle-hit']:play()
        end
    end  

    -- check if the powerup collided with the paddle
    if not (self.powerUps.keyPowerUp == nil) and (self.powerUps.keyPowerUp:collides(self.paddle)) and self.powerUps.keyPowerUp.visible then
        self.powerUps.keyPowerUp.visible = false
        gSounds['powerUp']:play()
        self.powerUps.KeyPowerUpIsActive = true
        for i, ind in pairs(self.lockedBricksIndeces) do
            self.bricks[ind].isLocked = false
        end
        for i, ball in pairs(self.balls) do
            ball.skin = 7
        end
    end

    for k, brick in pairs(self.bricks) do

        if (not (brick.powerUp == nil)) and brick.powerUp:collides(self.paddle) and brick.powerUp.visible then
            brick.powerUp.visible = false
            -- sound
            gSounds['powerUp']:play()
            -- powerUp type
            if (brick.powerUp.type == 'remove-ball-collision') then
                for i, ball in pairs(self.balls) do
                    ball.collision = false
                    if not self.powerUps.KeyPowerUpIsActive then ball.skin = math.min(ball.skin + 1,7) end
                end
                self.powerUps.ballCollisionPowerUpIsActive = true
                self.powerUps.ballCollisionPowerUpTimer = BALL_COLLISION_REMOVAL_LENGHT
            end
            if (brick.powerUp.type == 'add-balls') then
                for i, ball in pairs(self.balls) do
                    ball1 = Ball(ball.skin, false)
                    ball1.x = ball.x
                    ball1.y = ball.y
                    ball1.dx = ball.dx - math.random(5,20)
                    ball1.dy = ball.dy - math.random(-30,30)
                    ball2 = Ball(ball.skin, false)
                    ball2.x = ball.x
                    ball2.y = ball.y
                    ball2.dx = ball.dx - math.random(-20,-5)
                    ball2.dy = ball.dy - math.random(-30,30)

                    if self.powerUps.ballCollisionPowerUpIsActive then
                        ball1.collision = false
                        ball2.collision = false
                    end
                    table.insert(self.ballsToAdd, ball1)
                    table.insert(self.ballsToAdd, ball2)
                end
                for i, ball in pairs(self.ballsToAdd) do
                    table.insert(self.balls, ball)
                end
                self.ballsToAdd = {}
            end
        end


        for i, ball in pairs(self.balls) do
            -- check if the ball collided with the brick
            if brick.inPlay and ball:collides(brick) then

                brick:hit()

                if (not (brick.inPlay)) and (not (brick.powerUp == nil)) then
                    brick.powerUp.visible = true
                end

                -- was this the last one?
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory',{
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        ball = Ball(1, true),
                        highScores = self.highScores
                    })
                end

                local score_before = self.score
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
                
                if math.floor(score_before / 3000) < math.floor(self.score / 3000)  then
                    self.health = math.min(self.health + 1, 3)
                    gSounds['recover']:play() 
                end
                

                if ball.collision then
                    -- collision code for bricks (determining, where the ball should bounce)
                    --
                    -- we check to see if the opposite side of our velocity is outside of the brick;
                    -- if it is, we trigger a collision on that side. else we're within the X + width of
                    -- the brick and should check to see if the top or bottom edge is outside of the brick,
                    -- colliding on the top or bottom accordingly 
                    --

                    -- left edge; only check if we're moving right
                    if ball.x + 2 < brick.x and ball.dx > 0 then
                        
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x - 8
                    
                    -- right edge; only check if we're moving left
                    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                        
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x + 32
                    
                    -- top edge if no X collisions, always check
                    elseif ball.y < brick.y then
                        
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y - 8
                    
                    -- bottom edge if no X collisions or top collision, last possibility
                    else
                        
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y + 16
                    end

                    -- slightly scale the y velocity to speed up the game
                    ball.dy = ball.dy * 1.02

                    -- only allow colliding with one brick, for corners
                    break
                end
            end
        end
    end

    for i, ball in pairs(self.balls) do
        -- check if the ball collided with bottom (- health)
        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(self.balls, i)
        end

        if #self.balls < 1 then
            self.health = self.health - 1
            gSounds['hurt']:play();

            -- is it game over?
            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve',{
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    level = self.level,
                    highScores = self.highScores
                })
            end
        end

        if self.health < 3 then
            self.paddle:shrink()
        else
            self.paddle:extend()
        end
    end


    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
        -- for powerups
        if not (brick.powerUp == nil) then
            brick.powerUp:update(dt)
        end
    end

    if not (self.powerUps.keyPowerUp == nil) then 
        self.powerUps.keyPowerUp:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()
    for i, ball in pairs(self.balls) do
        ball:render()
    end
    if not (self.powerUps.keyPowerUp == nil) then 
        self.powerUps.keyPowerUp:render()
    end
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
        if not (brick.powerUp == nil) then
            brick.powerUp:render()
        end
    end

    renderScore(self.score)
    renderHealth(self.health)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('PAUSED',0,VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end


function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
end