-- Game state logic.

-- Sets up the game.
function startGame()
	state = stateNames.game

	-- Setup game timer (frames).
	gameTimer = 0

	-- Points towards next spawn event.
	spawnEventIndex = 1

	-- Spawn timelines in frames (30fps).
	spawnEvent = {
		{ frame = 30, kind = eTypes.alien, spawnX = 12 },
		{ frame = 35, kind = eTypes.ufo, spawnX = 40 },
		{ frame = 45, kind = eTypes.ufo, spawnX = 70 },
		{ frame = 55, kind = eTypes.ufo, spawnX = 70 },
		{ frame = 65, kind = eTypes.ufo, spawnX = 70 },
		{ frame = 75, kind = eTypes.ufo, spawnX = 70 },
		{ frame = 100, kind = eTypes.alien, spawnX = 72 }
	}

	-- Set up the ship.
	-- x: X coordinate.
	-- y: Y coordinate.
	-- spdX: Speed in the x direction.
	-- spdY: Speed in the y direction.
	-- spr: Current ship sprite.
	-- flStrtFram: Ship flame start frame.
	-- flEndFram: Ship flame end frame.
	-- bullOffset: Offset for where bullets spawn from the ship.
	ship = {
		-- Starting position.
		x = 64,
		y = 108,
		-- Speed of the ship.
		spdX = 2,
		spdY = 2,
		-- Current ship sprite.
		spr = 3,
		-- Ship flame start & end frame.
		flStrtFram = 7,
		flEndFram = 11,
		flCurrFram = 7,
		-- Offset for bullets.
		bullOffset = 3,
		-- Size of muzzles flash.
		muzzle = 0,
		-- Invulnerability timer in frames.
		invul = 0
	}

	-- Setup player.
	player = {
		score = 0,
		lives = 4,
		bombs = 2
	}

	-- Setup for projectiles.
	projectiles = {}

	-- Tracks frames between shots.
	proTimer = 0

	-- Reset enemies table.
	enemies = {}

	-- Reset explosions table.
	exps = {}

	-- Max number of enemies on screen.
	maxEnemies = 16

	createStarfield(false)
end

-- Updates the game screen.
function updateGame()
	-- advance game timer.
	gameTimer += 1
	-- advance projectile timer.
	proTimer -= 1

	-- Reset ship sprite and speed.
	ship.spr = 3
	shipSpdX = 0
	shipSpdY = 0

	-- Controls.

	-- Checking for input.
	-- Left arrow.
	if btn(0) then
		ship.spr = 1
		shipSpdX = -ship.spdX
	end

	-- Right arrow.
	if btn(1) then
		ship.spr = 5
		shipSpdX = ship.spdX
	end

	-- Up arrow.
	if btn(2) then
		ship.spr = 2
		shipSpdY = -ship.spdY
	end

	-- Down arrow.
	if btn(3) then
		ship.spr = 2
		shipSpdY = ship.spdY
	end

	-- Fire laser if Z pressed.
	if btn(4) then
		local laserCfg = pTypes.laser

		if proTimer <= 0 then
			spawnProjectile(laserCfg, ship.x, ship.y - ship.bullOffset)
			ship.muzzle = 4
			proTimer = laserCfg.rof
		end
	end

	-- Fire bullet if X pressed.
	if btn(5) then
		local bulletCfg = pTypes.bullet

		if proTimer <= 0 then
			spawnProjectile(bulletCfg, ship.x, ship.y - ship.bullOffset)
			ship.muzzle = 4
			proTimer = bulletCfg.rof
		end
	end

	-- Move the ship.
	ship.x = ship.x + shipSpdX
	ship.y = ship.y + shipSpdY

	-- Check if we hit the
	-- bounds of the screen.
	ship.x = mid(0, ship.x, 120)
	ship.y = mid(0 + uiHeight, ship.y, 120)

	-- Trigger one-shot spawn events from frame schedule.
	local nextSpawnEvent = spawnEvent[spawnEventIndex]

	if nextSpawnEvent and gameTimer >= nextSpawnEvent.frame then
		if #enemies < maxEnemies then
			spawnEnemy(nextSpawnEvent.kind, nextSpawnEvent.spawnX)
		end
		spawnEventIndex += 1
	end

	-- Move the projectiles.
	for p in all(projectiles) do
		p:update()
	end

	-- Move the explosions.
	for x in all(exps) do
		x:update()
	end

	-- Move the enemies and
	-- check for collisions.
	for e in all(enemies) do
		e:update()

		-- Prevents enemy being hit
		-- before it appears on screen.
		if e.y > 0 then
			-- Handle projectile collisions.
			for p in all(projectiles) do
				if col(e, p) and e.dead==false then
					del(projectiles, p)

					e:hurt(p.dam)
				end
			end
		end

		-- Handle collision with ship.
		if col(e, ship) and ship.invul <= 0 then
			player.lives -= 1
			ship.invul = 60 -- 2 secs of invulnerability.
			e:hurt()
		end

	end

	-- Move any sparks.
	for s in all(sparks) do
		s:update()
	end

	if ship.invul > 0 then
		ship.invul -= 1
	end

	-- Animate ship flame.
	ship.flCurrFram += 1
	if ship.flCurrFram > ship.flEndFram then
		ship.flCurrFram = ship.flStrtFram
	end

	-- Animate the muzzle flash.
	if ship.muzzle >= 0 then
		ship.muzzle -= 1
	end

	-- Check for game over.
	if player.lives <= 0 then
		showGameOver()
		return
	end
end

-- Draws the game screen.
function drawGame()
	cls(0)
	updateStarfield()

	-- Debug info.
	if debugMode then
		showDebugUI()
	end

	-- Game screen.

	-- Ship.

	if ship.invul <= 0 then
		spr(ship.spr, ship.x, ship.y)
		spr(ship.flCurrFram, ship.x, ship.y + 8)
	else
		if sin(gameTimer / 5) < 0.1 then
			pal(2,6)
			spr(ship.spr, ship.x, ship.y)
			spr(ship.flCurrFram, ship.x, ship.y + 8)
			pal()
		end
	end

	-- Projectiles.
	for p in all(projectiles) do
		p:draw()
	end

	-- Enemies.
	for e in all(enemies) do
		e:draw()
	end

	-- Explosions.
	for x in all(exps) do
		x:draw()
	end


	-- Sparks.
	for s in all(sparks) do
		s:draw()
	end

	-- Muzzle flash.
	circfill(ship.x + 3, ship.y - 2, ship.muzzle, 7)
	circfill(ship.x + 4, ship.y - 2, ship.muzzle, 7)

	-- UI.

	rectfill(0, 0, 127, uiHeight, 1)

	local scoreStr = "SCORE: " .. player.score

	print(scoreStr, calcCenX(#scoreStr), 2, 12)

	for i = 1, 4 do
		if player.lives >= i then
			spr(13, i * 9 - 8, 1)
		else
			spr(14, i * 9 - 8, 1)
		end
	end

	for i = 1, player.bombs do
		spr(29, 90 + i * 9 - 8, 1)
	end
end