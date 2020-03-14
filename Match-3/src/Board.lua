Board = Class{}

CHANCE_FOR_POWERUP = 0

-- total 12 matches
local matchTable = {
    [1] = {{-1, 1}, {{-2, 0}, {0, 2}, {1, 1}, {-1, -1}}},
    [2] = {{1, 1}, {{0, 2}, {2, 0}, {1, -1}}},
    [3] = {{1, -1}, {{2, 0}, {0, -2}, {-1, -1}}},
    [4] = {{-1, -1}, {{0, -2}, {-2, 0}}}
}

function Board:init(x, y, currentLevel)
    self.x = x
    self.y = y
    self.matches = {}
    self.currentLevel = currentLevel
    self.colors = {}
    self:randomizeColors()
    self:initializeTiles()
end

function Board:randomizeColors()
    local numberOfColors = 8 + (((self.currentLevel - 1) % 5) + 1)
    for color = 1, numberOfColors do
        local randomColor = 0
        while self.colors[color] == nil do
            randomColor = math.random(18)
            for i, color in pairs(self.colors) do
                if color == randomColor then
                    goto continue
                end
            end
            table.insert(self.colors, randomColor)
            ::continue::
        end
    end
end

function Board:initializeTiles()
    self.tiles = {}
    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            -- create a new tile at X,Y with a random color and variety
            local shiny = self:setAsPowerUp()
            table.insert(self.tiles[tileY], Tile(tileX, tileY, self.colors[math.random(#self.colors)], ((math.random(self.currentLevel)-1)%6)+1, shiny))
        end
    end

    while self:calculateMatches() or not(self:calculatePotentialMatches()) do
        -- loop for as long as we get matchless board + potential matches should be available
        self:initializeTiles()
    end

end

function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                        -- if matched tile is shiny (powerup), add the whole line to the match
                        if self.tiles[y][x2].shiny then
                            table.insert(matches, self.tiles[y])
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                if self.tiles[y][x].shiny then
                    table.insert(matches, self.tiles[y])
                end
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                        if self.tiles[y2][x].shiny then
                            table.insert(matches, self.tiles[y2])
                        end
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum, -1 do
                table.insert(match, self.tiles[y][x])
                if self.tiles[y][x].shiny then
                    table.insert(matches, self.tiles[y])
                end
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches
    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

function Board:calculatePotentialMatches()
    local potentialMatchesExist = false

    -- check if each tile has a similar potential match:
    --[[
        - - o - -
        - o - o -
        o - * - o
        - o - o -
        - - o - -
    ]]
    for y = 1, 8 do
        for x = 1, 8 do
            for i = 1, 4 do
                local tempY = self.tiles[y][x].gridY + matchTable[i][1][1]
                local tempX = self.tiles[y][x].gridX + matchTable[i][1][2]
                if (tempY > 0 and tempY <= 8 and tempX > 0 and tempX <= 8 and self.tiles[y][x].color == self.tiles[tempY][tempX].color) then
                    for j = 1, #matchTable[i][2] do
                        local tempY = self.tiles[y][x].gridY + matchTable[i][2][j][1]
                        local tempX = self.tiles[y][x].gridX + matchTable[i][2][j][2]
                        if (tempY > 0 and tempY <= 8 and tempX > 0 and tempX <= 8 and self.tiles[y][x].color == self.tiles[tempY][tempX].color) then
                            potentialMatchesExist = true
                            goto continue
                        end
                    end
                end
            end
        end
    end
    -- look for 2 tiles with the same color near each other
    -- if tiles are horizontal
        --[[
        - - - - - -
        - p - - p -
        p - * * - p
        - p - - p -
        - - - - - -
    ]]
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        for x = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum == 2 then
                    local match = {}

                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end
                    if match[2].gridX < match[1].gridX then
                        local tempTile = match[1]
                        match[1] = match[2]
                        match[2] = tempTile
                    end
                    potentialMatchesExist = self:isAPotentialMatch(match, false)
                    if potentialMatchesExist then
                        goto continue
                    end
                end

                matchNum = 1
            end
        end

        -- account for the last row ending with a match
        if matchNum == 2 then
            local match = {}
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            if match[2].gridX < match[1].gridX then
                local tempTile = match[1]
                match[1] = match[2]
                match[2] = tempTile
            end
            potentialMatchesExist = self:isAPotentialMatch(match, false)
            if potentialMatchesExist then
                goto continue
            end
        end
    end

    -- vertical matches
    -- if tiles are vertical
    --[[
        - p - -
        p - p -
        - * - -
        - * - -
        p - p -
        - p - -
    ]]
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color
        matchNum = 1

        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color
                if matchNum == 2 then
                    local match = {}
                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end
                    if match[2].gridY < match[1].gridY then
                        local tempTile = match[1]
                        match[1] = match[2]
                        match[2] = tempTile
                    end
                    potentialMatchesExist = self:isAPotentialMatch(match, true)
                    if potentialMatchesExist then
                        goto continue
                    end
                end

                matchNum = 1
            end
        end

        -- account for the last column ending with a match
        if matchNum == 2 then
            local match = {}
            for y = 8, 8 - matchNum, -1 do
                table.insert(match, self.tiles[y][x])
            end
            if match[2].gridY < match[1].gridY then
                local tempTile = match[1]
                match[1] = match[2]
                match[2] = tempTile
            end
            potentialMatchesExist = self:isAPotentialMatch(match, true)
            if potentialMatchesExist then
                goto continue
            end
        end
    end
    ::continue::
    return potentialMatchesExist
end

function Board:isAPotentialMatch(pair, isVertical)
    local potentialMatchExist = false
    -- first tile
    if (pair[1].gridX - 1 > 0) and (pair[1].gridY - 1 > 0) and (self.tiles[pair[1].gridY - 1][pair[1].gridX - 1].color == pair[1].color) then
        potentialMatchExist = true
    
    elseif (isVertical and (pair[1].gridY - 2 > 0) and (self.tiles[pair[1].gridY - 2][pair[1].gridX].color == pair[1].color)) or 
    (not(isVertical) and (pair[1].gridX - 2 > 0) and (self.tiles[pair[1].gridY][pair[1].gridX-2].color == pair[1].color)) then
        potentialMatchExist = true
    
    elseif (isVertical and (pair[1].gridX + 1 <= 8) and (pair[1].gridY - 1 > 0) and (self.tiles[pair[1].gridY - 1][pair[1].gridX + 1].color == pair[1].color)) or
    (not(isVertical) and (pair[1].gridX - 1 > 0) and (pair[1].gridY + 1 <= 8) and (self.tiles[pair[1].gridY + 1][pair[1].gridX - 1].color == pair[1].color)) then
        potentialMatchExist = true
        
    -- second tile
    elseif (isVertical and (pair[2].gridX - 1 > 0) and (pair[2].gridY + 1 <= 8) and (self.tiles[pair[2].gridY + 1][pair[2].gridX - 1].color == pair[2].color)) or
    (not(isVertical) and (pair[2].gridX + 1 <= 8) and (pair[2].gridY - 1 > 0) and (self.tiles[pair[2].gridY - 1][pair[2].gridX + 1].color == pair[2].color)) then
        potentialMatchExist = true
        
    elseif (isVertical and (pair[2].gridY + 2 <= 8) and (self.tiles[pair[2].gridY + 2][pair[2].gridX].color == pair[2].color)) or
    (not(isVertical) and (pair[2].gridX + 2 <= 8) and (self.tiles[pair[2].gridY][pair[2].gridX + 2].color == pair[2].color) ) then
        potentialMatchExist = true
      
    elseif (pair[2].gridX + 1 <= 8) and (pair[2].gridY + 1 <= 8) and (self.tiles[pair[2].gridY + 1][pair[2].gridX + 1].color == pair[2].color) then
        potentialMatchExist = true
        
    end
    return potentialMatchExist
end

function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set space back to 0, set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then
                local shiny = self:setAsPowerUp()
                local tile = Tile(x, y, self.colors[math.random(#self.colors)], ((math.random(self.currentLevel)-1)%6)+1, shiny)
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:countPowerups()
    local count = 0

    for i, tileRow in pairs(self.tiles) do
        for j, tile in pairs(tileRow) do
            if tile.shiny then
                count = count + 1
            end
        end
    end

    return count
end

function Board:setAsPowerUp()
    local count = self:countPowerups()
    if (count < 2 + (self.currentLevel % 3)) and (math.random() <= (CHANCE_FOR_POWERUP + self.currentLevel * 0.01))  then
        return true
    end
    return false
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
