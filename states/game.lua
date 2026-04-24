-- Game state logic.

-- Sets up the game.
function startGame()
	state=stateNames.game

	-- Setup game timer (frames).
	gameTimer=0

	-- Spawn timelines in frames (30fps).
	spawnEvent={
		{frame=30, type="green",spawnX=12},
		{frame=90, type="blue", spawnX=40},
		{frame=150, type="green", spawnX=72},
		{frame=210, type="blue", spawnX=100},
	}

	-- Points towards next spawn event.
	spawnEventIndex=1

	-- Max number of enemies on screen.
	maxEnemies=16

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

	-- Setup for ship muzzle flash.
	muzzle=0

	-- Setup for enemies.
	enemies={}

	initEnemies()

	noOfEnemies=4

	-- Setup score
	score=10000

	-- Setup lives and bombs.
	lives=3
	bombs=2

	createStarfield(false)
end


-- Fires a projectile from the ship.
-- @param projectileFn: The function to create the projectile (newBullet or newLaser).
-- @param cfg: The configuration for the projectile (bulletCfg or laserCfg).
function fireProjectile(projectileFn, cfg)
    add(projectiles, projectileFn(
        ship.x,
        ship.y - ship.bullOffset,
        cfg.strtFram, cfg.endFram,
        cfg.spd, cfg.animDelay
    ))
    sfx(cfg.sfx)
    muzzle=4
end

-- Updates the game screen.
function updateGame()
-- Controls.

	-- Advance timer by 1 frame.
	gameTimer+=1

	shipSpdX=0
	shipSpdY=0

	-- Checking for input.
	-- Left arrow.
	if btn(0) then
		ship.spr=1
		shipSpdX=-ship.spdX
	end

	-- Right arrow.
	if btn(1) then
		ship.spr=5
		shipSpdX=ship.spdX
	end

	-- Up arrow.
	if btn(2) then
		ship.spr=2
		shipSpdY=-ship.spdY
	end

	-- Down arrow.
	if btn(3) then
		ship.spr=2
		shipSpdY=ship.spdY
	end

	-- Fire laser if Z pressed.
	if btnp(projectileTypes.laser.btn) then
		fireProjectile(projectileTypes.laser.factory, projectileTypes.laser)
	end

	-- Fire bullet if X pressed.
	if btnp(projectileTypes.bullet.btn) then
		fireProjectile(projectileTypes.bullet.factory, projectileTypes.bullet)
	end

	-- Moving the ship.
	ship.x=ship.x+shipSpdX
	ship.y=ship.y+shipSpdY

	-- Trigger one-shot spawn events from frame schedule.
	local nextSpawnEvent=spawnEvent[spawnEventIndex]

	if nextSpawnEvent and gameTimer>=nextSpawnEvent.frame then
		if #enemies<maxEnemies then
			spawnEnemy(enemyType[nextSpawnEvent.type], nextSpawnEvent.spawnX)
		end
		spawnEventIndex+=1
	end

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
	-- bounds of the screen.
	ship.x=mid(0,ship.x,120)
	ship.y=mid(0+uiHeight,ship.y,120)
end

-- Draws the game screen.
function drawGame()
	cls(0)
	updateStarfield()

	?#projectiles, 0, 123, 7
	?#enemies, 7, 123, 3

	?shipSpdX, 0, 63, 7
	?shipSpdY, 0, 70, 7

	?"t:"..gameTimer, 105, 123, 7

	spr(ship.spr,ship.x,ship.y)
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