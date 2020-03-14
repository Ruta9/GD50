Tile = Class{}

local colors = {
    [1] = {1, 215/255, 0, 0.9},
    [2] = {1, 229/255, 79/255, 0.9},
    [3] = {1, 242/255, 171/255, 0.9},
    [4] = {1, 252/255, 237/255, 0.9},
    [5] = {1, 242/255, 171/255, 0.9},
    [6] = {1, 229/255, 79/255, 0.9}
}

function Tile:init(x, y, color, variety, shiny)
    -- position in board
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    self.shiny = shiny
    self.shinyColor = 1

    Timer.every(0.075, function()
        self.shinyColor = self.shinyColor + 1
        if self.shinyColor > 6 then
            self.shinyColor = 1
        end
    end)

end

function Tile:update(dt)

end


function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    -- draw shiny part if this tile is a power-up
    if self.shiny then
        love.graphics.setLineWidth(3)
        love.graphics.setColor(colors[self.shinyColor])
        love.graphics.rectangle('line', x+self.x+8, y+self.y+8, 16, 16, 10)
    end

end