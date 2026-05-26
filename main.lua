-- Global variables.

-- Reference to global scope.
_g = _ENV

debugMode = false

-- Game strings.

-- Text for start and restart.
pressAKey = "PRESS Z OR X TO "

-- Projectile object literals.
bullet = "bullet"
laser = "laser"

-- Offset for the height of the UI.
uiHeight = 8

-- Height of a bullet.
bullHeight = 3

-- Starting colour for blinking text.
blinkT = 1

-- Default collision box size - 8x8 sprite.
colDefault = 7

-- Runs once on startup.
function _init()
	cls()

	routines = {}

	waveNum = 0

	-- Setup and initialize starfield.
	-- TODO: Move to starfield module.
	stars = {}
	numOfStars = 80

	farStar = { col = 5, spd = 0.25 }

	midStar = { col = 6, spd = 0.75, isAsteroid = false }

	nearStar = { col = 7, twinkleCol = 10, spd = 2 }

	stateNames = {
		title = "title", start = "start",
		newWave = "newWave", game = "game",
		win = "win", gameOver = "gameOver"
	}

	state = stateNames.title

	-- Initial game state.
	enterTitle()

	createStarfield(true)
end

-- Update is for gameplay.
-- Hard 30fps.
function _update()
	if state == stateNames.game then
		updateGame()
	elseif state == stateNames.title then
		updateTitle()
	elseif state == stateNames.start then
		updateStart()
	elseif state == stateNames.newWave then
		updateNewWave()
	elseif state == stateNames.gameOver then
		updateGameOver()
	elseif state == stateNames.win then
		updateWin()
	end
end

-- Called when a new frame is
-- drawn to the screen (30fps).
function _draw()
	if state == stateNames.game then
		drawGameScene()
	elseif state == stateNames.title then
		drawTitle()
	elseif state == stateNames.start then
		drawStart()
	elseif state == stateNames.newWave then
		drawNewWave()
	elseif state == stateNames.gameOver then
		drawGameOver()
	elseif state == stateNames.win then
		drawWin()
	end
end