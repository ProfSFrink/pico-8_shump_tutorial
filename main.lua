-- Runs once on startup.
function _init()
	cls()

	-- Game strings.

	-- Text for start and restart.
	pressAKey="PRESS Z OR X TO "

	-- Starting colour for blinking text.
	blinkT=0

	-- Setup and initialize starfield.
	stars={}
	numOfStars=100
	uiHeight=10

	farStar={colour=5, speed=0.25}

	midStar={colour=6, speed=0.75, isAsteroid=false}

	nearStar={colour=7, twinkleColour=10, speed=2}

	stateNames={title="title", start="start", 
	game="game", gameOver="gameOver"}

	state=stateNames.title

	createStarfield(true)
end

-- Update is for gameplay.
-- Hard 30fps.
function _update()
	blinkT+=1

	if state == stateNames.game then
		updateGame()
	elseif state == stateNames.title then
		updateTitle()
	elseif state == stateNames.start then
		updateStart()
	elseif state == stateNames.gameOver then
		updateGameOver()
	end
end

-- Called when a new frame is
-- drawn to the screen (30fps).
function _draw()
	if state == stateNames.game then
		drawGame()
	elseif state == stateNames.title then
		drawTitle()
	elseif state == stateNames.start then
		drawStart()
	elseif state == stateNames.gameOver then
		drawGameOver()
	end

end
