--runs once on startup
function _init()
	cls()

	--text for start and restart
	pressAKey="PRESS Z OR X TO "

	--setup and initialize starfield
	stars={}
	numOfStars=100
	uiHeight=10

	farStar={colour=5, speed=0.25}

	midStar={colour=6, speed=0.75, isAsteroid=false}

	nearStar={colour=7, twinkleColour=10, speed=2}

	blinkT=0

	states={title="title", start="start", game="game", gameOver="gameOver"}

	mode=states.title

	createStarfield(true)
end

--update is for gameplay
--hard 30fps
function _update()
	blinkT+=1

	if mode == states.game then
		updateGame()
	elseif mode == states.title then
		updateTitle()
	elseif mode == states.start then
		updateStart()
	elseif mode == states.gameOver then
		updateGameOver()
	end
end

--called when a new frame is
--drawn to the screen (30fps).
function _draw()
	if mode == states.game then
		drawGame()
	elseif mode == states.title then
		drawTitle()
	elseif mode == states.start then
		drawStart()
	elseif mode == states.gameOver then
		drawGameOver()
	end

end

--setup the game
function startGame()
	mode=states.game

	--set up the ship

	--ship's x and y coordinates
	shipX=64
	shipY=64

	--ships' speed in x and y direction
	spdX=2
	spdY=2

	--ship sprite
	shipSpr=3

	--ship flame sprite
	flameSpr=7

	--ship bullet offset
	shipBullOffset=3

	--setup for bullets
	bullets = {}

	bullet={sprStart=16, spriteEnd=17, speed=3, sfx=0}

	laser={sprStart=18, spriteEnd=21, speed=4, sfx=1}

	--setup for muzzle flash
	muzzle=0

	--setup score
	score=10000

	--setup lives and bombs
	lives=3
	bombs=2

	createStarfield(false)
end

--start game screen
function showStart()
	startTimer=0

	mode=states.start
end

--restart the game
function restartGame()
	mode=states.title
	createStarfield(true)
end
