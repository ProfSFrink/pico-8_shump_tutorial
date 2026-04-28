-- Runs once on startup.
function _init()
	cls()

	debugMode = true

	-- Game strings.

	-- Text for start and restart.
	pressAKey = "PRESS Z OR X TO "

	-- Offset for the height of the UI.
	uiHeight = 9

	initProjectiles()
	initEnemies()

	-- Height of a bullet.
	bullHeight = 4

	-- Starting colour for blinking text.
	blinkT = 0

	-- Setup and initialize starfield.
	stars = {}
	numOfStars = 80

	farStar = { col = 5, spd = 0.25 }

	midStar = { col = 6, spd = 0.75, isAsteroid = false }

	nearStar = { col = 7, twinkleCol = 10, spd = 2 }

	stateNames = {
		title = "title", start = "start",
		game = "game", gameOver = "gameOver"
	}

	state = stateNames.title

	createStarfield(true)
end

-- Update is for gameplay.
-- Hard 30fps.
function _update()
	blinkT += 1

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