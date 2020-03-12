StartState = Class{__includes = BaseState}

-- A title with changing colors will be shown.
-- Game options will be shown

local positions = {}

function StartState:init()

    -- Prepare colors for the title
    self.colors = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}
    }

    -- Letters with their position relative to the center
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    -- Init color change timer
    -- Every 0.075s use the callback function
    self.colorTimer = Timer.every(0.075, function()
        -- shift the colors
        self.colors[0] = self.colors[6]
        for i = 6, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    -- background
    -- generate the board for display only
    for i = 1, 64 do
        table.insert(positions, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    -- Start option is currently selected
    self.currentMenuItem = 1
    -- transition tween value
    self.transitionAlpha = 0
    self.pauseInput = false
end


function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if not self.pauseInput then
        -- change menu selection
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            gSounds['select']:play()
        end

        -- switch to another state via one of the menu options
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 1 then
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function()
                    gStateMachine:change('begin-game', {
                        level = 1
                    })
                    -- remove color timer from Timer
                    self.colorTimer:remove()
                end)
            else
                love.event.quit()
            end

            -- turn off input during transition to another state
            self.pauseInput = true
        end
    end

    Timer.update(dt)
end

function StartState:render()
    -- render board
    for y = 1, 8 do
        for x = 1, 8 do
            -- render shadow
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.draw(gTextures['main'], positions[(y - 1) * x + x], 
                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            -- render tile
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(gTextures['main'], positions[(y - 1) * x + x], 
                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end

    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawTitle(-60)
    self:drawOptions(12)

    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function StartState:drawTitle(y)
    -- draw semi-transparent rect behind MATCH 3
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)

    -- draw MATCH 3 text shadows
    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y)

    -- print MATCH 3 letters in their corresponding current colors
    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end
end

function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end

function StartState:drawOptions(y)
    -- draw rect behind start and quit game options text
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 58, 6)

    -- draw Start text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8)
    
    if self.currentMenuItem == 1 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')

    -- draw Quit Game text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Quit Game', VIRTUAL_HEIGHT / 2 + y + 33)
    
    if self.currentMenuItem == 2 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    
    love.graphics.printf('Quit Game', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end