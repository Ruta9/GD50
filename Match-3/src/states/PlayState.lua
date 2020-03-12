PlayState = Class {__includes = BaseState}

function PlayState:init()

    -- select position in grid
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    self.score = 0
    self.timer = 60

    self.rectHighlighted = false
    -- tile prepared for a swap
    self.highlightedTile = nil
    -- cursor highlight, nice effect
    Timer.every(0.5, function()
        self.rectHighlighted = not self.rectHighlighted
    end)

    Timer.every(1, function()
        self.timer = self.timer - 1
        -- warning sound
        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)

    -- input will be paused while the tiles will be swapping
    self.canInput = true

end

function PlayState:enter(params)
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)
    -- current score
    self.score = params.score or 0
    -- score to reach
    self.scoreGoal = self.score + self.level * 1.25 * 200
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- timer runs out, game over
    if self.timer <= 0 then
        -- clear timers
        Timer.clear()
        
        gSounds['game-over']:play()
        gStateMachine:change('game-over', {
            score = self.score
        })
    end

    -- goal reached
    if self.score >= self.scoreGoal then
        Timer.clear()

        gSounds['next-level']:play()
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    end

    if self.canInput then
        -- move cursor
        if love.keyboard.wasPressed('up') then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.boardHighlightY = math.min(7, self.boardHighlightY + 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(7, self.boardHighlightX + 1)
            gSounds['select']:play()
        end

        -- select a tile and perform swap if one is already selected
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1

            -- select the tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]
            -- remove selection (tile was already selected)
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil
            -- the distance is > 1 tile - remove selection, do not swap
            elseif math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y) > 1 then
                gSounds['error']:play()
                self.highlightedTile = nil
            -- else swap the tile
            else
                self.canInput = false;
                -- swap grid positions of tiles
                local tempX = self.highlightedTile.gridX
                local tempY = self.highlightedTile.gridY

                local newTile = self.board.tiles[y][x]

                self.highlightedTile.gridX = newTile.gridX
                self.highlightedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY

                -- swap tiles in the tiles table
                self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] =
                    self.highlightedTile

                self.board.tiles[newTile.gridY][newTile.gridX] = newTile

                -- tween coordinates between the two so they swap
                Timer.tween(0.1, {
                    [self.highlightedTile] = {x = newTile.x, y = newTile.y},
                    [newTile] = {x = self.highlightedTile.x, y = self.highlightedTile.y}
                }):finish(function() self:calculateMatches() end)

            end
        end
    end


    Timer.update(dt)
end

function PlayState:calculateMatches()
    self.highlightedTile = nil

    -- check for matches
    local matches = self.board:calculateMatches()
    
    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()

        -- add score for each match
        for k, match in pairs(matches) do
            self.score = self.score + #match * 50
        end

        -- remove any tiles that matched from the board, making empty spaces
        self.board:removeMatches()

        -- gets a table with tween values for tiles that should now fall
        local tilesToFall = self.board:getFallingTiles()

        -- first, tween the falling tiles over 0.25s
        Timer.tween(0.25, tilesToFall):finish(function() self:calculateMatches() end)
    -- if no matches, we can continue playing
    else
        self.canInput = true
    end
end


function PlayState:render()

    self.board:render()

    -- render highlighted tile if it exists
    if self.highlightedTile then
        -- add color on top
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
            (self.highlightedTile.gridY - 1) * 32 + 16, 32, 32, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- cursor highlight effect
    if self.rectHighlighted then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end

    -- draw actual cursor rect (selection)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + (VIRTUAL_WIDTH - 272),
        self.boardHighlightY * 32 + 16, 32, 32, 4)

    -- GUI text
    love.graphics.setColor(56/255, 56/255, 56/255, 234/255)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end