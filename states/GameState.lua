-- Game state logic.

-- Sets up the game.
function setupGame()
	-- Setup game timers (frames).
	gameT = 0
	proT = 0

	spawnDur = 50
	spawnT = 0

	-- Enemy spawn events for each wave.
	-- wave: wave number.
	-- x: Spawn x position for the row (off-screen).
	-- y: Spawn y position for the row (off-screen).
	-- rowEnemies: list of enemies to spawn in the row.
	local alien = eTypes.alien
	local redeye = eTypes.redeye
	local fighter = eTypes.fighter
	local boss = eTypes.boss
	spawnEvents = {
		{ wave = 1,
			{ x = -8, y = 24,
			rowEnemies = {
				alien,
				alien,
				alien,
				alien,
				redeye,
				redeye,
				redeye,
				alien,
				alien,
				alien,
			} },
			{ x = 136, y = 34,
			rowEnemies = {
				alien,
				alien,
				alien,
				alien,
				redeye,
				redeye,
				redeye,
				alien,
				alien,
				alien,
			} },
			{ x = 64, y = 130,
			rowEnemies = {
				fighter,
				fighter,
				fighter,
				fighter,
				fighter,
				fighter,
				fighter,
				fighter,
			} },
		},

		{ wave = 2,
			{ x = -8, y = -12,
			rowEnemies = {
				redeye,
				redeye,
				redeye,
				alien,
				alien,
				alien,
			} },
			{ x = 136, y = -12,
			rowEnemies = {
				redeye,
				redeye,
				redeye,
				alien,
				alien,
				alien,
			} },
			{ x = 64, y = -12,
			rowEnemies = {
				redeye,
				redeye,
				redeye,
				alien,
				alien,
				alien,
			} },
		},

		{ wave = 3,
			{ x = 60, y = -12,
			rowEnemies = {
				boss
			},}
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
    local waveRows = getWaveData(wave)

    if not waveRows then
        return
    end

    -- Delay for spawning rows.
    local baseGapDelay = 10
    local delayReduction = 2

    local centerX = 64 -- Center of the screen on x-axis.
    local spacing = 11 -- Spacing between small sprites in a row.

    -- Iterate through each row in the wave.
    for rowNum = 1, #waveRows do
        local row = waveRows[rowNum]

        local spriteW = (row.rowEnemies[1].sprSize or 1) * 8

        local rowSpacing = max(spacing, spriteW + 4)

        local rowDelay = (rowNum - 1) * baseGapDelay - ((rowNum - 1) * (rowNum - 2) * delayReduction) / 2

        local rowWidth = (#row.rowEnemies - 1) * rowSpacing

        local rowStartX = flr(centerX - spriteW / 2 - rowWidth / 2)

        -- Spawn each enemy in the row.
        for i = 1, #row.rowEnemies do
			-- Spawn enemy off-screen.
            local newEnemy = spawnEnemy(row.rowEnemies[i], row.x, row.y)

			-- Calculate target position for the enemy.
            local targetX = rowStartX + (i - 1) * rowSpacing
            local targetY = 10 + rowNum * 13
            local delay = flr(rowDelay)

			-- Animate enemy to target x position.
            async(function()
                wait(delay)
                animate(newEnemy, "x", targetX, spawnDur, easeOutQuad)
            end)

			-- Animate enemy to target y position.
            async(function()
                wait(delay)
                animate(newEnemy, "y", targetY, spawnDur, easeOutQuad)
            end)
        end
    end

	sfx(28)
end

-- Updates the game screen.
function updateGame()
	updateGameScene()

	spawnT += 1

	if spawnT == spawnDur then
		for e in all(enemies) do
			e:activate()
		end
	end

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
end