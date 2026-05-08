-- Game state logic.

-- todo: abstract the ship to its own component file.

-- Sets up the game.
function startGame()
	state = stateNames.game

	-- Setup game timer (frames).
	gameT = 0

	-- Points towards next spawn event.
	spawnEventIndex = 1

	-- Spawn timelines in frames (30fps).
	spawnEvent = {
		{ frame = 30, kind = eTypes.alien,
			spawnX = ranInt(0, 120) },
		{ frame = 35, kind = eTypes.ufo,
			spawnX = ranInt(0, 120) },
		{ frame = 45, kind = eTypes.ufo,
			spawnX = ranInt(0, 120) },
		{ frame = 55, kind = eTypes.eyeball,
			spawnX = ranInt(0, 120) },
		{ frame = 65, kind = eTypes.ufo,
			spawnX = ranInt(0, 120) },
		{ frame = 75, kind = eTypes.eyeball,
			spawnX = ranInt(0, 120) },
		{ frame = 100, kind = eTypes.alien,
			spawnX = ranInt(0, 120) }
	}

	-- Setup player ship.
	ship = newShip()

	-- Setup player.
	player = {
		score = 0,
		lives = 2,
		bombs = 2
	}

	-- Setup for projectiles.
	projectiles = {}

	-- Tracks frames between shots.
	proT = 0

	-- Reset enemies table.
	enemies = {}

	-- Reset explosions table.
	exps = {}

	-- Reset spark table.
	sparks = {}

	-- Reset shockwave table.
	shwaves = {}

	-- Max number of enemies on screen.
	maxEnemies = 16

	createStarfield(false)
end

-- Updates the game screen.
function updateGame()
	-- advance game timer.
	gameT += 1
	-- advance projectile timer.
	proT -= 1

	-- Reset ship sprite and speed.
	ship:reset()

	-- Controls.

	-- Checking for input.
	-- Left arrow.
	if btn(0) then
		ship:move("left")
	end

	-- Right arrow.
	if btn(1) then
		ship:move("right")
	end

	-- Up arrow.
	if btn(2) then
		ship:move("up")
	end

	-- Down arrow.
	if btn(3) then
		ship:move("down")
	end

	-- Fire laser if Z pressed.
	if btn(4) then
		-- local proCfg = getConfig(laser)

		-- if proT <= 0 then
		-- 	spawnProjectile(proCfg, ship.x, ship.y - ship.bullOffset)
		-- 	ship.muzzle = 4
		-- 	proT = proCfg.rof
		-- end

		spawnEnemy(eTypes.flame, ranInt(0, 120))
	end

	-- Fire bullet if X pressed.
	if btn(5) then
		local proCfg = getConfig(bullet)

		if proT <= 0 then
			spawnProjectile(proCfg, ship.x, ship.y - ship.bullOffset)
			ship.muzzle = 4
			proT = proCfg.rof
		end
	end

	-- Update ship position.
	ship:update()

	-- Trigger one-shot spawn events from frame schedule.
	local nextSpawnEvent = spawnEvent[spawnEventIndex]

	if nextSpawnEvent and gameT >= nextSpawnEvent.frame then
		if #enemies < maxEnemies then
			spawnEnemy(nextSpawnEvent.kind, nextSpawnEvent.spawnX)
		end
		spawnEventIndex += 1
	end

	-- Move the starfield.
	updateStarfield()

	-- Move the projectiles.
	updateProjectiles()

	-- Move any shockwaves.
	updateShockWaves()

	-- Move any sparks.
	updateSparks()

	-- Move the explosions.
	updateExplosions()

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
					e:hurt(p.dam)
					spawnShockWave(p.x, p.y, slSwCfg)
					spawnSparks(e.x, e.y, 7)
					del(projectiles, p)
				end
			end
		end

		-- Handle collision with ship.
		if col(e, ship) and ship.invul <= 0 then
			player.lives -= 1
			e:hurt()
			if player.lives <= 0 then
				ship.dTimer = 30
				ship.invul = 30
				spawnExp(ship.x, ship.y, 0, shipCols)
				spawnShockWave(ship.x, ship.y, lgSwCfg)
			else
				ship.invul = 60 -- 2 secs of invulnerability.
			end
		end

	end

	-- Check for game over.
	if player.lives <= 0 then
		if ship:dead() == false then
			showGameOver()
			return
		end
	end
end

-- Draws the game screen.
function drawGame()
	cls()
	drawStarfield()

	-- Debug info.
	if debugMode then
		showDebugUI()
	end

	-- Game screen.

	ship:draw(gameT)

	-- Projectiles.
	drawProjectiles()

	-- Enemies.
	drawEnemies()

	-- Sparks.
	drawSparks()

	-- Shockwaves.
	drawShockWaves()

	-- Explosions.
	drawExplosions()

	-- UI.

	rectfill(0, 0, 127, uiHeight, 1)

	local scoreStr = "SCORE: " .. player.score

	print(scoreStr, calcCenX(#scoreStr), 2, 12)

	local uiX = 0

	for i = 1, 4 do
		uiX = i * 9 - 8
		if player.lives >= i then
			spr(13, uiX, 1)
		else
			spr(14, uiX, 1)
		end
	end

	for i = 1, player.bombs do
		spr(29, 90 + uiX, 1)
	end
end