-- Game state logic.

-- Sets up the game.
function startGame()
	state=stateNames.game

	-- Set up the ship.

	-- Ship's x and y coordinates.
	shipX=64
	shipY=108

	-- Ship's speed in x and y direction.
	spdX=2
	spdY=2

	-- Ship sprite.
	shipSpr=3

	-- Ship flame sprite.
	flameSpr=7

	-- Ship bullet offset.
	shpBullOffset=3

	-- Setup for projectiles.
	projectiles = {}

	-- Setup for bullets & lasers.
	-- strtFram: Starting frame of the bullet's animation.
	-- endFram: Ending frame of the bullet's animation.
	-- spd: Speed of the bullet.
	bullet={
		strtFram=16,
		endFram=17,
		spd=3,
		sfx=0
	}

	laser={
		strtFram=18,
		endFram=21,
		spd=4,
		sfx=1
	}

	-- Setup for muzzle flash.
	muzzle=0

	-- Setup score
	score=10000

	-- Setup lives and bombs.
	lives=3
	bombs=2

	createStarfield(false)
end

-- Updates the game screen.
function updateGame()
-- Controls.
	shipSpdX=0
	shipSpdY=0
	shipSpr=3

	-- Checking for input.
	-- Left arrow.
	if btn(0) then
		shipSpr=1
		shipSpdX=-spdX
	end

	-- Right arrow.
	if btn(1) then
		shipSpr=5
		shipSpdX=spdX
	end

	-- Up arrow.
	if btn(2) then
		shipSpr=2
		shipSpdY=-spdY
	end

	-- Down arrow.
	if btn(3) then
		shipSpr=2
		shipSpdY=spdY
	end

	-- Fire laser if Z pressed.
	if btnp(4) then
		add(projectiles, newLaser(shipX,
		shipY - shpBullOffset,
		laser.strtFram, laser.endFram,
		laser.spd))

		sfx(laser.sfx)
		muzzle=4
	end

	-- Fire bullet if X pressed.
	if btnp(5) then
		add(projectiles, newBullet(shipX,
			shipY - shpBullOffset,
			bullet.strtFram, bullet.endFram,
			bullet.spd))

		sfx(bullet.sfx)
		muzzle=4
	end

	-- Moving the ship.
	shipX=shipX+shipSpdX
	shipY=shipY+shipSpdY

	-- Moving the projectiles.
	for p in all(projectiles) do
		p:update()
	end

	-- Animate ship flame.
	flameSpr=flameSpr+1

	-- Loop the flame animation.
	if flameSpr>11 then
		flameSpr=7
	end

	-- Animate the muzzle flash.
	if muzzle>=0 then
		muzzle=muzzle-1
	end

	-- Checking if we hit the
	-- Horizontal bounds of the screen.
	if shipX>120 then
		shipX=120
	end

	if shipX<0 then
		shipX=0
	end

	if shipY>120 then
		shipY=120
	end

	if shipY<0 then
		shipY=0
	end
end

-- Draws the game screen.
function drawGame()
	cls(0)
	updateStarfield()

	?"PROJECTILES: "..#projectiles, 0, 123, 7

	spr(shipSpr,shipX,shipY)
	spr(flameSpr,shipX,shipY+8)

	for p in all(projectiles) do
		p:draw()
	end

	circfill(shipX+3,shipY-2,muzzle,7)
	circfill(shipX+4,shipY-2,muzzle,7)

    rectfill(0,0,127,uiHeight,1)

    local scoreStr = "SCORE: "..score

	?scoreStr,calcCenX(#scoreStr),2,12

	for i=1,4 do
		if lives>=i then
			spr(13,i*9-8,1)
		else
			spr(14,i*9-8,1)
		end
	end

	for i=1,bombs do
		spr(29,90+i*9-8,1)
	end
end