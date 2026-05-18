-- Game state logic.

-- Sets up the game.
function setupGame()
	-- Setup game timer (frames).
	gameT = 0

	-- Enemy spawn events for each wave.
	-- wave: wave number.
	-- x: starting x position for the row.
	-- y: starting y position for the row.
	-- num: number of enemies in the row.
	-- enemy: type of enemy to spawn (from eTypes).
	spawnEvents = {
		{ wave = 1,
			{ x = -8, y = 24, num = 7, enemy = eTypes.alien, spawnDur = 50 },
			{ x = 136, y = 34, num = 6, enemy = eTypes.alien, spawnDur = 50 },
			{ x = -8, y = 44, num = 5, enemy = eTypes.alien, spawnDur = 50 },
		},

		{ wave = 2,
			{ x = 64, y = -12, num = 5,
			enemy = eTypes.ufo, spawnDur = 55 },
			{ x = 64, y = -12, num = 5,
			enemy = eTypes.eyeball, spawnDur = 55 },
		},

		{ wave = 3,
			{ x = 60, y = -12, num = 1,
			enemy = eTypes.boss, spawnDur = 55 }
		},
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

    -- Delay for spawning rows.
    local baseGapDelay = 10
    local delayReduction = 2

    local centerX = 64 -- Center of the screen on x-axis.
    local spacing = 11 -- Spacing between small sprites in a row.

    -- Iterate through each row in the wave.
    for rowIdx = 1, #waveData do
        local row = waveData[rowIdx]

        local spriteW = (row.enemy.sprSize or 1) * 8

        local rowSpacing = max(spacing, spriteW + 3)

        local rowDelay = (rowIdx - 1) * baseGapDelay - ((rowIdx - 1) * (rowIdx - 2) * delayReduction) / 2

        local rowWidth = (row.num - 1) * rowSpacing

        local rowStartX = flr(centerX - spriteW / 2 - rowWidth / 2)

        -- Spawn each enemy in the row.
        for i = 1, row.num do
            local newEnemy = spawnEnemy(row.enemy, row.x, row.y)

            local targetX = rowStartX + (i - 1) * rowSpacing
            local targetY = 10 + rowIdx * 10
            local delay = flr(rowDelay)

            async(function()
                wait(delay)
                animate(newEnemy, "x", targetX, row.spawnDur, easeOutQuad)
            end)

            async(function()
                wait(delay)
                animate(newEnemy, "y", targetY, row.spawnDur, easeOutQuad)
            end)
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