-- Game state logic.

-- Sets up the game.
function startGame()
	state=stateNames.game

	-- Set up the ship.
	-- x: X coordinate.
	-- y: Y coordinate.
	-- spdX: Speed in the x direction.
	-- spdY: Speed in the y direction.
	-- spr: Ship sprite.
	-- flameSpr: Ship flame sprite.
	-- bullOffset: Offset for where bullets spawn from the ship.
	ship={
		x=64,
		y=108,
		spdX=2,
		spdY=2,
		spr=3,
		flameSpr=7,
		bullOffset=3
	}

	-- Setup for projectiles.
	projectiles = {}

	-- Setup for bullets & lasers.
	-- strtFram: Starting frame of the bullet's animation.
	-- endFram: Ending frame of the bullet's animation.
	-- animDelay: Frames before the bullet's animation advances.
	-- spd: Speed of the bullet.
	bullet={
		strtFram=16,
		endFram=17,
		animDelay=5,
		spd=3,
		sfx=0
	}

	laser={
		strtFram=18,
		endFram=21,
		animDelay=6,
		spd=4,
		sfx=1
	}

	-- Setup for ship muzzle flash.
	muzzle=0

	-- Setup for enemies.
	enemies={}

	-- Setup for an enemy.
	-- x: x coordinate.
	-- y: y coordinate.
	-- strtFram: Starting frame of the enemy's animation.
	-- endFram: Ending frame of the enemy's animation.
	-- animDelay: Frames before the enemy's animation advances.
	-- spd: Enemy speed.
	-- spr: Enemy sprite.
	enemy={
		x=0,
		y=-8,
		strtFram=48,
		endFram=51,
		animDelay=3,
		spd=0.5
	}

	noOfEnemies=4

	-- Setup score
	score=10000

	-- Setup lives and bombs.
	lives=3
	bombs=2

	createStarfield(false)
	createEnemy()
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
		shipSpdX=-ship.spdX
	end

	-- Right arrow.
	if btn(1) then
		shipSpr=5
		shipSpdX=ship.spdX
	end

	-- Up arrow.
	if btn(2) then
		shipSpr=2
		shipSpdY=-ship.spdY
	end

	-- Down arrow.
	if btn(3) then
		shipSpr=2
		shipSpdY=ship.spdY
	end

	-- Fire laser if Z pressed.
	if btnp(4) then
		add(projectiles, newLaser(ship.x,
		ship.y - ship.bullOffset,
		laser.strtFram, laser.endFram,
		laser.spd))

		sfx(laser.sfx)
		muzzle=4
	end

	-- Fire bullet if X pressed.
	if btnp(5) then
		add(projectiles, newBullet(ship.x,
			ship.y - ship.bullOffset,
			bullet.strtFram, bullet.endFram,
			bullet.spd))

		sfx(bullet.sfx)
		muzzle=4
	end

	-- Moving the ship.
	ship.x=ship.x+shipSpdX
	ship.y=ship.y+shipSpdY

	-- Move the enemies.
	for e in all(enemies) do
		e:update()
	end

	-- Moving the projectiles.
	for p in all(projectiles) do
		p:update()
	end

	-- Animate ship flame.
	ship.flameSpr+=1

	-- Loop the flame animation.
	if ship.flameSpr>11 then
		ship.flameSpr=7
	end

	-- Animate the muzzle flash.
	if muzzle>=0 then
		muzzle-=1
	end

	-- Checking if we hit the
	-- Horizontal bounds of the screen.
	if ship.x>120 then
		ship.x=120
	end

	if ship.x<0 then
		ship.x=0
	end

	if ship.y>120 then
		ship.y=120
	end

	if ship.y<0 then
		ship.y=0
	end
end

-- Draws the game screen.
function drawGame()
	cls(0)
	updateStarfield()

	?#projectiles, 0, 123, 7
	?#enemies, 7, 123, 3

	?shipSpdX, 0, 63, 7
	?shipSpdY, 0, 70, 7

	spr(shipSpr,ship.x,ship.y)
	spr(ship.flameSpr,ship.x,ship.y+8)

	for e in all(enemies) do
		e:draw()
	end

	for p in all(projectiles) do
		p:draw()
	end

	circfill(ship.x+3,ship.y-2,muzzle,7)
	circfill(ship.x+4,ship.y-2,muzzle,7)

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