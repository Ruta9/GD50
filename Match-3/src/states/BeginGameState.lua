BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    -- tween value (fade in)
    self.transitionAlpha = 1
    self.levelLabelY = -64 -- level label position
end

function BeginGameState:enter(params)

    self.level = params.level
    self.board = Board(VIRTUAL_WIDTH - 272, 16, params.level)
    self.score = params.score or 0

    -- transition in
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    
    -- tween level text
    :finish(function()
        Timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        })
        :finish(function()
            Timer.after(1, function() -- pause animation for 1 s
                -- animate level text to the bottom of the window
                Timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                })
                :finish(function() -- finish animation, transition to play state
                    gStateMachine:change('play', {
                        level = self.level,
                        board = self.board,
                        score = self.score
                    })
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    -- render board of tiles
    self.board:render()

    -- render Level # label and background rect
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    -- our transition foreground rectangle
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end