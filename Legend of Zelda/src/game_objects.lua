--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        throwingSpeed = 0.3,
        throwingDistance = 4,
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'idle',
        states = {
            ['idle'] = {
                frame = 14
            },
            ['lifted'] = {
                frame = 14
            },
            ['flying'] = {
                frame = 14
            },
            ['smashed'] = {
                frame = 52
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        size = 0.5,
        solid = false,
        defaultState = 'nonConsumed',
        states = {
            ['nonConsumed'] = {
                frame = 5
            }
        }
    }
}