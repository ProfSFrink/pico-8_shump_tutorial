-- Game state logic.

-- Sets up the game.
function setupGame()
	-- Setup game timer (frames).
	gameT = 0

	-- Points towards next spawn event.
	spawnEventIndex = 1

	-- Spawn timelines in frames (30fps).
	spawnEvent = {
		{ wave = 1, frame = 30, kind = eTypes.alien,
			spawnX = 20, spawnY = 0 },
		{ wave = 1, frame = 30, kind = eTypes.alien,
			spawnX = 30, spawnY = 0 },
		{ wave = 1, frame = 30, kind = eTypes.alien,
			spawnX = 40, spawnY = 0 },
		{ wave = 1, frame = 30, kind = eTypes.alien,
			spawnX = 50, spawnY = 0 },
		{ wave = 2, frame = 55, kind = eTypes.fighter,
			spawnX = ranInt(0, 120), spawnY = 0 },
		{ wave = 2, frame = 65, kind = eTypes.fighter,
			spawnX = ranInt(0, 120), spawnY = 0 },
		{ wave = 2, frame = 75, kind = eTypes.fighter,
			spawnX = ranInt(0, 120), spawnY = 0 },
		{ wave = 2, frame = 100, kind = eTypes.fighter,
			spawnX = ranInt(0, 120), spawnY = 0 },
		{ wave = 3, frame = 30, kind = eTypes.boss,
			spawnX = 67, spawnY = 0 }
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

	-- Prevents enemies spawning until the new wave screen has finished.
	spawnOn = false

	-- Reset enemies table.
	enemies = {}

	-- Reset explosions table.
	exps = {}

	-- Reset spark table.
	sparks = {}

	-- Reset shockwave table.
	shwaves = {}

	createStarfield(false)
end

-- Returns the first spawn event index for the requested wave.
function getWaveStartEventIndex(wave)
	for i = 1, #spawnEvent do
		if spawnEvent[i].wave == wave then
			return i
		end
	end
end

-- Returns the next spawn event index for the requested wave.
function getNextWaveEventIndex(wave, startIndex)
	for i = startIndex, #spawnEvent do
		local event = spawnEvent[i]
		if event.wave == wave then
			return i
		elseif event.wave > wave then
			return nil
		end
	end
end

-- Returns true when the requested wave has any spawn events.
function hasWaveSpawnEvents(wave)
	return getWaveStartEventIndex(wave) ~= nil
end

-- Updates shared gameplay simulation.
function updateGameplay()
	-- advance game timer.
	gameT += 1

	-- Decrease projectile timer.
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

	-- Fire bullet if X pressed.
	if btn(5) then
		local proCfg = getConfig(bullet)

		if proT <= 0 then
			spawnProjectile(proCfg, ship.x, ship.y - ship.bullOffset)
			ship.muzzle = 4
			proT = proCfg.rof
		end
	end

	-- Fire laser if Z pressed.
	if btn(4) then
		local proCfg = getConfig(laser)

		if proT <= 0 then
			spawnProjectile(proCfg, ship.x, ship.y - ship.bullOffset)
			ship.muzzle = 4
			proT = proCfg.rof
		end
	end


	-- Update ship position.
	ship:update()

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
				if col(e, p) and not e.isDead then
					e:hit(p.dam)
					spawnShockWave(p.x, p.y, slSwCfg)
					spawnSparks(e.x, e.y, 7)
					del(projectiles, p)
				end
			end
		end

		-- Handle collision with ship.
		if col(e, ship) and ship.invul <= 0 then
			player.lives -= 1
			e:hit()
			if player.lives <= 0 then
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
		if ship:isDead() then
			enterGameOver()
			return
		end
	end
end

-- Updates the game screen.
function updateGame()
	-- Trigger one-shot spawn events from frame schedule.

	-- Index of the next spawn event.
	local nextSpawnIndex =
		getNextWaveEventIndex(waveNum, spawnEventIndex)

	-- The actual next spawn event.
	local nextSpawnEvent = nextSpawnIndex
		and spawnEvent[nextSpawnIndex]

	--  True if the next spawn event is ready to trigger.
	local newSpawnReady = nextSpawnEvent
		and gameT >= nextSpawnEvent.frame and spawnOn

	-- Trigger the spawn event if ready.
	if newSpawnReady then
		spawnEnemy(nextSpawnEvent.kind, nextSpawnEvent.spawnX, nextSpawnEvent.spawnY)
		spawnEventIndex = nextSpawnIndex + 1
	end

	updateGameplay()

	-- Check for end of wave.
	local noMoreWaves = getNextWaveEventIndex(waveNum, spawnEventIndex) == nil and #enemies == 0

	-- Either start next wave or go to win screen.
	if noMoreWaves then
		if hasWaveSpawnEvents(waveNum + 1) then
			enterNewWave()
			return
		else
			enterWin()
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
	if player.lives > 0 then
		ship:draw(gameT)
	end

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

	-- TODO: Abstract UI.

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

-- Enter the game state.
function enterGame()
	state = stateNames.game
	gameT = 0
	proT = 0
	spawnEventIndex = getWaveStartEventIndex(waveNum) or (#spawnEvent + 1)
end