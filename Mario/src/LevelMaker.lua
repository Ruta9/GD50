LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- key and lock generation flags
    local keyGenerated = nil
    local lockGenerated = nil


    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1  and x > 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(player, obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    -- add a key and a lock
    local keyX,keyY = 0, 0
    local column = nil
    while keyGenerated == nil do
        column = math.random(math.floor(width/5*4))

        -- generate the key if the space is not empty
        if not(tiles[7][column].id == TILE_ID_EMPTY) then
            keyX = column
            -- if there is a column, spawn the key on the column
            if not(tiles[5][column].id == TILE_ID_EMPTY) then
                keyY = 4
            else
                keyY = 6
            end

            keyGenerated = math.random(#KEYS)
        end
    end
    local key = GameObject {
        texture = 'keys-locks',
        x = (keyX - 1) * TILE_SIZE,
        y = (keyY - 1) * TILE_SIZE - 8,
        width = 16,
        height = 16,
        frame = KEYS[keyGenerated],
        collidable = true,
        consumable = true,
        solid = false,

        onConsume = function(player)
            gSounds['pickup']:play()
            player.hasKey = true

            -- show a key near the score
            local keyImg = GameObject {
                texture = 'keys-locks',
                x = 4,
                y = 1 * TILE_SIZE + 4,
                width = 16,
                height = 16,
                frame = KEYS[keyGenerated],
                collidable = false,
                consumable = false,
                solid = false
            }
            keyImg.scroll = true
            table.insert(objects, keyImg)
        end
    }
    table.insert(objects, key)


    local lockX,lockY = 0, 0
    while lockGenerated == nil do
        column = math.random(math.floor(width/5*4), width)

        if not(tiles[7][column].id == TILE_ID_EMPTY) then
            lockX = column
            if not(tiles[5][column].id == TILE_ID_EMPTY) then
                lockY = 4
            else
                lockY = 6
            end

            lockGenerated = LOCKS[keyGenerated]
        end
    end

            local lock = GameObject {
                texture = 'keys-locks',
                x = (lockX - 1) * TILE_SIZE,
                y = (lockY - 1) * TILE_SIZE - 8,
                width = 16,
                height = 16,
                frame = lockGenerated,
                collidable = true,
                consumable = false,
                solid = true,
        
                onCollide = function(player,object)
                    if not(object.consumable) and player.hasKey then
                        object.consumable = true
                        object.solid = false
                    end
                end,
                onConsume = function(player)
                    gSounds['powerup-reveal']:play()

                    -- spawn at the end of the game
                    local flagX,flagY = 0, 0
                    local flagGenerated = nil
                    while flagGenerated == nil do
                        column = math.random(math.floor(width/10*9), width)
                
                        if not(tiles[7][column].id == TILE_ID_EMPTY) and not(tiles[5][column].id == TILE_ID_GROUND)then
                            flagX = column
                            flagGenerated = keyGenerated
                        end
                    end

                    local flag_pole = GameObject {
                        texture = 'flag-poles',
                        x = (flagX - 1) * TILE_SIZE,
                        y = 6 * TILE_SIZE - 48,
                        width = 16,
                        height = 48,
                        frame = flagGenerated+2,
                        collidable = false,
                        consumable = true,
                        solid = true,
                
                        onConsume = function(pl)
                            gSounds['powerup-reveal']:play()
                            gStateMachine:change('play', {
                                score = pl.score,
                                levelLength = gStateMachine.current.levelLength
                            })
                        end
                    }
                    table.insert(objects, flag_pole)

                    local flag = GameObject {
                        texture = 'flags',
                        x = (flagX - 1) * TILE_SIZE + 8,
                        y = 6 * TILE_SIZE - 40,
                        width = 16,
                        height = 16,
                        frame = flagGenerated,
                        collidable = false,
                        consumable = true,
                        solid = true,
                
                        onConsume = function(pl)
                            gSounds['powerup-reveal']:play()
                            gStateMachine:change('play', {
                                score = pl.score,
                                levelLenght = gStateMachine.current.levelLength
                            })
                        end
                    }
                    table.insert(objects, flag)
                end
            }
            table.insert(objects, lock)


    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end