-- *******************************
-- Harvard Game Development Course
-- *******************************

-- Game 1 => "Pong"
-- Made by Ruta Jankauskaite, following the tutorial

--[[ Assignment 0: Implement a basic AI for either Player 1 or 2 (or both!)
	Implement an AI-controlled paddle (either the left or the right will do) such that
	it will try to deflect the ball at all times.
	
	What's done:
	1. In the Start state, game mode selection is now present (1 Player and 2 Players)
	   The selection is using 'w', 's' or 'up', 'down' keys.
	2. AI:
		The AI starts moving when the ball enters its side of the board.
		It moves half the size of the player's paddle speed.
	3. From Done state, now it is possible to go back to the Start state, so that it
	   would be possible to switch the game mode without exiting and re-opening
	   the game.
	4. Paddles' reset is implemented, so that the Paddles' position would be reset
	   after re-entering the Start state.
]]


-- library imports
push = require 'push'
Class = require 'class'

-- Import classes
require 'Ball'
require 'Paddle'

-- Constants
WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

-- Initializing the game (not necessary, but a good practice to use this function for that
function love.load()
	
	-- nearest neighbour instead of linear https://love2d.org/wiki/FilterMode
	love.graphics.setDefaultFilter('nearest','nearest')

	love.window.setTitle('Pong')
	
	math.randomseed(os.time())
	
	-- load fonts
	smallFont = love.graphics.newFont('font.ttf', 8)
	largeFont = love.graphics.newFont('font.ttf', 16)
	scoreFont = love.graphics.newFont('font.ttf', 32)
	
	-- sounds
	sounds = {
		['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		['score'] = love.audio.newSource('sounds/score.wav', 'static'),
		['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
	}
	-- simulates low-res
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})
	
	-- Score vars
	player1Score = 0
	player2Score = 0
	-- Serving
	servingPlayer = 1

	ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2,4,4)
	player1 = Paddle(10,30,5,20)
	player2 = Paddle(VIRTUAL_WIDTH - 10,VIRTUAL_HEIGHT - 30,5,20)
	
	-- Game state
	gameState = 'start'
	
	-- Game mode, single player or multiplayer
	gameMode = 1
end



function love.keypressed(key)
	if key == 'escape' then
		-- terminate app
		love.event.quit()
		
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'serve'
		elseif gameState == 'serve' then
			 gameState = 'play'
		elseif gameState == 'done' then
		
			gameState = 'serve'
			
			ball:reset()
			
			player1Score = 0
			player2Score = 0
			
			if (winningPlayer == 1) then
				servingPlayer = 2
			else
				servingPlayer = 1
			end
			
		end
		
	-- Game mode selection used paddle movement keys
	elseif gameState == 'start' and (key == 'up' or key == 'w') then
		gameMode = 1
	elseif gameState == 'start' and (key == 'down' or key == 's') then
		gameMode = 2
		
	-- Return to game mode selection
	elseif gameState == 'done' and key == 'space' then
		gameMode = 1
		player1Score = 0
		player2Score = 0
		gameState = 'start'
		player1:reset()
		player2:reset()
		servingPlayer = 1
	end
	
	
end

function love.resize(w, h)
	push:resize(w,h)
end

-- Update function, dt - deltaTime, how much time passed between frames
function love.update(dt)
	
	if gameState == 'serve' then
		ball.dy = math.random(-50, 50)
		if servingPlayer == 1 then
			ball.dx = math.random(140,200)
		else
			ball.dx = -math.random(140,200)
		end
	end
	
	if gameState == 'play' then
	
		-- Collision with the player on the left
		if ball:collides(player1) then
			ball.dx = -ball.dx * 1.03 -- speeding the game a bit
			ball.x = player1.x + 5 -- shift on the right edge of the paddle (paddle size)
		
			if ball.dy < 0 then
				ball.dy = -math.random(10,150)
			else
				ball.dy = math.random(10,150)
			end
			
			sounds['paddle_hit']:play()
		end
		
		-- Collision with the player on the right
		if ball:collides(player2) then
			ball.dx = -ball.dx * 1.03
			ball.x = player2.x - 4 -- ball size, because the x is already on the left edge of the paddle
		
			if ball.dy < 0 then
				ball.dy = -math.random(10,150)
			else
				ball.dy = math.random(10,150)
			end
			sounds['paddle_hit']:play()
			
		end
		-- Fix boundaries for the ball
		if ball.y <= 0 then
			ball.y = 0
			ball.dy = -ball.dy
			sounds['wall_hit']:play()
		end
		if ball.y >= VIRTUAL_HEIGHT - 4 then
			ball.y = VIRTUAL_HEIGHT - 4
			ball.dy = -ball.dy
			sounds['wall_hit']:play()
		end
		
		-- Scoring
		if ball.x < 0 then
			sounds['score']:play()
			servingPlayer = 1
			player2Score = player2Score + 1
			
			if player2Score == 10 then
				ball:reset()
				winningPlayer = 2
				gameState = 'done'
			else
				ball:reset()
				gameState = 'serve'
			end
		end
		
		if ball.x > VIRTUAL_WIDTH then
			sounds['score']:play()
			servingPlayer = 2
			player1Score = player1Score + 1
			
			if player1Score == 10 then
				ball:reset()
				winningPlayer = 1
				gameState = 'done'
			else
				ball:reset()
				gameState = 'serve'
			end
		end
	end
	
	-- Players will move only if not in start mode, as then the movement keys
	-- are used for game mode selections
	if gameState ~= 'start' then
		-- Player 2 Movement
		if gameMode == 2 then
			-- Multiplayer
			if love.keyboard.isDown('up') then
				player2.dy = -PADDLE_SPEED
			elseif love.keyboard.isDown('down') then
				player2.dy = PADDLE_SPEED
			else
				player2.dy = 0
			end
		else
			-- AI
			-- If the ball is on the AI half of the board (speed 2x slower than player1)
			if ball.x > VIRTUAL_WIDTH/2 then
				
				if ball.y < player2.y then
					player2.dy = -PADDLE_SPEED/2
				elseif ball.y > player2.y + player2.height then
					player2.dy = PADDLE_SPEED/2
				else
					player2.dy = 0
				end
			else
				player2.dy = 0
			end
			
		end
		
		-- Player 1 Movement
		if love.keyboard.isDown('w') then
			player1.dy = -PADDLE_SPEED
		elseif love.keyboard.isDown('s') then
			player1.dy = PADDLE_SPEED
		else	
			player1.dy = 0
		end
	end

	
	-- Ball Movement
	if gameState == 'play' then
		ball:update(dt)
	end
	
	player1:update(dt)
	player2:update(dt)
end



-- Function for rendering, called right after update function
function love.draw()

	push:apply('start')
	
	love.graphics.clear(40/255,45/255,52/255,1) --rgba, "background color"

	displayScore()
	
	if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Select the game mode and press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
		displayGameModes()
		
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
		
    elseif gameState == 'play' then
	
	elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart or Spacebar to reload the game!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
	
	ball:render()
	player1:render()
	player2:render()
	
	displayFPS()
	
	push:apply('end')
end

function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0,1,0,1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end

function displayGameModes()
	love.graphics.printf('Game mode:', VIRTUAL_WIDTH/7*3, 40, VIRTUAL_WIDTH, 'left')
	if gameMode == 1 then
		love.graphics.printf('-> 1 Player', VIRTUAL_WIDTH/7*3, 50, VIRTUAL_WIDTH, 'left')
		love.graphics.setColor(105/255,105/255,105/255,1)
		love.graphics.printf('   2 Players', VIRTUAL_WIDTH/7*3, 60, VIRTUAL_WIDTH, 'left')
	else
		love.graphics.printf('-> 2 Players', VIRTUAL_WIDTH/7*3, 60, VIRTUAL_WIDTH, 'left')
		love.graphics.setColor(105/255,105/255,105/255,1)
		love.graphics.printf('   1 Player', VIRTUAL_WIDTH/7*3, 50, VIRTUAL_WIDTH, 'left')	
	end
	-- Reset
	love.graphics.setColor(1,1,1,1)
end