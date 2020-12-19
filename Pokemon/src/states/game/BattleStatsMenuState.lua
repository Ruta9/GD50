--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleStatsMenuState = Class{__includes = BaseState}

function BattleStatsMenuState:init(battleState, hp_increase, attack_increase, def_increase, speed_increase, onSelect)
    self.battleState = battleState
    self.onSelectCallback = onSelect
    
    self.statsMenu = Menu {
        x = math.floor((VIRTUAL_WIDTH - 225)/2),
        y = 25,
        width = 225,
        height = 110,
        cursorEnabled = false,
        items = {
            {
                text = (self.battleState.playerPokemon.HP - hp_increase) .. ' + ' .. hp_increase .. ' -> ' .. self.battleState.playerPokemon.HP .. ' Health',
                onSelect = function() self:close() end
            },
            {
                text = (self.battleState.playerPokemon.attack - attack_increase) .. ' + ' .. attack_increase .. ' -> ' .. self.battleState.playerPokemon.attack .. ' Attack',
                onSelect = function() self:close() end
            },
            {
                text = (self.battleState.playerPokemon.defense - def_increase) .. ' + ' .. def_increase .. ' -> ' .. self.battleState.playerPokemon.defense .. ' Defense',
                onSelect = function() self:close() end
            },
            {
                text = (self.battleState.playerPokemon.speed - speed_increase) .. ' + ' .. speed_increase .. ' -> ' .. self.battleState.playerPokemon.speed .. ' Speed',
                onSelect = function() self:close() end
            }
        }
    }
end

function BattleStatsMenuState:close()
    gStateStack:pop()
    self.onSelectCallback()
end

function BattleStatsMenuState:update(dt)
    self.statsMenu:update(dt)
end

function BattleStatsMenuState:render()
    self.statsMenu:render()
end