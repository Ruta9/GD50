WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

TILE_SIZE = 16

TILE_ID_EMPTY = 5
TILE_ID_GROUND = 3

-- width and height of screen in tiles
SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / TILE_SIZE
SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / TILE_SIZE

-- number of tiles in each tile set
TILE_SET_WIDTH = 5
TILE_SET_HEIGHT = 4

-- number of tile sets in sheet
TILE_SETS_WIDE = 6
TILE_SETS_TALL = 10

-- number of topper sets in sheet
TOPPER_SETS_WIDE = 6
TOPPER_SETS_TALL = 18

-- total number of topper and tile sets
TOPPER_SETS = TOPPER_SETS_WIDE * TOPPER_SETS_TALL
TILE_SETS = TILE_SETS_WIDE * TILE_SETS_TALL

COLLIDABLE_TILES = {
    TILE_ID_GROUND
}

-- Player
-- player walking speed
PLAYER_WALK_SPEED = 60
PLAYER_WALK_ENHANCEMENT = 10
-- player jumping velocity
PLAYER_JUMP_VELOCITY = -150

BUSH_IDS = {
    1, 2, 5, 6, 7
}

GEMS = {
    1, 2, 3, 4, 5, 6, 7, 8
}


-- snail movement speed
SNAIL_MOVE_SPEED = 10

KEYS = {
    1, 2, 3, 4
}

LOCKS = {
    5, 6, 7, 8
}

JUMP_BLOCKS = {}

for i = 1, 30, 2 do
    table.insert(JUMP_BLOCKS, i)
end