ScoreState = Class{__includes = BaseState}

-- Cup image by: https://www.flaticon.com/authors/freepik
local awardImages = {
    ['cup'] = love.graphics.newImage('cup.png'),
    ['blackCup'] = love.graphics.newImage('blackCup.png')
}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! Game over!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH,'center')

    -- first award
    award = self.score <= 0 and 'blackCup' or 'cup'
    love.graphics.draw(awardImages[award], VIRTUAL_WIDTH/2 - awardImages[award]:getWidth()/2 - awardImages[award]:getWidth() - 5, 130)
    -- second award
    award = self.score <= 5 and 'blackCup' or 'cup'
    love.graphics.draw(awardImages[award], VIRTUAL_WIDTH/2 - awardImages[award]:getWidth()/2, 130)
    -- third award
    award = self.score <= 10 and 'blackCup' or 'cup'
    love.graphics.draw(awardImages[award], VIRTUAL_WIDTH/2 - awardImages[award]:getWidth()/2 + awardImages[award]:getWidth() + 5, 130)

    love.graphics.printf('Press Enter to try again!', 0, 180, VIRTUAL_WIDTH,'center')
end