-- Game state logic.

-- Sets up the game.
function setupGame()
	-- Setup game timer (frames).
	gameT = 0

	spawnEvents = {
		{ wave = 1,
			{ x = 30, y = 14, num = 6, kind = eTypes.alien },
			{ x = 30, y = 26, num = 6, kind = eTypes.alien },
			{ x = 30, y = 38, num = 6, kind = eTypes.alien }
		},

		{ wave = 2,
			{ x = 30, y = 12, num = 5, kind = eTypes.ufo },
			{ x = 30, y = 24, num = 5, kind = eTypes.redeye }
		},

		{ wave = 3,
			{ x = 49, y = 12, num = 1, kind = eTypes.boss }
		}
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

	createStarfield(false)
end

-- Returns the wave data for the requested wave number.
function getWaveData(wave)
	for i = 1, #spawnEvents do
		if spawnEvents[i].wave == wave then
			return spawnEvents[i]
		end
	end
end

-- Returns true if the requested wave has any spawn events.
function hasWaveSpawnEvents(wave)
	return getWaveData(wave) ~= nil
end

-- Spawns all enemy rows for a wave.
function spawnWaveRows(wave)
	local waveData = getWaveData(wave)

	if not waveData then
		return
	end

	-- Iterate through each row in the wave.
	for rowIdx = 1, #waveData do
		local row = waveData[rowIdx]
		local xOff = 0

		-- Spawn each enemy in the row.
		for i = 1, row.num do
			local spawnX = row.x + xOff
			local spawnY = row.y
			spawnEnemy(row.kind, spawnX, spawnY)
			xOff += 9
		end
	end
end

-- Updates the game screen.
function updateGame()
	updateGameScene()

	-- Check for end of wave.
	if #enemies == 0 then
		-- Either start next wave or go to win screen.
		if hasWaveSpawnEvents(waveNum + 1) then
			enterNewWave()
			return
		else
			enterWin()
			return
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

-- Enter the game state.
function enterGame()
	state = stateNames.game
	gameT = 0
	proT = 0
	for e in all(enemies) do
		e:activate()
	end
end